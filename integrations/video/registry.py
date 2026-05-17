"""Video render provider factory."""

import os
from .base import VideoProvider, ManualVideoProvider


def get_video_provider(provider_name: str = None, dry_run: bool = False) -> VideoProvider:
    """Factory routing to video render providers.

    Args:
        provider_name: "heygen", "runway", "manual"
        dry_run: If True, returns manual provider
    """
    if dry_run:
        return ManualVideoProvider()

    provider_name = provider_name or os.environ.get("VIDEO_PROVIDER", "manual")

    providers = {
        "heygen": _get_heygen,
        "runway": _get_runway,
        "manual": lambda: ManualVideoProvider(),
    }

    if provider_name not in providers:
        raise ValueError(f"Unknown video provider: {provider_name}. Available: {', '.join(providers.keys())}")

    return providers[provider_name]()


def _get_heygen() -> VideoProvider:
    from .heygen import HeyGenProvider
    return HeyGenProvider()

def _get_runway() -> VideoProvider:
    from .runway import RunwayProvider
    return RunwayProvider()
