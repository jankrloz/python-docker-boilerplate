FROM python:3.9-alpine as base

FROM base as builder
COPY requirements.txt /requirements.txt
RUN mkdir /install
WORKDIR /install

ARG BUILD_DEPS="build-base gcc musl-dev"
RUN apk add --no-cache --virtual ${BUILD_DEPS} \
    && pip install --upgrade pip \
    && pip install --no-cache-dir --prefix=/install -r /requirements.txt \
    && apk del ${BUILD_DEPS}

FROM base
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .

ENV FLASK_ENV=development
ENV FLASK_APP=./src/app.py
CMD [ "flask", "run", "--host=0.0.0.0" ]
