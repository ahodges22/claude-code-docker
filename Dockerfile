FROM node:24-slim

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Create a non-root user
RUN groupadd --gid 1001 claude && \
    useradd --uid 1001 --gid claude --shell /bin/bash --create-home claude

# Set working directory
WORKDIR /workspace

# Change ownership of workspace to claude user
RUN chown claude:claude /workspace

# Switch to non-root user
USER claude

# Set default command
CMD ["claude"]
