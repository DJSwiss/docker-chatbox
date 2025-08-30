#!/bin/bash

set -e

echo "🚀 Starting ChatBoxAI with MCP Support"

# Start MCP servers if enabled
if [ "$MCP_ENABLED" = "true" ]; then
    echo "🔗 Starting MCP servers..."
    ./start-mcp.sh &
    MCP_PID=$!
    
    # Give MCP servers time to start
    sleep 5
    
    echo "✅ MCP servers started (PID: $MCP_PID)"
fi

# Start main ChatBoxAI application
echo "🤖 Starting ChatBoxAI application..."
exec ./chatboxai "$@"