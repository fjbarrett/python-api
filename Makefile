.PHONY: install dev test lint type run build up down fmt

    install:
	pip install -r requirements.txt

    dev:
	pip install -r requirements.txt -r requirements-dev.txt

    test:
	pytest -q

    lint:
	ruff check .

    type:
	mypy app

    fmt:
	black .

    run:
	uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 1 --reload

    build:
	docker build -t python-api:dev .

    up:
	docker compose up --build -d

    down:
	docker compose down
