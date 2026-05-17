"""Product Hunt provider using GraphQL API.

Implements unified SocialProvider interface for Product Hunt.
publish_post: metadata={"type": "launch"|"discussion"|"comment", "tagline": str, "thumbnail_url": str}
Supports launch day operations.
"""

import os
import sys
import json
from datetime import datetime, timedelta
from typing import Optional

import requests

from .base import SocialProvider


class ProductHuntProvider(SocialProvider):
    """Product Hunt provider using GraphQL API (https://api.producthunt.com/v2)."""

    platform = "producthunt"
    BASE_URL = "https://api.producthunt.com/v2/api/graphql"

    def __init__(self, api_token: str = None, dev_token: str = None):
        self.api_token = api_token or os.environ.get("PRODUCTHUNT_API_TOKEN")
        self.dev_token = dev_token or os.environ.get("PRODUCTHUNT_DEV_TOKEN")
        if not self.api_token:
            raise ValueError("PRODUCTHUNT_API_TOKEN environment variable required")
        if not self.dev_token:
            raise ValueError("PRODUCTHUNT_DEV_TOKEN environment variable required")
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {self.dev_token}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        })

    def _graphql(self, query: str, variables: dict = None) -> dict:
        """Execute a GraphQL query against Product Hunt API."""
        payload = {"query": query}
        if variables:
            payload["variables"] = variables
        response = self.session.post(self.BASE_URL, json=payload)
        response.raise_for_status()
        result = response.json()
        if "errors" in result:
            raise RuntimeError(f"ProductHunt GraphQL error: {result['errors']}")
        return result.get("data", {})

    def publish_post(self, content: str, media_urls: Optional[list[str]] = None, metadata: Optional[dict] = None) -> dict:
        metadata = metadata or {}
        post_type = metadata.get("type", "discussion")

        if post_type == "launch":
            return self._create_launch(content, media_urls, metadata)
        elif post_type == "discussion":
            return self._create_discussion(content, metadata)
        elif post_type == "comment":
            return self._create_comment(content, metadata)
        else:
            raise ValueError(f"Unknown ProductHunt post type: {post_type}. Use 'launch', 'discussion', or 'comment'.")

    def _create_launch(self, content: str, media_urls: Optional[list[str]], metadata: dict) -> dict:
        """Create a product launch (requires maker permissions)."""
        name = metadata.get("name", metadata.get("title", "Untitled Product"))
        tagline = metadata.get("tagline", content[:60])
        thumbnail_url = metadata.get("thumbnail_url") or (media_urls[0] if media_urls else None)

        # Note: Product Hunt launch creation via API requires special permissions
        # This uses the maker post creation endpoint
        query = """
        mutation CreatePost($input: PostCreateInput!) {
            postCreate(input: $input) {
                post {
                    id
                    slug
                    name
                    url
                    createdAt
                }
                errors {
                    field
                    message
                }
            }
        }
        """
        variables = {
            "input": {
                "name": name,
                "tagline": tagline,
                "description": content,
            }
        }
        if thumbnail_url:
            variables["input"]["thumbnailUrl"] = thumbnail_url

        result = self._graphql(query, variables)
        post_data = result.get("postCreate", {}).get("post", {})
        errors = result.get("postCreate", {}).get("errors", [])

        if errors:
            raise RuntimeError(f"Launch creation failed: {errors}")

        return {
            "post_id": post_data.get("id", ""),
            "url": post_data.get("url", f"https://www.producthunt.com/posts/{post_data.get('slug', '')}"),
            "published_at": post_data.get("createdAt", datetime.utcnow().isoformat()),
            "platform": self.platform,
        }

    def _create_discussion(self, content: str, metadata: dict) -> dict:
        """Create a discussion post."""
        title = metadata.get("title", content[:100])

        query = """
        mutation CreateDiscussion($input: DiscussionCreateInput!) {
            discussionCreate(input: $input) {
                discussion {
                    id
                    url
                    title
                    createdAt
                }
                errors {
                    field
                    message
                }
            }
        }
        """
        variables = {
            "input": {
                "title": title,
                "body": content,
            }
        }

        result = self._graphql(query, variables)
        discussion = result.get("discussionCreate", {}).get("discussion", {})
        errors = result.get("discussionCreate", {}).get("errors", [])

        if errors:
            raise RuntimeError(f"Discussion creation failed: {errors}")

        return {
            "post_id": discussion.get("id", ""),
            "url": discussion.get("url", ""),
            "published_at": discussion.get("createdAt", datetime.utcnow().isoformat()),
            "platform": self.platform,
        }

    def _create_comment(self, content: str, metadata: dict) -> dict:
        """Create a comment on a post or discussion."""
        parent_id = metadata.get("parent_id")
        if not parent_id:
            raise ValueError("Comment requires metadata={'parent_id': 'post_or_discussion_id'}")

        query = """
        mutation CreateComment($input: CommentCreateInput!) {
            commentCreate(input: $input) {
                comment {
                    id
                    url
                    createdAt
                }
                errors {
                    field
                    message
                }
            }
        }
        """
        variables = {
            "input": {
                "subjectId": parent_id,
                "body": content,
            }
        }

        result = self._graphql(query, variables)
        comment = result.get("commentCreate", {}).get("comment", {})
        errors = result.get("commentCreate", {}).get("errors", [])

        if errors:
            raise RuntimeError(f"Comment creation failed: {errors}")

        return {
            "post_id": comment.get("id", ""),
            "url": comment.get("url", ""),
            "published_at": comment.get("createdAt", datetime.utcnow().isoformat()),
            "platform": self.platform,
        }

    def get_post_metrics(self, post_id: str) -> dict:
        query = """
        query GetPost($id: ID!) {
            post(id: $id) {
                id
                votesCount
                commentsCount
                reviewsCount
                followersCount
            }
        }
        """
        result = self._graphql(query, {"id": post_id})
        post = result.get("post", {})

        if not post:
            return {"impressions": 0, "likes": 0, "comments": 0, "shares": 0, "engagement_rate": 0.0, "platform_specific": {}}

        votes = post.get("votesCount", 0)
        comments = post.get("commentsCount", 0)
        # PH doesn't expose views; estimate based on typical 3-5% conversion
        estimated_impressions = int(votes / 0.04) if votes > 0 else 0
        total_engagement = votes + comments
        engagement_rate = (total_engagement / estimated_impressions * 100) if estimated_impressions > 0 else 0.0

        return {
            "impressions": estimated_impressions,
            "likes": votes,
            "comments": comments,
            "shares": 0,
            "engagement_rate": round(engagement_rate, 2),
            "platform_specific": {
                "votes": votes,
                "reviews": post.get("reviewsCount", 0),
                "followers": post.get("followersCount", 0),
            },
        }

    def get_recent_engagement(self, since_hours: int = 24) -> list[dict]:
        # Fetch recent comments on our posts
        query = """
        query GetMyPosts {
            viewer {
                makerOf(first: 5) {
                    edges {
                        node {
                            id
                            name
                            comments(first: 10, order: NEWEST) {
                                edges {
                                    node {
                                        id
                                        body
                                        createdAt
                                        user {
                                            name
                                            username
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        """
        result = self._graphql(query)
        cutoff = (datetime.utcnow() - timedelta(hours=since_hours)).isoformat()

        engagements = []
        maker_of = result.get("viewer", {}).get("makerOf", {}).get("edges", [])
        for product_edge in maker_of:
            product = product_edge.get("node", {})
            product_id = product.get("id", "")
            comments = product.get("comments", {}).get("edges", [])
            for comment_edge in comments:
                comment = comment_edge.get("node", {})
                created_at = comment.get("createdAt", "")
                if created_at >= cutoff:
                    engagements.append({
                        "type": "comment",
                        "user": comment.get("user", {}).get("name", "unknown"),
                        "post_id": product_id,
                        "timestamp": created_at,
                        "content": comment.get("body", "")[:200],
                    })
        return engagements

    def get_my_posts(self, limit: int = 20) -> list[dict]:
        query = """
        query GetMyPosts($first: Int!) {
            viewer {
                makerOf(first: $first) {
                    edges {
                        node {
                            id
                            name
                            tagline
                            url
                            votesCount
                            commentsCount
                            createdAt
                        }
                    }
                }
            }
        }
        """
        result = self._graphql(query, {"first": limit})
        maker_of = result.get("viewer", {}).get("makerOf", {}).get("edges", [])

        posts = []
        for edge in maker_of:
            product = edge.get("node", {})
            posts.append({
                "post_id": product.get("id", ""),
                "content": f"{product.get('name', '')} - {product.get('tagline', '')}",
                "published_at": product.get("createdAt", ""),
                "metrics": {
                    "impressions": 0,
                    "likes": product.get("votesCount", 0),
                    "comments": product.get("commentsCount", 0),
                    "shares": 0,
                },
            })
        return posts
