import logging
import sys
from fastapi import FastAPI
from app.api.v1.endpoints import router as v1_router
from app.core.config import get_settings

def configure_logging(level: str) -> None:
    logging.basicConfig(
        level=level,
        format="%(asctime)s %(levelname)s %(name)s %(message)s",
        handlers=[logging.StreamHandler(sys.stdout)],
    )

settings = get_settings()
configure_logging(settings.log_level)

app = FastAPI(title=settings.app_name, version=settings.app_version)
app.include_router(v1_router, prefix="/api/v1")
