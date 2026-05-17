"""TikTok provider using TikTok Content Posting API.

Implements unified SocialProvider interface for TikTok.
publish_post: media_urls=[video_path], metadata={"description": str, "hashtags": list}
"""

import os
import sys
import json
import time
from datetime import datetime, timedelta
from typing import Optional

import requests

from .base import SocialProvider


class TikTokProvider(SocialProvider):
    """TikTok provider using TikTok Content Posting API."""

    platform = "tiktok"
    BASE_URL = "https://open.tiktokapis.com/v2"

    def __init__(self, access_token: str = None):
        self.access_token = access_token or os.environ.get("TIKTOK_ACCESS_TOKEN")
        if not self.access_token:
            raise ValueError("TIKTOK_ACCESS_TOKEN environment variable required")
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {self.access_token}",
            "Content-Type": "application/json",
        })

    def _request(self, method: str, endpoint: str, **kwargs) -> dict:
        """Make authenticated request to TikTok API."""
        url = f"{self.BASE_URL}{endpoint}"
        response = self.session.request(method, url, **kwargs)
        response.raise_for_status()
        return response.json()

    def publish_post(self, content: str, media_urls: Optional[list[str]] = None, metadata: Optional[dict] = None) -> dict:
        metadata = metadata or {}

        if not media_urls:
            raise ValueError("TikTok requires media_urls with video file path or URL for publishing")

        video_source = media_urls[0]
        description = metadata.get("description", content)
        hashtags = metadata.get("hashtags", [])

        # Append hashtags to description
        if hashtags:
            hashtag_str = " ".join(f"#{tag.lstrip('#')}" for tag in hashtags)
            description = f"{description} {hashtag_str}"

        # Determine if source is URL or file path
        is_url = video_source.startswith("http://") or video_source.startswith("https://")

        if is_url:
            # Direct post with video URL
            payload = {
                "post_info": {
                    "title": description[:150],  # TikTok title limit
                    "privacy_level": metadata.get("privacy", "PUBLIC_TO_EVERYONE"),
                    "disable_duet": metadata.get("disable_duet", False),
                    "disable_comment": metadata.get("disable_comment", False),
                    "disable_stitch": metadata.get("disable_stitch", False),
                },
                "source_info": {
                    "source": "PULL_FROM_URL",
                    "video_url": video_source,
                },
            }
            result = self._request("POST", "/post/publish/video/init/", json=payload)
        else:
            # File upload flow
            if not os.path.exists(video_source):
                raise FileNotFoundError(f"Video file not found: {video_source}")

            file_size = os.path.getsize(video_source)

            # Step 1: Initialize upload
            init_payload = {
                "post_info": {
                    "title": description[:150],
                    "privacy_level": metadata.get("privacy", "PUBLIC_TO_EVERYONE"),
                    "disable_duet": metadata.get("disable_duet", False),
                    "disable_comment": metadata.get("disable_comment", False),
                    "disable_stitch": metadata.get("disable_stitch", False),
                },
                "source_info": {
                    "source": "FILE_UPLOAD",
                    "video_size": file_size,
                    "chunk_size": file_size,
                    "total_chunk_count": 1,
                },
            }
            init_result = self._request("POST", "/post/publish/video/init/", json=init_payload)
            upload_url = init_result.get("data", {}).get("upload_url", "")
            publish_id = init_result.get("data", {}).get("publish_id", "")

            # Step 2: Upload video
            with open(video_source, "rb") as video_file:
                upload_headers = {
                    "Content-Range": f"bytes 0-{file_size - 1}/{file_size}",
                    "Content-Type": "video/mp4",
                }
                upload_response = requests.put(upload_url, headers=upload_headers, data=video_file)
                upload_response.raise_for_status()

            result = {"data": {"publish_id": publish_id}}

        publish_id = result.get("data", {}).get("publish_id", "")
        return {
            "post_id": publish_id,
            "url": f"https://www.tiktok.com/@me/video/{publish_id}",
            "published_at": datetime.utcnow().isoformat(),
            "platform": self.platform,
        }

    def get_post_metrics(self, post_id: str) -> dict:
        result = self._request(
            "POST", "/video/query/",
            json={"filters": {"video_ids": [post_id]}, "fields": ["like_count", "comment_count", "share_count", "view_count"]}
        )
        videos = result.get("data", {}).get("videos", [])
        if not videos:
            return {"impressions": 0, "likes": 0, "comments": 0, "shares": 0, "engagement_rate": 0.0, "platform_specific": {}}

        video = videos[0]
        views = video.get("view_count", 0)
        likes = video.get("like_count", 0)
        comments = video.get("comment_count", 0)
        shares = video.get("share_count", 0)
        total_engagement = likes + comments + shares
        engagement_rate = (total_engagement / views * 100) if views > 0 else 0.0

        return {
            "impressions": views,
            "likes": likes,
            "comments": comments,
            "shares": shares,
            "engagement_rate": round(engagement_rate, 2),
            "platform_specific": {
                "views": views,
            },
        }

    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        # TikTok API doesn't have a direct notifications/engagement endpoint
        # Fetch comments on recent videos as a proxy
        result = self._request(
            "POST", "/video/list/",
            json={"max_count": 10}
        )
        videos = result.get("data", {}).get("videos", [])

        engagements = []
        for video in videos:
            video_id = video.get("id", "")
            # Fetch comments for each video
            comments_result = self._request(
                "GET", f"/video/comments/",
                params={"video_id": video_id, "max_count": 10}
            )
            for comment in comments_result.get("data", {}).get("comments", []):
                engagements.append({
                    "type": "comment",
                    "user": comment.get("user", {}).get("display_name", "unknown"),
                    "post_id": video_id,
                    "timestamp": comment.get("create_time", ""),
                    "content": comment.get("text", ""),
                })
        return engagements

    def get_my_posts(self, limit: int = 20) -> list[dict]:
        result = self._request(
            "POST", "/video/list/",
            json={"max_count": min(limit, 20)}
        )
        videos = result.get("data", {}).get("videos", [])

        posts = []
        for video in videos:
            posts.append({
                "post_id": video.get("id", ""),
                "content": video.get("title", ""),
                "published_at": video.get("create_time", ""),
                "metrics": {
                    "impressions": video.get("view_count", 0),
                    "likes": video.get("like_count", 0),
                    "comments": video.get("comment_count", 0),
                    "shares": video.get("share_count", 0),
                },
            })
        return posts
