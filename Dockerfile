FROM python:3.13.3-bookworm

WORKDIR /app

RUN apt-get update && \
    apt-get install -y git build-essential iputils-ping

RUN git clone https://github.com/b4rtaz/distributed-llama.git
WORKDIR /app/distributed-llama
RUN make dllama
RUN make dllama-api

CMD ["sleep", "infinity"]
