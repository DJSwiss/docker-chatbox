#!/bin/bash

set -e

MCP_CONFIG="/opt/chatboxai/mcp-config.json"
MCP_LOG="/tmp/mcp-servers.log"

echo "🚀 Starting MCP Servers..."

# Install MCP servers
echo "📦 Installing MCP servers..."
npm install -g \
    @modelcontextprotocol/server-filesystem \
    @modelcontextprotocol/server-brave-search \
    @modelcontextprotocol/server-github \
    @modelcontextprotocol/server-docker \
    2>&1 | tee -a "$MCP_LOG"

# Start filesystem server
echo "📁 Starting filesystem MCP server..."
npx @modelcontextprotocol/server-filesystem /tmp/shared > "$MCP_LOG.filesystem" 2>&1 &
MCP_FS_PID=$!

# Start other servers if API keys are available
if [ -n "$BRAVE_API_KEY" ]; then
    echo "🔍 Starting Brave search MCP server..."
    npx @modelcontextprotocol/server-brave-search > "$MCP_LOG.brave" 2>&1 &
    MCP_BRAVE_PID=$!
fi

if [ -n "$GITHUB_TOKEN" ]; then
    echo "🐙 Starting GitHub MCP server..."
    npx @modelcontextprotocol/server-github > "$MCP_LOG.github" 2>&1 &
    MCP_GITHUB_PID=$!
fi

# Docker MCP server (if Docker socket is available)
if [ -S "/var/run/docker.sock" ]; then
    echo "🐳 Starting Docker MCP server..."
    npx @modelcontextprotocol/server-docker > "$MCP_LOG.docker" 2>&1 &
    MCP_DOCKER_PID=$!
fi

# Save PIDs for cleanup
echo "$MCP_FS_PID" > /tmp/mcp-pids.txt
[ -n "$MCP_BRAVE_PID" ] && echo "$MCP_BRAVE_PID" >> /tmp/mcp-pids.txt
[ -n "$MCP_GITHUB_PID" ] && echo "$MCP_GITHUB_PID" >> /tmp/mcp-pids.txt
[ -n "$MCP_DOCKER_PID" ] && echo "$MCP_DOCKER_PID" >> /tmp/mcp-pids.txt

echo "✅ MCP Servers started successfully!"
echo "📝 Logs available at: $MCP_LOG.*"

# Keep script running to maintain servers
wait