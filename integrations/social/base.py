"""Unified social platform provider interface for Deliberate_Agents.

All platform-specific providers implement SocialProvider ABC.
Swap providers without touching skills or agents.
"""

import os
import sys
import json
from abc import ABC, abstractmethod
from datetime import datetime, timedelta
from typing import Optional


class SocialProvider(ABC):
    """Unified interface for all social platform providers."""

    platform: str  # "linkedin", "twitter", "threads", etc.

    @abstractmethod
    def publish_post(self, content: str, media_urls: Optional[list[str]] = None, metadata: Optional[dict] = None) -> dict:
        """Publish content to the platform.

        Args:
            content: Post text content
            media_urls: Optional list of media URLs to attach
            metadata: Platform-specific metadata (hashtags, mentions, etc.)

        Returns: {"post_id": str, "url": str, "published_at": str, "platform": str}
        """
        ...

    @abstractmethod
    def get_post_metrics(self, post_id: str) -> dict:
        """Get engagement metrics for a specific post.

        Returns: {
            "impressions": int,
            "likes": int,
            "comments": int,
            "shares": int,
            "engagement_rate": float,
            "platform_specific": {}
        }
        """
        ...

    @abstractmethod
    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        """Get recent engagement activity.

        Returns: [{"type": str, "user": str, "post_id": str, "timestamp": str, "content": str}]
        """
        ...

    @abstractmethod
    def get_my_posts(self, limit: int = 20) -> list[dict]:
        """Get recent posts from the authenticated account.

        Returns: [{"post_id": str, "content": str, "published_at": str, "metrics": dict}]
        """
        ...


class DryRunProvider(SocialProvider):
    """Mock provider for testing without hitting real APIs."""

    def __init__(self, platform: str = "dry-run"):
        self.platform = platform

    def publish_post(self, content: str, media_urls: Optional[list[str]] = None, metadata: Optional[dict] = None) -> dict:
        print(f"[DRY RUN] [{self.platform}] Would publish post ({len(content)} chars)")
        if media_urls:
            print(f"  Media: {len(media_urls)} attachment(s)")
        return {
            "post_id": f"dry-run-{self.platform}-001",
            "url": f"https://{self.platform}.example.com/dry-run",
            "published_at": datetime.utcnow().isoformat(),
            "platform": self.platform,
        }

    def get_post_metrics(self, post_id: str) -> dict:
        return {
            "impressions": 1000,
            "likes": 50,
            "comments": 12,
            "shares": 5,
            "engagement_rate": 6.7,
            "platform_specific": {},
        }

    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        return [{"type": "like", "user": "test_user", "post_id": "dry-run-001", "timestamp": datetime.utcnow().isoformat(), "content": ""}]

    def get_my_posts(self, limit: int = 20) -> list[dict]:
        return [{"post_id": "dry-run-001", "content": "Test post", "published_at": datetime.utcnow().isoformat(), "metrics": {"impressions": 1000, "likes": 50}}]
