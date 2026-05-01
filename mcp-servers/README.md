# MCP Servers — Cross-LLM Capabilities

MCP (Model Context Protocol) servers let Deliberate Agents use tools from other AI providers alongside Claude Code. This is optional — the system works fine without it.

## What Is MCP?

MCP is a standard that lets AI tools talk to each other. In Deliberate Agents, it's used to get a **second opinion** on code — specifically, having OpenAI review code that Claude wrote. Different AI models catch different things, so a cross-LLM review can surface issues that a single model might miss.

## Available Servers

### `codex-review/`

A code review server powered by OpenAI. It exposes two tools:

- **`review_diff`** — Send a code change (diff) to OpenAI for review
- **`review_file`** — Send an entire file to OpenAI for review

Both return structured feedback: issues found, suggestions, and an overall assessment.

**Status:** Stub implementation. The MCP plumbing is in place, but the actual OpenAI integration needs to be completed.

## Setting Up (When Ready)

1. Install dependencies:
   ```bash
   cd mcp-servers/codex-review
   npm install
   ```

2. Set your OpenAI API key:
   ```bash
   export OPENAI_API_KEY="your-key-here"
   ```

3. In your project's `.mcp.json`, uncomment the `codex-review` entry:
   ```json
   {
     "mcpServers": {
       "codex-review": {
         "command": "node",
         "args": ["path/to/mcp-servers/codex-review/index.js"],
         "env": {
           "OPENAI_API_KEY": "${OPENAI_API_KEY}"
         }
       }
     }
   }
   ```

4. Add the codex-review tools to the relevant agent's tool list in its agent definition.

## Adding New MCP Servers

You can add more MCP servers for other capabilities — different AI providers, specialized tools, external APIs. Each server is a small Node.js application that follows the MCP protocol. Create a new directory here with its own `index.js`, `package.json`, and `README.md`.
