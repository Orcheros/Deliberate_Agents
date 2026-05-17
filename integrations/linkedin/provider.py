# NOTE: Canonical location is now integrations/social/linkedin.py
# This file is retained for backward compatibility during migration.
"""LinkedIn provider abstraction for Deliberate_Agents content automation.

Provider-agnostic interface for LinkedIn API operations.
Swap UnipileProvider for NativeProvider (or any other) without touching skills.
"""

import os
import sys
import json
import argparse
from abc import ABC, abstractmethod
from datetime import datetime, timedelta
from typing import Optional

import requests


class LinkedInProvider(ABC):
    """Abstract base class for LinkedIn API providers."""

    @abstractmethod
    def publish_post(self, content: str, media_urls: Optional[list[str]] = None) -> dict:
        """Publish a text post (optionally with media).

        Returns: {"post_id": str, "url": str, "published_at": str}
        """
        ...

    @abstractmethod
    def get_post_metrics(self, post_id: str) -> dict:
        """Get engagement metrics for a specific post.

        Returns: {"impressions": int, "likes": int, "comments": int,
                  "shares": int, "engagement_rate": float}
        """
        ...

    @abstractmethod
    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        """Get recent engagement activity (comments, likes, shares).

        Returns: [{"type": str, "user": str, "post_id": str, "timestamp": str, ...}]
        """
        ...

    @abstractmethod
    def get_my_posts(self, limit: int = 20) -> list[dict]:
        """Get recent posts from the authenticated account.

        Returns: [{"post_id": str, "content": str, "published_at": str, "metrics": dict}]
        """
        ...


class UnipileProvider(LinkedInProvider):
    """LinkedIn provider using Unipile API (https://unipile.com)."""

    BASE_URL = "https://api.unipile.com/api/v1"

    def __init__(self, api_key: str = None, account_id: str = None):
        self.api_key = api_key or os.environ.get("UNIPILE_API_KEY")
        self.account_id = account_id or os.environ.get("UNIPILE_ACCOUNT_ID")
        if not self.api_key:
            raise ValueError("UNIPILE_API_KEY environment variable required")
        if not self.account_id:
            raise ValueError("UNIPILE_ACCOUNT_ID environment variable required")
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

    def publish_post(self, content: str, media_urls: Optional[list[str]] = None) -> dict:
        """Publish a LinkedIn post via Unipile."""
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
        }

    def get_post_metrics(self, post_id: str) -> dict:
        """Get metrics for a specific post."""
        result = self._request("GET", f"/posts/{post_id}")
        metrics = result.get("metrics", {})
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
        }

    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        """Get recent engagement activity."""
        since = (datetime.utcnow() - timedelta(hours=since_hours)).isoformat()
        result = self._request("GET", f"/accounts/{self.account_id}/notifications", params={"since": since})
        engagements = []
        for item in result.get("items", []):
            engagements.append({
                "type": item.get("type", "unknown"),
                "user": item.get("actor", {}).get("name", "unknown"),
                "user_id": item.get("actor", {}).get("id", ""),
                "post_id": item.get("post_id", ""),
                "timestamp": item.get("created_at", ""),
                "content": item.get("content", ""),
            })
        return engagements

    def get_my_posts(self, limit: int = 20) -> list[dict]:
        """Get recent posts from authenticated account."""
        result = self._request("GET", f"/accounts/{self.account_id}/posts", params={"limit": limit})
        posts = []
        for post in result.get("items", []):
            posts.append({
                "post_id": post.get("id", ""),
                "content": post.get("text", ""),
                "published_at": post.get("created_at", ""),
                "metrics": {
                    "impressions": post.get("metrics", {}).get("impressions", 0),
                    "likes": post.get("metrics", {}).get("likes", 0),
                    "comments": post.get("metrics", {}).get("comments", 0),
                    "shares": post.get("metrics", {}).get("shares", 0),
                },
            })
        return posts


class DryRunProvider(LinkedInProvider):
    """Mock provider for testing without hitting real APIs."""

    def publish_post(self, content: str, media_urls: Optional[list[str]] = None) -> dict:
        print(f"[DRY RUN] Would publish post ({len(content)} chars)")
        return {"post_id": "dry-run-001", "url": "https://linkedin.com/dry-run", "published_at": datetime.utcnow().isoformat()}

    def get_post_metrics(self, post_id: str) -> dict:
        return {"impressions": 1000, "likes": 50, "comments": 12, "shares": 5, "engagement_rate": 6.7}

    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        return [{"type": "like", "user": "Test User", "post_id": "dry-run-001", "timestamp": datetime.utcnow().isoformat()}]

    def get_my_posts(self, limit: int = 20) -> list[dict]:
        return [{"post_id": "dry-run-001", "content": "Test post", "published_at": datetime.utcnow().isoformat(), "metrics": {"impressions": 1000, "likes": 50, "comments": 12, "shares": 5}}]


def get_provider(provider_name: str = None, dry_run: bool = False) -> LinkedInProvider:
    """Factory function to get the configured LinkedIn provider."""
    if dry_run:
        return DryRunProvider()

    provider_name = provider_name or os.environ.get("LINKEDIN_PROVIDER", "unipile")

    if provider_name == "unipile":
        return UnipileProvider()
    else:
        raise ValueError(f"Unknown LinkedIn provider: {provider_name}. Available: unipile")


def main():
    parser = argparse.ArgumentParser(description="LinkedIn provider for content automation")
    parser.add_argument("--test", action="store_true", help="Test connection (read-only)")
    parser.add_argument("--dry-run", action="store_true", help="Use mock provider")
    parser.add_argument("--list-posts", type=int, nargs="?", const=5, help="List recent posts")
    parser.add_argument("--metrics", type=str, help="Get metrics for post ID")
    args = parser.parse_args()

    try:
        provider = get_provider(dry_run=args.dry_run)
    except ValueError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)

    if args.test:
        print("Testing LinkedIn provider connection...")
        try:
            posts = provider.get_my_posts(limit=1)
            print(f"SUCCESS: Connected. Found {len(posts)} recent post(s).")
        except Exception as e:
            print(f"FAILED: {e}", file=sys.stderr)
            sys.exit(1)

    elif args.list_posts:
        posts = provider.get_my_posts(limit=args.list_posts)
        for post in posts:
            preview = post["content"][:60].replace("\n", " ")
            print(f"  [{post['post_id'][:8]}] {preview}...")
        print(f"\nTotal: {len(posts)} posts")

    elif args.metrics:
        metrics = provider.get_post_metrics(args.metrics)
        print(json.dumps(metrics, indent=2))

    else:
        parser.print_help()


if __name__ == "__main__":
    main()
