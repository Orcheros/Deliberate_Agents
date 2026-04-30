# codex-review MCP Server

A Model Context Protocol (MCP) server that enables cross-LLM code review by sending diffs or file content to OpenAI's API and returning structured review feedback.

## Status

**Stub** — The MCP protocol scaffolding is complete. The OpenAI integration needs implementation.

## Tools

- `review_diff` — Send a git diff for code review
- `review_file` — Send a file's content for code review

## Setup

```bash
cd mcp-servers/codex-review
npm install
```

Set the `OPENAI_API_KEY` environment variable before running.

## Usage

This server communicates via stdio and is designed to be registered in `.mcp.json`:

```json
{
  "mcpServers": {
    "codex-review": {
      "command": "node",
      "args": ["mcp-servers/codex-review/index.js"],
      "env": {
        "OPENAI_API_KEY": "${OPENAI_API_KEY}"
      }
    }
  }
}
```

## Architecture

The Anthony Franco pattern: use Claude Code as the primary agent, but delegate code review to a different LLM (OpenAI) via MCP. This provides a second perspective on code quality without switching agent platforms.
