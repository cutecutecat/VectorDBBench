FROM python:3.11-bookworm as builder-image

RUN apt-get update

COPY install/requirements_py3.11.txt .
RUN pip3 install -U pip
RUN pip3 install --no-cache-dir -r requirements_py3.11.txt

FROM python:3.11-slim-bookworm

COPY --from=builder-image /usr/local/bin /usr/local/bin
COPY --from=builder-image /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

WORKDIR /opt/code
COPY . .
ENV PYTHONPATH /opt/code
RUN apt-get update && apt-get install libpq5 -y

ENTRYPOINT ["python3", "-m", "vectordb_bench"]
