import os
import random
import time

from fastapi import FastAPI, HTTPException
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(title="sre-lab")
Instrumentator().instrument(app).expose(app)  # 自動產生 /metrics

ERROR_RATE = float(os.getenv("ERROR_RATE", "0"))  # 0.1 = 10% 回 500
MAX_DELAY = float(os.getenv("MAX_DELAY", "0"))    # 秒，隨機延遲上限


@app.get("/")
def root():
    return {"message": "hello sre-lab", "version": os.getenv("APP_VERSION", "dev")}


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/work")
def work():
    if MAX_DELAY > 0:
        time.sleep(random.uniform(0, MAX_DELAY))
    if random.random() < ERROR_RATE:
        raise HTTPException(status_code=500, detail="simulated failure")
    return {"result": "done"}
