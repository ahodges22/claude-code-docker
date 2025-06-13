FROM node:24-slim

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Create Claude home directory and config
RUN mkdir -p /home/claude/.claude && \
    echo '{\n  "tipsHistory": {\n    "new-user-warmup": 1\n  },\n  "projects": {\n    "/workspace": {\n      "hasTrustDialogAccepted": true,\n      "projectOnboardingSeenCount": 1,\n      "allowedTools": []\n    }\n  },\n  "hasCompletedOnboarding": true\n}' > /home/claude/.claude.json && \
    chown -R 1000:1000 /home/claude && \
    chmod -R 755 /home/claude

# Set working directory
WORKDIR /workspace

# Change ownership of workspace
RUN chown 1000:1000 /workspace

# Set home directory environment variable
ENV HOME=/home/claude

# Switch to user 1000:1000
USER 1000:1000

# Set default command
CMD ["claude"]
