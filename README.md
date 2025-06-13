# Claude Code Docker

A slim Docker container for running [Claude Code](https://github.com/anthropics/claude-code) - Anthropic's official CLI for Claude.

## Usage

### Pull from GitHub Container Registry

```bash
docker pull ghcr.io/ahodges22/claude-code-docker:latest
```

### Run the container

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -e ANTHROPIC_API_KEY=your_api_key_here \
  ghcr.io/ahodges22/claude-code-docker:latest
```

### Mount your project directory

```bash
docker run -it --rm \
  -v /path/to/your/project:/workspace \
  -e ANTHROPIC_API_KEY=your_api_key_here \
  ghcr.io/ahodges22/claude-code-docker:latest
```

## Environment Variables

- `ANTHROPIC_API_KEY` - Your Anthropic API key (required)

## Building Locally

```bash
docker build -t claude-code .
docker run -it --rm -v $(pwd):/workspace -e ANTHROPIC_API_KEY=your_key claude-code
```

## Base Image

- **Base**: `node:24-slim`
- **User**: Non-root user `claude` (UID: 1001)
- **Working Directory**: `/workspace`
