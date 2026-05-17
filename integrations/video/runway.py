"""Runway ML generative video provider."""

import os
import time
import requests
from typing import Optional
from .base import VideoProvider


class RunwayProvider(VideoProvider):
    """Runway provider for AI-generated b-roll and creative visuals."""

    provider_name = "runway"
    BASE_URL = "https://api.runwayml.com/v1"

    def __init__(self, api_key: str = None):
        self.api_key = api_key or os.environ.get("RUNWAY_API_KEY")
        if not self.api_key:
            raise ValueError("RUNWAY_API_KEY environment variable required")
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
        })

    def render_video(self, script: dict, style: str, options: Optional[dict] = None) -> dict:
        options = options or {}
        prompt_parts = [seg.get("visual_cue", "") for seg in script.get("segments", []) if seg.get("visual_cue")]
        prompt = " | ".join(prompt_parts)

        payload = {
            "promptText": prompt,
            "model": options.get("model", "gen3a_turbo"),
            "duration": options.get("duration", 10),
            "ratio": options.get("aspect_ratio", "9:16"),
        }

        response = self.session.post(f"{self.BASE_URL}/image_to_video", json=payload)
        response.raise_for_status()
        result = response.json()

        return {
            "job_id": result.get("id", ""),
            "status": "processing",
            "estimated_duration": options.get("duration", 10) * 12,
        }

    def check_status(self, job_id: str) -> dict:
        response = self.session.get(f"{self.BASE_URL}/tasks/{job_id}")
        response.raise_for_status()
        result = response.json()

        status_map = {"PENDING": "queued", "RUNNING": "rendering", "SUCCEEDED": "complete", "FAILED": "failed"}
        status = status_map.get(result.get("status", ""), "unknown")

        return {
            "job_id": job_id,
            "status": status,
            "progress_pct": result.get("progress", 0),
            "output_url": result.get("output", [None])[0] if status == "complete" else None,
        }

    def download(self, job_id: str, output_path: str) -> str:
        status = self.check_status(job_id)
        if status["status"] != "complete":
            raise RuntimeError(f"Video not ready: status={status['status']}")
        response = requests.get(status["output_url"], stream=True)
        response.raise_for_status()
        with open(output_path, "wb") as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        return output_path
