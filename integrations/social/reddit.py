"""Reddit provider using PRAW (Python Reddit API Wrapper).

Implements unified SocialProvider interface for Reddit.
publish_post: metadata={"subreddit": str, "title": str, "flair": str}
get_recent_engagement: monitors replies to our posts.
"""

import os
import sys
import json
from datetime import datetime, timedelta
from typing import Optional

from .base import SocialProvider


class RedditProvider(SocialProvider):
    """Reddit provider using PRAW (Python Reddit API Wrapper)."""

    platform = "reddit"

    def __init__(self, client_id: str = None, client_secret: str = None, username: str = None, password: str = None):
        self.client_id = client_id or os.environ.get("REDDIT_CLIENT_ID")
        self.client_secret = client_secret or os.environ.get("REDDIT_CLIENT_SECRET")
        self.username = username or os.environ.get("REDDIT_USERNAME")
        self.password = password or os.environ.get("REDDIT_PASSWORD")

        if not self.client_id:
            raise ValueError("REDDIT_CLIENT_ID environment variable required")
        if not self.client_secret:
            raise ValueError("REDDIT_CLIENT_SECRET environment variable required")
        if not self.username:
            raise ValueError("REDDIT_USERNAME environment variable required")
        if not self.password:
            raise ValueError("REDDIT_PASSWORD environment variable required")

        self._reddit = None

    @property
    def reddit(self):
        """Lazy-init PRAW instance."""
        if self._reddit is None:
            import praw
            self._reddit = praw.Reddit(
                client_id=self.client_id,
                client_secret=self.client_secret,
                username=self.username,
                password=self.password,
                user_agent=f"Deliberate_Agents:v1.0 (by /u/{self.username})",
            )
        return self._reddit

    def publish_post(self, content: str, media_urls: Optional[list[str]] = None, metadata: Optional[dict] = None) -> dict:
        metadata = metadata or {}

        subreddit_name = metadata.get("subreddit")
        if not subreddit_name:
            raise ValueError("Reddit requires metadata={'subreddit': 'name'} for publishing")

        title = metadata.get("title", content[:300])
        flair = metadata.get("flair")

        subreddit = self.reddit.subreddit(subreddit_name)

        # Determine submission type
        if media_urls:
            # Link or media post
            url = media_urls[0]
            if url.lower().endswith((".png", ".jpg", ".jpeg", ".gif")):
                submission = subreddit.submit_image(title=title, image_path=url)
            elif url.lower().endswith((".mp4", ".mov")):
                submission = subreddit.submit_video(title=title, video_path=url)
            else:
                submission = subreddit.submit(title=title, url=url)
        elif content and len(content) > len(title):
            # Self/text post
            submission = subreddit.submit(title=title, selftext=content)
        else:
            # Title-only post
            submission = subreddit.submit(title=title, selftext="")

        # Apply flair if specified
        if flair and submission:
            try:
                choices = submission.flair.choices()
                for choice in choices:
                    if choice.get("flair_text", "").lower() == flair.lower():
                        submission.flair.select(choice["flair_template_id"])
                        break
            except Exception:
                pass  # Flair application is best-effort

        return {
            "post_id": submission.id,
            "url": f"https://www.reddit.com{submission.permalink}",
            "published_at": datetime.utcnow().isoformat(),
            "platform": self.platform,
        }

    def get_post_metrics(self, post_id: str) -> dict:
        submission = self.reddit.submission(id=post_id)
        submission._fetch()

        upvotes = submission.score
        comments = submission.num_comments
        upvote_ratio = submission.upvote_ratio
        # Reddit doesn't expose impression/view counts via API
        # Estimate based on a typical 2-5% engagement rate
        estimated_impressions = int(upvotes / 0.03) if upvotes > 0 else 0

        return {
            "impressions": estimated_impressions,
            "likes": upvotes,
            "comments": comments,
            "shares": 0,  # Reddit doesn't expose crosspost count easily
            "engagement_rate": round(upvote_ratio * 100, 2),
            "platform_specific": {
                "score": upvotes,
                "upvote_ratio": upvote_ratio,
                "num_crossposts": getattr(submission, "num_crossposts", 0),
                "is_locked": submission.locked,
                "is_stickied": submission.stickied,
            },
        }

    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        cutoff = datetime.utcnow() - timedelta(hours=since_hours)
        cutoff_timestamp = cutoff.timestamp()

        engagements = []
        # Check inbox for replies
        for item in self.reddit.inbox.replies(limit=50):
            if item.created_utc >= cutoff_timestamp:
                engagements.append({
                    "type": "reply",
                    "user": str(item.author) if item.author else "deleted",
                    "post_id": item.submission.id if hasattr(item, "submission") else "",
                    "timestamp": datetime.utcfromtimestamp(item.created_utc).isoformat(),
                    "content": item.body[:200],
                })

        # Check mentions
        for item in self.reddit.inbox.mentions(limit=20):
            if item.created_utc >= cutoff_timestamp:
                engagements.append({
                    "type": "mention",
                    "user": str(item.author) if item.author else "deleted",
                    "post_id": item.submission.id if hasattr(item, "submission") else "",
                    "timestamp": datetime.utcfromtimestamp(item.created_utc).isoformat(),
                    "content": item.body[:200],
                })

        return engagements

    def get_my_posts(self, limit: int = 20) -> list[dict]:
        user = self.reddit.redditor(self.username)
        posts = []
        for submission in user.submissions.new(limit=limit):
            posts.append({
                "post_id": submission.id,
                "content": submission.title,
                "published_at": datetime.utcfromtimestamp(submission.created_utc).isoformat(),
                "metrics": {
                    "impressions": 0,
                    "likes": submission.score,
                    "comments": submission.num_comments,
                    "shares": 0,
                },
            })
        return posts
