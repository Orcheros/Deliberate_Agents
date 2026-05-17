"""Twitter/X provider using Unipile API.

Implements unified SocialProvider interface for Twitter/X.
Supports thread mode and character limit detection (280 standard / 25000 premium).
"""

import os
import sys
import json
from datetime import datetime, timedelta
from typing import Optional

import requests

from .base import SocialProvider


class TwitterProvider(SocialProvider):
    """Twitter/X provider using Unipile API (https://unipile.com)."""

    platform = "twitter"
    BASE_URL = "https://api.unipile.com/api/v1"
    CHAR_LIMIT_STANDARD = 280
    CHAR_LIMIT_PREMIUM = 25000

    def __init__(self, api_key: str = None, account_id: str = None):
        self.api_key = api_key or os.environ.get("UNIPILE_API_KEY")
        self.account_id = account_id or os.environ.get("UNIPILE_TWITTER_ACCOUNT_ID")
        if not self.api_key:
            raise ValueError("UNIPILE_API_KEY environment variable required")
        if not self.account_id:
            raise ValueError("UNIPILE_TWITTER_ACCOUNT_ID environment variable required")
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        })
        self._char_limit = None

    def _request(self, method: str, endpoint: str, **kwargs) -> dict:
        """Make authenticated request to Unipile API."""
        url = f"{self.BASE_URL}{endpoint}"
        response = self.session.request(method, url, **kwargs)
        response.raise_for_status()
        return response.json()

    @property
    def char_limit(self) -> int:
        """Detect character limit based on account type."""
        if self._char_limit is None:
            try:
                account_info = self._request("GET", f"/accounts/{self.account_id}")
                is_premium = account_info.get("is_premium", False)
                self._char_limit = self.CHAR_LIMIT_PREMIUM if is_premium else self.CHAR_LIMIT_STANDARD
            except Exception:
                self._char_limit = self.CHAR_LIMIT_STANDARD
        return self._char_limit

    def _publish_thread(self, thread_parts: list[str], media_urls: Optional[list[str]] = None) -> dict:
        """Publish a Twitter thread (multiple connected tweets)."""
        results = []
        reply_to_id = None
        for i, part in enumerate(thread_parts):
            payload = {
                "account_id": self.account_id,
                "text": part,
            }
            if reply_to_id:
                payload["reply_to"] = reply_to_id
            # Attach media only to the first tweet
            if i == 0 and media_urls:
                payload["media"] = [{"url": url} for url in media_urls]
            result = self._request("POST", "/posts", json=payload)
            reply_to_id = result.get("id", "")
            results.append(result)

        first = results[0] if results else {}
        return {
            "post_id": first.get("id", ""),
            "url": first.get("url", ""),
            "published_at": datetime.utcnow().isoformat(),
            "platform": self.platform,
            "thread_ids": [r.get("id", "") for r in results],
        }

    def publish_post(self, content: str, media_urls: Optional[list[str]] = None, metadata: Optional[dict] = None) -> dict:
        metadata = metadata or {}

        # Thread mode: publish multiple connected tweets
        if metadata.get("thread") and metadata.get("thread_parts"):
            return self._publish_thread(metadata["thread_parts"], media_urls)

        # Validate character limit
        if len(content) > self.char_limit:
            raise ValueError(
                f"Content exceeds Twitter character limit: {len(content)}/{self.char_limit}. "
                f"Use metadata={{'thread': True, 'thread_parts': [...]}} for threads."
            )

        payload = {
            "account_id": self.account_id,
            "text": content,
        }
        if media_urls:
            payload["media"] = [{"url": url} for url in media_urls]

        result = self._request("POST", "/posts", json=payload)
        return {
            "post_id": result.get("id", ""),
            "url": result.get("url", ""),
            "published_at": datetime.utcnow().isoformat(),
            "platform": self.platform,
        }

    def get_post_metrics(self, post_id: str) -> dict:
        result = self._request("GET", f"/posts/{post_id}/analytics")
        return {
            "impressions": result.get("impressions", 0),
            "likes": result.get("likes", 0),
            "comments": result.get("replies", 0),
            "shares": result.get("retweets", 0),
            "engagement_rate": result.get("engagement_rate", 0.0),
            "platform_specific": {
                "retweets": result.get("retweets", 0),
                "quote_tweets": result.get("quote_tweets", 0),
                "bookmarks": result.get("bookmarks", 0),
            },
        }

    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        cutoff = (datetime.utcnow() - timedelta(hours=since_hours)).isoformat()
        result = self._request("GET", "/notifications", params={"since": cutoff, "account_id": self.account_id})
        engagements = []
        for item in result.get("items", []):
            engagements.append({
                "type": item.get("type", "unknown"),
                "user": item.get("user", {}).get("name", "unknown"),
                "post_id": item.get("post_id", ""),
                "timestamp": item.get("timestamp", ""),
                "content": item.get("content", ""),
            })
        return engagements

    def get_my_posts(self, limit: int = 20) -> list[dict]:
        result = self._request("GET", "/posts", params={"account_id": self.account_id, "limit": limit})
        posts = []
        for post in result.get("items", []):
            posts.append({
                "post_id": post.get("id", ""),
                "content": post.get("text", ""),
                "published_at": post.get("published_at", ""),
                "metrics": {
                    "impressions": post.get("metrics", {}).get("impressions", 0),
                    "likes": post.get("metrics", {}).get("likes", 0),
                    "comments": post.get("metrics", {}).get("replies", 0),
                    "shares": post.get("metrics", {}).get("retweets", 0),
                },
            })
        return posts
