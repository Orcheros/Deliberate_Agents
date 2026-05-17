"""Platform provider factory for Deliberate_Agents.

Routes platform names to their specific provider implementations.
Supports dry-run mode for all platforms.
"""

import os
from .base import SocialProvider, DryRunProvider


def get_provider(platform: str, dry_run: bool = False) -> SocialProvider:
    """Factory routing to platform-specific providers.

    Args:
        platform: One of: linkedin, twitter, threads, facebook, instagram, youtube, tiktok, reddit, hackernews, producthunt
        dry_run: If True, returns a mock provider for testing

    Returns: Configured SocialProvider instance
    """
    if dry_run:
        return DryRunProvider(platform=platform)

    providers = {
        "linkedin": _get_linkedin,
        "twitter": _get_twitter,
        "threads": _get_threads,
        "facebook": _get_facebook,
        "instagram": _get_instagram,
        "youtube": _get_youtube,
        "tiktok": _get_tiktok,
        "reddit": _get_reddit,
        "hackernews": _get_hackernews,
        "producthunt": _get_producthunt,
    }

    if platform not in providers:
        raise ValueError(f"Unknown platform: {platform}. Available: {', '.join(providers.keys())}")

    return providers[platform]()


def _get_linkedin() -> SocialProvider:
    from .linkedin import LinkedInProvider
    return LinkedInProvider()

def _get_twitter() -> SocialProvider:
    from .twitter import TwitterProvider
    return TwitterProvider()

def _get_threads() -> SocialProvider:
    from .threads import ThreadsProvider
    return ThreadsProvider()

def _get_facebook() -> SocialProvider:
    from .facebook import FacebookProvider
    return FacebookProvider()

def _get_instagram() -> SocialProvider:
    from .instagram import InstagramProvider
    return InstagramProvider()

def _get_youtube() -> SocialProvider:
    from .youtube import YouTubeProvider
    return YouTubeProvider()

def _get_tiktok() -> SocialProvider:
    from .tiktok import TikTokProvider
    return TikTokProvider()

def _get_reddit() -> SocialProvider:
    from .reddit import RedditProvider
    return RedditProvider()

def _get_hackernews() -> SocialProvider:
    from .hackernews import HackerNewsProvider
    return HackerNewsProvider()

def _get_producthunt() -> SocialProvider:
    from .producthunt import ProductHuntProvider
    return ProductHuntProvider()
