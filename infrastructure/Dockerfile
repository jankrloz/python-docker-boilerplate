FROM python:3.9-alpine as base

FROM base as builder
RUN apk add build-base
RUN mkdir /install
WORKDIR /install
COPY requirements.txt /requirements.txt
RUN pip install --prefix=/install -r /requirements.txt

FROM base
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .

CMD [ "python", "index.py" ]
