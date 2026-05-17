"""HeyGen AI avatar video provider."""

import os
import time
import requests
from typing import Optional
from .base import VideoProvider


class HeyGenProvider(VideoProvider):
    """HeyGen provider for AI avatar talking-head videos."""

    provider_name = "heygen"
    BASE_URL = "https://api.heygen.com/v2"

    def __init__(self, api_key: str = None):
        self.api_key = api_key or os.environ.get("HEYGEN_API_KEY")
        if not self.api_key:
            raise ValueError("HEYGEN_API_KEY environment variable required")
        self.session = requests.Session()
        self.session.headers.update({
            "X-Api-Key": self.api_key,
            "Content-Type": "application/json",
        })

    def render_video(self, script: dict, style: str, options: Optional[dict] = None) -> dict:
        options = options or {}
        spoken_text = " ".join(seg.get("spoken_text", "") for seg in script.get("segments", []))

        payload = {
            "video_inputs": [{
                "character": {
                    "type": "avatar",
                    "avatar_id": options.get("avatar_id", "default"),
                },
                "voice": {
                    "type": "text",
                    "input_text": spoken_text,
                    "voice_id": options.get("voice_id", "default"),
                },
                "background": {
                    "type": options.get("background_type", "color"),
                    "value": options.get("background_value", "#ffffff"),
                },
            }],
            "dimension": {
                "width": options.get("width", 1080),
                "height": options.get("height", 1920),
            },
        }

        response = self.session.post(f"{self.BASE_URL}/video/generate", json=payload)
        response.raise_for_status()
        result = response.json()

        return {
            "job_id": result.get("data", {}).get("video_id", ""),
            "status": "processing",
            "estimated_duration": result.get("data", {}).get("estimated_duration", 120),
        }

    def check_status(self, job_id: str) -> dict:
        response = self.session.get(f"{self.BASE_URL}/video_status.get", params={"video_id": job_id})
        response.raise_for_status()
        result = response.json()
        data = result.get("data", {})

        status_map = {"processing": "rendering", "completed": "complete", "failed": "failed"}
        status = status_map.get(data.get("status", ""), "unknown")

        return {
            "job_id": job_id,
            "status": status,
            "progress_pct": 100 if status == "complete" else 50,
            "output_url": data.get("video_url") if status == "complete" else None,
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
