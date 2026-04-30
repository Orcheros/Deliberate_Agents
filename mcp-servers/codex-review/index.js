#!/usr/bin/env node
/**
 * codex-review — MCP server for cross-LLM code review
 *
 * Accepts a diff or file content and sends it to OpenAI's API for code review.
 * Returns structured review feedback that Claude Code agents can consume.
 *
 * STUB: This is scaffolding for Phase 3+. The MCP protocol plumbing is in place;
 * the OpenAI integration needs implementation when ready.
 *
 * Environment variables:
 *   OPENAI_API_KEY — Required for actual review calls
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

const server = new Server(
  {
    name: "codex-review",
    version: "0.1.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// --- Tool Definitions --------------------------------------------------------

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "review_diff",
        description:
          "Send a git diff to OpenAI for code review. Returns structured feedback with issues, suggestions, and an overall assessment.",
        inputSchema: {
          type: "object",
          properties: {
            diff: {
              type: "string",
              description: "The git diff content to review",
            },
            context: {
              type: "string",
              description:
                "Optional context about the change (task description, acceptance criteria)",
            },
            focus_areas: {
              type: "array",
              items: { type: "string" },
              description:
                "Optional list of areas to focus on (e.g., 'security', 'performance', 'testing')",
            },
          },
          required: ["diff"],
        },
      },
      {
        name: "review_file",
        description:
          "Send a file's content to OpenAI for code review. Returns structured feedback.",
        inputSchema: {
          type: "object",
          properties: {
            file_path: {
              type: "string",
              description: "Path to the file (for context in the review)",
            },
            content: {
              type: "string",
              description: "The file content to review",
            },
            focus_areas: {
              type: "array",
              items: { type: "string" },
              description: "Optional list of areas to focus on",
            },
          },
          required: ["file_path", "content"],
        },
      },
    ],
  };
});

// --- Tool Handlers -----------------------------------------------------------

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case "review_diff":
      return handleReviewDiff(args);
    case "review_file":
      return handleReviewFile(args);
    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

async function handleReviewDiff({ diff, context, focus_areas }) {
  // STUB: Replace with actual OpenAI API call
  return {
    content: [
      {
        type: "text",
        text: JSON.stringify(
          {
            status: "stub",
            message:
              "codex-review MCP server is a stub. Install dependencies and set OPENAI_API_KEY to enable.",
            diff_length: diff.length,
            context_provided: !!context,
            focus_areas: focus_areas || [],
          },
          null,
          2
        ),
      },
    ],
  };
}

async function handleReviewFile({ file_path, content, focus_areas }) {
  // STUB: Replace with actual OpenAI API call
  return {
    content: [
      {
        type: "text",
        text: JSON.stringify(
          {
            status: "stub",
            message:
              "codex-review MCP server is a stub. Install dependencies and set OPENAI_API_KEY to enable.",
            file_path,
            content_length: content.length,
            focus_areas: focus_areas || [],
          },
          null,
          2
        ),
      },
    ],
  };
}

// --- Start Server ------------------------------------------------------------

const transport = new StdioServerTransport();
await server.connect(transport);
