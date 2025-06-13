FROM node:24-slim

# Install system dependencies
RUN apt-get update && \
    apt-get install -y wget curl unzip jq build-essential \
        libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install latest stable Python 3
RUN PYTHON_VERSION=$(curl -s https://endoflife.date/api/python.json | jq -r '.[0].latest') && \
    wget -q https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    cd .. && \
    rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz && \
    ln -s /usr/local/bin/python$(echo ${PYTHON_VERSION} | cut -d. -f1,2) /usr/local/bin/python3 && \
    ln -s /usr/local/bin/python3 /usr/local/bin/python

# Install latest Go
RUN GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -1) && \
    wget -q https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf ${GO_VERSION}.linux-amd64.tar.gz && \
    rm ${GO_VERSION}.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

# Install latest Terraform
RUN TERRAFORM_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name' | sed 's/v//') && \
    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

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
