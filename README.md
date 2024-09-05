# docker-scanpy

Docker container for single-cell transcriptomics analysis

- **Framework**: scanpy
- **Doublet detection**: scrublet
- **Celltyping**: celltypist
- **Integration**: bbknn, harmonypy, pyliger, scvi, scanorama, scib-metrics
- **Other**: jupyterlab, quarto, vscode

## Run container

```
## to run jupyterlab
docker run --rm --platform=linux/amd64 -p 8888:8888 -v ${PWD}:/home/jovyan/workdir ghcr.io/royfrancis/scanpy:latest

## to run python commands
docker run --rm --platform=linux/amd64 -u 1000:1000 -v ${PWD}:/home/jovyan/workdir ghcr.io/royfrancis/scanpy:latest python --version
```

## Build container

```
docker build --platform=linux/amd64 -t scanpy:latest --file dockerfile .
```

---

2024 Roy Francis
