"""YouTube provider using YouTube Data API v3.

Implements unified SocialProvider interface for YouTube.
publish_post: content=description, media_urls=[video_path]
metadata={"title": str, "tags": list, "category": int, "privacy": str, "is_short": bool}
"""

import os
import sys
import json
from datetime import datetime, timedelta
from typing import Optional

import requests

from .base import SocialProvider


class YouTubeProvider(SocialProvider):
    """YouTube provider using YouTube Data API v3 with OAuth2."""

    platform = "youtube"
    BASE_URL = "https://www.googleapis.com/youtube/v3"
    UPLOAD_URL = "https://www.googleapis.com/upload/youtube/v3/videos"

    def __init__(self, client_secret_file: str = None, token_file: str = None):
        self.client_secret_file = client_secret_file or os.environ.get("YOUTUBE_CLIENT_SECRET_FILE")
        self.token_file = token_file or os.environ.get("YOUTUBE_TOKEN_FILE")
        if not self.client_secret_file:
            raise ValueError("YOUTUBE_CLIENT_SECRET_FILE environment variable required")
        if not self.token_file:
            raise ValueError("YOUTUBE_TOKEN_FILE environment variable required")
        self._credentials = None
        self._load_credentials()

    def _load_credentials(self):
        """Load OAuth2 credentials from token file."""
        if not os.path.exists(self.token_file):
            raise FileNotFoundError(
                f"YouTube token file not found: {self.token_file}. "
                "Run OAuth2 flow first to generate token."
            )
        with open(self.token_file) as f:
            token_data = json.load(f)
        self._access_token = token_data.get("access_token", "")
        self._refresh_token = token_data.get("refresh_token", "")
        self._token_expiry = token_data.get("expiry", "")

    def _get_headers(self) -> dict:
        """Get authorization headers."""
        return {
            "Authorization": f"Bearer {self._access_token}",
            "Accept": "application/json",
        }

    def _request(self, method: str, url: str, **kwargs) -> dict:
        """Make authenticated request to YouTube API."""
        headers = kwargs.pop("headers", {})
        headers.update(self._get_headers())
        response = requests.request(method, url, headers=headers, **kwargs)
        response.raise_for_status()
        return response.json()

    def publish_post(self, content: str, media_urls: Optional[list[str]] = None, metadata: Optional[dict] = None) -> dict:
        metadata = metadata or {}

        if not media_urls:
            raise ValueError("YouTube requires media_urls with video file path for publishing")

        video_path = media_urls[0]
        if not os.path.exists(video_path):
            raise FileNotFoundError(f"Video file not found: {video_path}")

        title = metadata.get("title", "Untitled Video")
        tags = metadata.get("tags", [])
        category_id = str(metadata.get("category", 22))  # 22 = People & Blogs
        privacy = metadata.get("privacy", "private")
        is_short = metadata.get("is_short", False)

        # Add #Shorts tag for YouTube Shorts
        if is_short and "#Shorts" not in title:
            title = f"{title} #Shorts"

        # Video metadata
        video_metadata = {
            "snippet": {
                "title": title,
                "description": content,
                "tags": tags,
                "categoryId": category_id,
            },
            "status": {
                "privacyStatus": privacy,
                "selfDeclaredMadeForKids": False,
            },
        }

        # Upload using resumable upload
        # Step 1: Initiate upload
        init_headers = self._get_headers()
        init_headers["Content-Type"] = "application/json; charset=utf-8"
        init_headers["X-Upload-Content-Type"] = "video/*"
        file_size = os.path.getsize(video_path)
        init_headers["X-Upload-Content-Length"] = str(file_size)

        init_response = requests.post(
            f"{self.UPLOAD_URL}?uploadType=resumable&part=snippet,status",
            headers=init_headers,
            json=video_metadata,
        )
        init_response.raise_for_status()
        upload_url = init_response.headers.get("Location")

        # Step 2: Upload video file
        with open(video_path, "rb") as video_file:
            upload_headers = {"Content-Type": "video/*", "Content-Length": str(file_size)}
            upload_response = requests.put(upload_url, headers=upload_headers, data=video_file)
            upload_response.raise_for_status()
            result = upload_response.json()

        video_id = result.get("id", "")
        return {
            "post_id": video_id,
            "url": f"https://www.youtube.com/watch?v={video_id}",
            "published_at": datetime.utcnow().isoformat(),
            "platform": self.platform,
        }

    def get_post_metrics(self, post_id: str) -> dict:
        result = self._request(
            "GET",
            f"{self.BASE_URL}/videos",
            params={"part": "statistics", "id": post_id},
        )
        items = result.get("items", [])
        if not items:
            return {"impressions": 0, "likes": 0, "comments": 0, "shares": 0, "engagement_rate": 0.0, "platform_specific": {}}

        stats = items[0].get("statistics", {})
        views = int(stats.get("viewCount", 0))
        likes = int(stats.get("likeCount", 0))
        comments = int(stats.get("commentCount", 0))
        favorites = int(stats.get("favoriteCount", 0))
        total_engagement = likes + comments
        engagement_rate = (total_engagement / views * 100) if views > 0 else 0.0

        return {
            "impressions": views,
            "likes": likes,
            "comments": comments,
            "shares": 0,  # YouTube API doesn't expose share count directly
            "engagement_rate": round(engagement_rate, 2),
            "platform_specific": {
                "views": views,
                "favorites": favorites,
                "subscriber_count_change": 0,
            },
        }

    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        # Fetch recent comments on our channel's videos
        cutoff = (datetime.utcnow() - timedelta(hours=since_hours)).isoformat() + "Z"
        result = self._request(
            "GET",
            f"{self.BASE_URL}/commentThreads",
            params={
                "part": "snippet",
                "allThreadsRelatedToChannelId": self._get_channel_id(),
                "moderationStatus": "published",
                "order": "time",
                "maxResults": 50,
            },
        )

        engagements = []
        for item in result.get("items", []):
            snippet = item.get("snippet", {}).get("topLevelComment", {}).get("snippet", {})
            published_at = snippet.get("publishedAt", "")
            if published_at >= cutoff:
                engagements.append({
                    "type": "comment",
                    "user": snippet.get("authorDisplayName", "unknown"),
                    "post_id": snippet.get("videoId", ""),
                    "timestamp": published_at,
                    "content": snippet.get("textDisplay", ""),
                })
        return engagements

    def _get_channel_id(self) -> str:
        """Get the authenticated user's channel ID."""
        result = self._request(
            "GET",
            f"{self.BASE_URL}/channels",
            params={"part": "id", "mine": "true"},
        )
        items = result.get("items", [])
        return items[0].get("id", "") if items else ""

    def get_my_posts(self, limit: int = 20) -> list[dict]:
        channel_id = self._get_channel_id()
        # Get uploads playlist
        channel_result = self._request(
            "GET",
            f"{self.BASE_URL}/channels",
            params={"part": "contentDetails", "id": channel_id},
        )
        items = channel_result.get("items", [])
        if not items:
            return []

        uploads_playlist = items[0].get("contentDetails", {}).get("relatedPlaylists", {}).get("uploads", "")

        # Get videos from uploads playlist
        playlist_result = self._request(
            "GET",
            f"{self.BASE_URL}/playlistItems",
            params={"part": "snippet", "playlistId": uploads_playlist, "maxResults": limit},
        )

        posts = []
        for item in playlist_result.get("items", []):
            snippet = item.get("snippet", {})
            video_id = snippet.get("resourceId", {}).get("videoId", "")
            posts.append({
                "post_id": video_id,
                "content": snippet.get("title", ""),
                "published_at": snippet.get("publishedAt", ""),
                "metrics": {
                    "impressions": 0,  # Requires separate statistics call
                    "likes": 0,
                    "comments": 0,
                    "shares": 0,
                },
            })
        return posts
