"""Hacker News provider using Firebase API (read) + form submission (write).

Implements unified SocialProvider interface for Hacker News.
publish_post: metadata={"type": "story"|"show_hn"|"comment", "parent_id": str}
Read-only metrics (upvotes, comments from Firebase API).
"""

import os
import sys
import json
import re
from datetime import datetime, timedelta
from typing import Optional

import requests

from .base import SocialProvider


class HackerNewsProvider(SocialProvider):
    """Hacker News provider using Firebase API and cookie-based auth for posting."""

    platform = "hackernews"
    FIREBASE_URL = "https://hacker-news.firebaseio.com/v0"
    HN_BASE_URL = "https://news.ycombinator.com"

    def __init__(self, username: str = None, password: str = None):
        self.username = username or os.environ.get("HN_USERNAME")
        self.password = password or os.environ.get("HN_PASSWORD")
        if not self.username:
            raise ValueError("HN_USERNAME environment variable required")
        if not self.password:
            raise ValueError("HN_PASSWORD environment variable required")
        self.session = requests.Session()
        self._authenticated = False

    def _authenticate(self):
        """Authenticate via HN login form to get session cookie."""
        if self._authenticated:
            return
        login_data = {
            "acct": self.username,
            "pw": self.password,
            "goto": "news",
        }
        response = self.session.post(f"{self.HN_BASE_URL}/login", data=login_data)
        # HN returns 302 on successful login
        if "user" not in self.session.cookies.get_dict() and response.status_code not in (200, 302):
            raise RuntimeError("Failed to authenticate with Hacker News")
        self._authenticated = True

    def _get_fnid(self, page_url: str) -> str:
        """Get form nonce ID (fnid) from an HN page for submission."""
        response = self.session.get(page_url)
        response.raise_for_status()
        match = re.search(r'name="fnid" value="([^"]+)"', response.text)
        if not match:
            raise RuntimeError("Could not extract fnid from HN page")
        return match.group(1)

    def _firebase_request(self, endpoint: str) -> dict:
        """Make request to HN Firebase API (public, no auth needed)."""
        url = f"{self.FIREBASE_URL}{endpoint}.json"
        response = requests.get(url)
        response.raise_for_status()
        return response.json()

    def publish_post(self, content: str, media_urls: Optional[list[str]] = None, metadata: Optional[dict] = None) -> dict:
        metadata = metadata or {}
        post_type = metadata.get("type", "story")
        parent_id = metadata.get("parent_id")

        self._authenticate()

        if post_type == "comment":
            if not parent_id:
                raise ValueError("Comment posts require metadata={'parent_id': 'item_id'}")
            # Submit comment
            comment_url = f"{self.HN_BASE_URL}/comment"
            payload = {
                "parent": parent_id,
                "goto": f"item?id={parent_id}",
                "text": content,
            }
            # Get HMAC from reply page
            reply_page = self.session.get(f"{self.HN_BASE_URL}/reply?id={parent_id}")
            hmac_match = re.search(r'name="hmac" value="([^"]+)"', reply_page.text)
            if hmac_match:
                payload["hmac"] = hmac_match.group(1)

            response = self.session.post(comment_url, data=payload)
            # HN doesn't return the comment ID directly; we infer success from 302
            return {
                "post_id": f"comment-on-{parent_id}",
                "url": f"{self.HN_BASE_URL}/item?id={parent_id}",
                "published_at": datetime.utcnow().isoformat(),
                "platform": self.platform,
            }
        else:
            # Submit story or Show HN
            submit_url = f"{self.HN_BASE_URL}/submit"
            fnid = self._get_fnid(submit_url)

            title = metadata.get("title", content[:80])
            if post_type == "show_hn" and not title.startswith("Show HN:"):
                title = f"Show HN: {title}"

            # Determine if URL submission or text post
            link_url = media_urls[0] if media_urls else metadata.get("url")

            payload = {
                "fnid": fnid,
                "title": title,
            }
            if link_url:
                payload["url"] = link_url
            else:
                payload["text"] = content

            response = self.session.post(f"{self.HN_BASE_URL}/r", data=payload)

            # Try to extract the new item ID from redirect
            post_id = "unknown"
            if response.url and "id=" in response.url:
                post_id = response.url.split("id=")[-1]

            return {
                "post_id": post_id,
                "url": f"{self.HN_BASE_URL}/item?id={post_id}",
                "published_at": datetime.utcnow().isoformat(),
                "platform": self.platform,
            }

    def get_post_metrics(self, post_id: str) -> dict:
        item = self._firebase_request(f"/item/{post_id}")
        if not item:
            return {"impressions": 0, "likes": 0, "comments": 0, "shares": 0, "engagement_rate": 0.0, "platform_specific": {}}

        score = item.get("score", 0)
        descendants = item.get("descendants", 0)  # Total comment count
        # HN doesn't provide impression/view data
        # Estimate: typical HN story gets ~20x score in views
        estimated_impressions = score * 20

        return {
            "impressions": estimated_impressions,
            "likes": score,
            "comments": descendants,
            "shares": 0,
            "engagement_rate": round((descendants / estimated_impressions * 100) if estimated_impressions > 0 else 0.0, 2),
            "platform_specific": {
                "score": score,
                "descendants": descendants,
                "type": item.get("type", ""),
                "by": item.get("by", ""),
            },
        }

    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        cutoff = datetime.utcnow() - timedelta(hours=since_hours)
        cutoff_timestamp = int(cutoff.timestamp())

        # Get our submitted stories
        user_data = self._firebase_request(f"/user/{self.username}")
        if not user_data:
            return []

        submitted = user_data.get("submitted", [])[:20]  # Check last 20 submissions
        engagements = []

        for item_id in submitted:
            item = self._firebase_request(f"/item/{item_id}")
            if not item:
                continue

            # Check if this item has recent kids (comments)
            kids = item.get("kids", [])
            for kid_id in kids[:10]:  # Check first 10 replies
                kid = self._firebase_request(f"/item/{kid_id}")
                if kid and kid.get("time", 0) >= cutoff_timestamp:
                    engagements.append({
                        "type": "comment",
                        "user": kid.get("by", "unknown"),
                        "post_id": str(item_id),
                        "timestamp": datetime.utcfromtimestamp(kid.get("time", 0)).isoformat(),
                        "content": kid.get("text", "")[:200],
                    })

        return engagements

    def get_my_posts(self, limit: int = 20) -> list[dict]:
        user_data = self._firebase_request(f"/user/{self.username}")
        if not user_data:
            return []

        submitted = user_data.get("submitted", [])[:limit]
        posts = []

        for item_id in submitted:
            item = self._firebase_request(f"/item/{item_id}")
            if not item or item.get("type") not in ("story", "poll"):
                continue

            posts.append({
                "post_id": str(item_id),
                "content": item.get("title", ""),
                "published_at": datetime.utcfromtimestamp(item.get("time", 0)).isoformat(),
                "metrics": {
                    "impressions": item.get("score", 0) * 20,
                    "likes": item.get("score", 0),
                    "comments": item.get("descendants", 0),
                    "shares": 0,
                },
            })

            if len(posts) >= limit:
                break

        return posts
