"""Video rendering provider interface."""
from .base import VideoProvider
from .registry import get_video_provider
__all__ = ["VideoProvider", "get_video_provider"]
