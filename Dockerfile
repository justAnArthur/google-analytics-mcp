FROM docker.io/supercorp/supergateway:4.2.0-uvx
# the image's python 3.12 satisfies the server; never fetch another one
ENV UV_PYTHON_DOWNLOADS=never
COPY . /src/
# no lockfile here: resolve once, at build, from what PyPI had on the release date
RUN uv venv /opt/venv \
  && uv pip install --python /opt/venv --no-cache --exclude-newer 2026-10-28T00:00:00Z /src \
  && rm -rf /src
USER 65534:65534
ENV HOME=/tmp
EXPOSE 8000
# never --allow-write: without it the write tool is not registered and the scope stays readonly
CMD ["--stdio", "/opt/venv/bin/analytics-mcp", "--outputTransport", "streamableHttp", "--port", "8000", "--healthEndpoint", "/healthz"]
