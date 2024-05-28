# SharingHub Docs

## Table of contents

- [Development](#development)
  - [Environment setup](#environment-setup)
  - [Serve](#serve)
- [Production](#production)
  - [Local build](#local-build)
  - [Docker image](#docker-image)

## Development

### Environment setup

Python 3.11 required.

Setup the environment:

```bash
python -mvenv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Install the [pre-commit](https://pre-commit.com/) hooks:

```bash
pre-commit install --install-hooks
```

### Serve

Edit the docs and update it live with MkDocs:

```bash
mkdocs serve
```

## Production

### Local build

Build the docs with:

```bash
mkdocs build
```

### Docker image

Build the image with:

```bash
docker build . -t sharinghub-docs --build-arg VERSION=$(git rev-parse --short HEAD)
```

Run it locally with:

```bash
docker run --rm -p 5000:80 --name sharinghub-docs sharinghub-docs:latest
```

## Copyright and License

Copyright 2024 `CS GROUP - France`

**SharingHub Docs**  is an open source software, distributed under the Apache License 2.0. See the [`LICENSE`](./LICENSE) file for more information.
