from functools import lru_cache
from pydantic import BaseModel
import os

class Settings(BaseModel):
    app_name: str = os.getenv("APP_NAME", "python-api")
    app_version: str = os.getenv("APP_VERSION", "0.1.0")
    log_level: str = os.getenv("LOG_LEVEL", "INFO")
    environment: str = os.getenv("APP_ENV", "development")

@lru_cache
def get_settings() -> Settings:
    return Settings()
