# The just-agents image

The `just-agents` branch of this fork builds the image [just-agents](https://github.com/justAnArthur/just-agents)
runs: read-only Google Analytics 4 (account summaries and Data API reports). It never gets `--allow-write`, so the write tool is not registered. It is this server over stdio, wrapped in
[supergateway](https://github.com/supercorp-ai/supergateway) as streamable HTTP.

- Port `8000`, MCP at `/mcp`, health at `/healthz`.
- `SUPERGATEWAY_API_KEY` is required; callers send it as `Authorization: Bearer <key>`, and a call without it gets 401.
- Runs as `65534:65534` and works on a read-only root with a tmpfs on `/tmp`.
- Env: `GOOGLE_APPLICATION_CREDENTIALS`, the path of a mounted service-account key with Analytics read access, and `GOOGLE_CLOUD_PROJECT`.

```sh
docker build -t mcp .
docker run --read-only --tmpfs /tmp -p 8000:8000 -e SUPERGATEWAY_API_KEY=… <env above> mcp
```

A compose builds it straight from git:

```yaml
services:
  mcp:
    build:
      context: https://github.com/justAnArthur/google-analytics-mcp.git#just-agents
```
