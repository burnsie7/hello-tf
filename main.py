import socket
import uvicorn
from fastapi import FastAPI

visits = 0
app = FastAPI()
@app.get("/")
async def index():
   visits += 1
   hn = socket.gethostname()
   return {"message": f"Hello World from host: {hn}.  I've had {visits} visits!"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
