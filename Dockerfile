# syntax=docker/dockerfile:1.7
ARG PYTHON_VERSION=3.12-slim
FROM python:${PYTHON_VERSION} AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    APP_HOME=/app

WORKDIR ${APP_HOME}
RUN addgroup --system app && adduser --system --ingroup app app

# ---- deps layer
FROM base AS builder
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    libffi-dev \
    libssl-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt requirements-dev.txt ./
RUN python -m pip install --upgrade pip && pip wheel --wheel-dir /wheels -r requirements.txt

# ---- runtime
FROM base AS runtime
ENV PORT=8000
COPY --from=builder /wheels /wheels
RUN pip install --no-index --find-links=/wheels /wheels/* && rm -rf /wheels

COPY app ./app
USER app

EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD ["python","-c","import urllib.request,sys; \
try: \
    resp = urllib.request.urlopen('http://127.0.0.1:8000/api/v1/healthz', timeout=2); \
    sys.exit(0 if resp.status==200 else 1) \
except Exception: \
    sys.exit(1)"]


CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "-w", "2", "-b", "0.0.0.0:8000", "app.main:app"]
