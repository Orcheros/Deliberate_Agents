"""Manual video upload placeholder provider."""

from .base import ManualVideoProvider

# Re-export from base — ManualVideoProvider is defined there
# This file exists for explicit import consistency with other providers
__all__ = ["ManualVideoProvider"]
