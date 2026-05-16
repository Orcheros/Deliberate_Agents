"""Notion integration client for Deliberate_Agents content automation."""

import os
import sys
import json
import argparse
from datetime import datetime, date
from notion_client import Client


class NotionClient:
    """Interface to Notion content database."""

    def __init__(self, token=None, database_id=None):
        self.token = token or os.environ.get("NOTION_TOKEN")
        self.database_id = database_id or os.environ.get("NOTION_CONTENT_DB")
        if not self.token:
            raise ValueError("NOTION_TOKEN environment variable required")
        if not self.database_id:
            raise ValueError("NOTION_CONTENT_DB environment variable required")
        self.client = Client(auth=self.token)

    def query_by_status(self, status: str) -> list[dict]:
        """Query content DB for pages with given status."""
        response = self.client.databases.query(
            database_id=self.database_id,
            filter={"property": "Status", "select": {"equals": status}}
        )
        return response.get("results", [])

    def query_scheduled_today(self) -> list[dict]:
        """Query for posts scheduled for today."""
        today = date.today().isoformat()
        response = self.client.databases.query(
            database_id=self.database_id,
            filter={
                "and": [
                    {"property": "Status", "select": {"equals": "Scheduled"}},
                    {"property": "Publish Date", "date": {"equals": today}}
                ]
            }
        )
        return response.get("results", [])

    def create_page(self, title: str, properties: dict = None) -> dict:
        """Create a new page in the content database."""
        page_properties = {
            "Title": {"title": [{"text": {"content": title}}]},
            "Status": {"select": {"name": properties.get("status", "Idea")}},
        }
        if "pillar" in properties:
            page_properties["Pillar"] = {"select": {"name": properties["pillar"]}}
        if "format" in properties:
            page_properties["Format"] = {"select": {"name": properties["format"]}}
        if "channel" in properties:
            page_properties["Channel"] = {"multi_select": [{"name": c} for c in properties["channel"]]}
        if "hook_type" in properties:
            page_properties["Hook Type"] = {"select": {"name": properties["hook_type"]}}
        if "publish_date" in properties:
            page_properties["Publish Date"] = {"date": {"start": properties["publish_date"]}}

        return self.client.pages.create(
            parent={"database_id": self.database_id},
            properties=page_properties
        )

    def update_status(self, page_id: str, new_status: str) -> dict:
        """Update the status of a content page."""
        return self.client.pages.update(
            page_id=page_id,
            properties={"Status": {"select": {"name": new_status}}}
        )

    def update_metrics(self, page_id: str, metrics_text: str) -> dict:
        """Update the metrics field of a content page."""
        return self.client.pages.update(
            page_id=page_id,
            properties={
                "Metrics": {"rich_text": [{"text": {"content": metrics_text}}]}
            }
        )

    def update_post_id(self, page_id: str, post_id: str) -> dict:
        """Write LinkedIn Post ID back to Notion."""
        return self.client.pages.update(
            page_id=page_id,
            properties={
                "LinkedIn Post ID": {"rich_text": [{"text": {"content": post_id}}]},
                "Status": {"select": {"name": "Published"}}
            }
        )

    def get_page(self, page_id: str) -> dict:
        """Retrieve a single page by ID."""
        return self.client.pages.retrieve(page_id=page_id)

    def get_published_with_metrics(self, limit: int = 50) -> list[dict]:
        """Get published posts for metrics tracking."""
        response = self.client.databases.query(
            database_id=self.database_id,
            filter={"property": "Status", "select": {"equals": "Published"}},
            page_size=limit
        )
        return response.get("results", [])


def main():
    parser = argparse.ArgumentParser(description="Notion content database client")
    parser.add_argument("--test", action="store_true", help="Run integration test")
    parser.add_argument("--query-status", type=str, help="Query pages by status")
    parser.add_argument("--scheduled-today", action="store_true", help="Get today's scheduled posts")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    args = parser.parse_args()

    try:
        client = NotionClient()
    except ValueError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)

    if args.test:
        print("Testing Notion connection...")
        try:
            results = client.query_by_status("Idea")
            print(f"SUCCESS: Connected. Found {len(results)} ideas in database.")
            return
        except Exception as e:
            print(f"FAILED: {e}", file=sys.stderr)
            sys.exit(1)

    if args.query_status:
        results = client.query_by_status(args.query_status)
        if args.json:
            print(json.dumps(results, indent=2, default=str))
        else:
            for page in results:
                title = page["properties"]["Title"]["title"][0]["text"]["content"] if page["properties"]["Title"]["title"] else "Untitled"
                print(f"  - {title} ({page['id'][:8]})")
            print(f"\nTotal: {len(results)} pages")

    if args.scheduled_today:
        results = client.query_scheduled_today()
        if args.json:
            print(json.dumps(results, indent=2, default=str))
        else:
            for page in results:
                title = page["properties"]["Title"]["title"][0]["text"]["content"] if page["properties"]["Title"]["title"] else "Untitled"
                print(f"  - {title} ({page['id'][:8]})")
            print(f"\nScheduled today: {len(results)} posts")


if __name__ == "__main__":
    main()
