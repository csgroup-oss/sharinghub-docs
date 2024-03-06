FROM python:3.11-alpine as builder

WORKDIR /

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p /docs
COPY mkdocs.yml /docs
COPY src /docs/src

WORKDIR /docs

RUN mkdocs build

FROM nginx:1.25-alpine3.18

ARG VERSION=latest
LABEL version=${VERSION}

COPY --from=builder /docs/build/html /usr/share/nginx/html

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
