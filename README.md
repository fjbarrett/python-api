# python-api

Minimal FastAPI service with Docker, CI, and tests.

## Local dev
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt -r requirements-dev.txt
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
# http://127.0.0.1:8000/api/v1/healthz
```

## Docker
```bash
docker build -t python-api:dev .
docker run -p 8000:8000 -e APP_ENV=production python-api:dev
```

## Compose
```bash
docker compose up --build
```
