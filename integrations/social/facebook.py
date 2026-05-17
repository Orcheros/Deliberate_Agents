"""Facebook provider using Unipile API.

Implements unified SocialProvider interface for Facebook.
Supports link previews via metadata={"link": url}.
"""

import os
import sys
import json
from datetime import datetime, timedelta
from typing import Optional

import requests

from .base import SocialProvider


class FacebookProvider(SocialProvider):
    """Facebook provider using Unipile API (https://unipile.com)."""

    platform = "facebook"
    BASE_URL = "https://api.unipile.com/api/v1"

    def __init__(self, api_key: str = None, account_id: str = None):
        self.api_key = api_key or os.environ.get("UNIPILE_API_KEY")
        self.account_id = account_id or os.environ.get("UNIPILE_FACEBOOK_ACCOUNT_ID")
        if not self.api_key:
            raise ValueError("UNIPILE_API_KEY environment variable required")
        if not self.account_id:
            raise ValueError("UNIPILE_FACEBOOK_ACCOUNT_ID environment variable required")
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        })

    def _request(self, method: str, endpoint: str, **kwargs) -> dict:
        """Make authenticated request to Unipile API."""
        url = f"{self.BASE_URL}{endpoint}"
        response = self.session.request(method, url, **kwargs)
        response.raise_for_status()
        return response.json()

    def publish_post(self, content: str, media_urls: Optional[list[str]] = None, metadata: Optional[dict] = None) -> dict:
        metadata = metadata or {}

        payload = {
            "account_id": self.account_id,
            "text": content,
        }
        if media_urls:
            payload["media"] = [{"url": url} for url in media_urls]
        # Link preview support
        if metadata.get("link"):
            payload["link"] = metadata["link"]

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
            "likes": result.get("reactions", 0),
            "comments": result.get("comments", 0),
            "shares": result.get("shares", 0),
            "engagement_rate": result.get("engagement_rate", 0.0),
            "platform_specific": {
                "reactions_breakdown": result.get("reactions_breakdown", {}),
                "reach": result.get("reach", 0),
                "clicks": result.get("clicks", 0),
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
                    "likes": post.get("metrics", {}).get("reactions", 0),
                    "comments": post.get("metrics", {}).get("comments", 0),
                    "shares": post.get("metrics", {}).get("shares", 0),
                },
            })
        return posts
