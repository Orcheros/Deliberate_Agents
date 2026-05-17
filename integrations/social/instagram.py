"""Instagram provider using Meta Graph API.

Implements unified SocialProvider interface for Instagram.
Uses Meta Graph API directly (Unipile doesn't cover Reels upload well).
publish_post requires media_urls (Reels = video URL).
metadata={"caption": str, "cover_url": str}
"""

import os
import sys
import json
import time
from datetime import datetime, timedelta
from typing import Optional

import requests

from .base import SocialProvider


class InstagramProvider(SocialProvider):
    """Instagram provider using Meta Graph API for Reels and media posts."""

    platform = "instagram"
    BASE_URL = "https://graph.facebook.com/v18.0"

    def __init__(self, access_token: str = None, user_id: str = None):
        self.access_token = access_token or os.environ.get("META_INSTAGRAM_TOKEN")
        self.user_id = user_id or os.environ.get("META_INSTAGRAM_USER_ID")
        if not self.access_token:
            raise ValueError("META_INSTAGRAM_TOKEN environment variable required")
        if not self.user_id:
            raise ValueError("META_INSTAGRAM_USER_ID environment variable required")
        self.session = requests.Session()

    def _request(self, method: str, endpoint: str, **kwargs) -> dict:
        """Make authenticated request to Meta Graph API."""
        url = f"{self.BASE_URL}{endpoint}"
        # Add access token to params
        params = kwargs.pop("params", {})
        params["access_token"] = self.access_token
        response = self.session.request(method, url, params=params, **kwargs)
        response.raise_for_status()
        return response.json()

    def _wait_for_container(self, container_id: str, max_wait: int = 60) -> str:
        """Poll container status until ready or failed."""
        for _ in range(max_wait // 2):
            result = self._request("GET", f"/{container_id}", params={"fields": "status_code"})
            status = result.get("status_code")
            if status == "FINISHED":
                return "ready"
            elif status == "ERROR":
                raise RuntimeError(f"Instagram media container failed: {result}")
            time.sleep(2)
        raise TimeoutError("Instagram media container processing timed out")

    def publish_post(self, content: str, media_urls: Optional[list[str]] = None, metadata: Optional[dict] = None) -> dict:
        metadata = metadata or {}

        if not media_urls:
            raise ValueError("Instagram requires media_urls (image or video URL) for publishing")

        media_url = media_urls[0]
        caption = metadata.get("caption", content)
        is_video = media_url.lower().endswith((".mp4", ".mov")) or metadata.get("is_reel", False)

        # Step 1: Create media container
        container_payload = {
            "caption": caption,
        }
        if is_video:
            container_payload["media_type"] = "REELS"
            container_payload["video_url"] = media_url
            if metadata.get("cover_url"):
                container_payload["cover_url"] = metadata["cover_url"]
            if metadata.get("share_to_feed") is not None:
                container_payload["share_to_feed"] = metadata["share_to_feed"]
        else:
            container_payload["image_url"] = media_url

        container_result = self._request(
            "POST", f"/{self.user_id}/media", json=container_payload
        )
        container_id = container_result.get("id")

        # Step 2: Wait for container processing (for video)
        if is_video:
            self._wait_for_container(container_id)

        # Step 3: Publish the container
        publish_result = self._request(
            "POST", f"/{self.user_id}/media_publish",
            json={"creation_id": container_id}
        )

        media_id = publish_result.get("id", "")
        return {
            "post_id": media_id,
            "url": f"https://www.instagram.com/p/{media_id}/",
            "published_at": datetime.utcnow().isoformat(),
            "platform": self.platform,
        }

    def get_post_metrics(self, post_id: str) -> dict:
        # Fetch insights for the media object
        metrics_to_fetch = "impressions,reach,likes,comments,shares,saved,plays"
        result = self._request(
            "GET", f"/{post_id}/insights",
            params={"metric": metrics_to_fetch}
        )

        metrics = {}
        for item in result.get("data", []):
            name = item.get("name", "")
            value = item.get("values", [{}])[0].get("value", 0)
            metrics[name] = value

        impressions = metrics.get("impressions", 0)
        likes = metrics.get("likes", 0)
        comments = metrics.get("comments", 0)
        shares = metrics.get("shares", 0)
        total_engagement = likes + comments + shares
        engagement_rate = (total_engagement / impressions * 100) if impressions > 0 else 0.0

        return {
            "impressions": impressions,
            "likes": likes,
            "comments": comments,
            "shares": shares,
            "engagement_rate": round(engagement_rate, 2),
            "platform_specific": {
                "reach": metrics.get("reach", 0),
                "saved": metrics.get("saved", 0),
                "plays": metrics.get("plays", 0),
            },
        }

    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        # Instagram Graph API doesn't have a direct notifications endpoint
        # We fetch recent media and their comments instead
        cutoff = datetime.utcnow() - timedelta(hours=since_hours)
        result = self._request(
            "GET", f"/{self.user_id}/media",
            params={"fields": "id,comments{text,username,timestamp}", "limit": 10}
        )

        engagements = []
        for media in result.get("data", []):
            comments = media.get("comments", {}).get("data", [])
            for comment in comments:
                comment_time = datetime.fromisoformat(comment.get("timestamp", "").replace("Z", "+00:00"))
                if comment_time.replace(tzinfo=None) >= cutoff:
                    engagements.append({
                        "type": "comment",
                        "user": comment.get("username", "unknown"),
                        "post_id": media.get("id", ""),
                        "timestamp": comment.get("timestamp", ""),
                        "content": comment.get("text", ""),
                    })
        return engagements

    def get_my_posts(self, limit: int = 20) -> list[dict]:
        result = self._request(
            "GET", f"/{self.user_id}/media",
            params={"fields": "id,caption,timestamp,like_count,comments_count", "limit": limit}
        )
        posts = []
        for media in result.get("data", []):
            posts.append({
                "post_id": media.get("id", ""),
                "content": media.get("caption", ""),
                "published_at": media.get("timestamp", ""),
                "metrics": {
                    "impressions": 0,  # Requires separate insights call
                    "likes": media.get("like_count", 0),
                    "comments": media.get("comments_count", 0),
                    "shares": 0,
                },
            })
        return posts
