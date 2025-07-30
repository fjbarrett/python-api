from fastapi import APIRouter, status
from pydantic import BaseModel

from app.core.config import get_settings

router = APIRouter()


class EchoRequest(BaseModel):
    message: str


@router.get("/healthz", status_code=status.HTTP_200_OK)
def healthz():
    return {"status": "ok"}


@router.get("/readyz", status_code=status.HTTP_200_OK)
def readyz():
    # Put dependency checks here (DB, cache, etc.)
    return {"ready": True}


@router.get("/version")
def version():
    s = get_settings()
    return {"name": s.app_name, "version": s.app_version, "env": s.environment}


@router.post("/echo")
def echo(body: EchoRequest):
    return {"you_said": body.message}
