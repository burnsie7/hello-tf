import socket
import uvicorn
from fastapi import FastAPI

app = FastAPI()
@app.get("/")
async def index():
   hn = socket.gethostname()
   return {"message": f"Hello World from host: {hn}"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
