FROM jupyter/minimal-notebook:python-3.10

LABEL org.opencontainers.image.title="Scanpy"
LABEL org.opencontainers.image.description="Scanpy development environment for single-cell rnaseq"
LABEL org.opencontainers.image.authors="Roy Francis"
LABEL org.opencontainers.image.source="https://github.com/royfrancis/docker-scanpy"
LABEL org.opencontainers.image.created="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG TARGETARCH="amd64"

USER root

COPY install.sh /tmp/
COPY requirements.txt /tmp/

RUN chmod +x /tmp/install.sh && \
    /tmp/install.sh && \
    rm -f /tmp/install.sh

RUN mamba update -y mamba && \
    mamba install -y -c conda-forge -c bioconda python=3.10 jax jaxlib cmake && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm -f /tmp/requirements.txt
    # cat /tmp/requirements.txt | sed -e '/^\s*#.*$/d' -e '/^\s*$/d' | xargs -n 1 pip install --no-cache-dir

USER ${NB_UID}
WORKDIR /home/jovyan

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import os; import numpy; import pandas; import matplotlib; import pickle; import scanpy; import bbknn; import harmonypy; import scanorama; import celltypist; import gseapy; sys.exit(0)" || exit 1

## build local
## docker build --platform=linux/amd64 -t ghcr.io/royfrancis/scanpy:1.3 -t ghcr.io/royfrancis/scanpy:latest --file dockerfile .
## docker run --rm --platform=linux/amd64 -p 8888:8888 -v ${PWD}:/home/jovyan/workdir ghcr.io/royfrancis/scanpy:latest
## docker run --rm -ti --platform=linux/amd64 -u 1000:1000 -v ${PWD}:/home/jovyan/workdir ghcr.io/royfrancis/scanpy:latest bash
## docker push ghcr.io/royfrancis/scanpy:1.3
## docker push ghcr.io/royfrancis/scanpy:latest
## docker run --rm --platform=linux/amd64 -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/work kaczmarj/apptainer build scanpy-1.3.sif docker://ghcr.io/royfrancis/scanpy:1.3
