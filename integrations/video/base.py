"""Video rendering provider interface for Deliberate_Agents.

Provider-agnostic interface for AI video generation services.
"""

from abc import ABC, abstractmethod
from typing import Optional


class VideoProvider(ABC):
    """Interface for video rendering services (HeyGen, Runway, etc.)."""

    provider_name: str

    @abstractmethod
    def render_video(self, script: dict, style: str, options: Optional[dict] = None) -> dict:
        """Submit video for rendering.

        Args:
            script: {"segments": [{"timestamp": str, "visual_cue": str, "spoken_text": str, "on_screen_text": str}]}
            style: "avatar" | "generative" | "screen_record"
            options: Provider-specific options (aspect_ratio, duration, voice, etc.)

        Returns: {"job_id": str, "status": str, "estimated_duration": int}
        """
        ...

    @abstractmethod
    def check_status(self, job_id: str) -> dict:
        """Check render job status.

        Returns: {"job_id": str, "status": str, "progress_pct": int, "output_url": str|None}
        """
        ...

    @abstractmethod
    def download(self, job_id: str, output_path: str) -> str:
        """Download rendered video.

        Returns: Local file path of downloaded video.
        """
        ...


class ManualVideoProvider(VideoProvider):
    """Placeholder provider that flags videos for manual recording."""

    provider_name = "manual"

    def render_video(self, script: dict, style: str, options: Optional[dict] = None) -> dict:
        print(f"[MANUAL] Video flagged for manual recording")
        print(f"  Style: {style}")
        print(f"  Segments: {len(script.get('segments', []))}")
        return {"job_id": "manual-pending", "status": "awaiting_human", "estimated_duration": 0}

    def check_status(self, job_id: str) -> dict:
        return {"job_id": job_id, "status": "awaiting_human", "progress_pct": 0, "output_url": None}

    def download(self, job_id: str, output_path: str) -> str:
        raise NotImplementedError("Manual videos must be uploaded by a human")
