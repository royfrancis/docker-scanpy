FROM jupyter/minimal-notebook:python-3.10

LABEL authors="Roy Francis"
LABEL Description="Scanpy development environment for single-cell rnaseq"
LABEL org.opencontainers.image.authors="zydoosu@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/royfrancis/docker-scanpy"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG TARGETARCH

USER root

COPY install.sh /tmp/

RUN bash /tmp/install.sh

RUN mamba update -y mamba && \
    mamba install -y -c conda-forge -c bioconda python=3.10 jax jaxlib cmake && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

COPY requirements.txt /tmp/
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt
    # cat /tmp/requirements.txt | sed -e '/^\s*#.*$/d' -e '/^\s*$/d' | xargs -n 1 pip install --no-cache-dir

USER ${NB_UID}
WORKDIR /home/jovyan

## docker build --platform=linux/amd64 -t ghcr.io/royfrancis/scanpy:1.2 --file dockerfile .
## docker tag ghcr.io/royfrancis/scanpy:1.2 ghcr.io/royfrancis/scanpy:latest
## docker run --rm --platform=linux/amd64 -p 8888:8888 -v ${PWD}:/home/jovyan/workdir ghcr.io/royfrancis/scanpy:latest
## docker run --rm -ti --platform=linux/amd64 -u 1000:1000 -v ${PWD}:/home/jovyan/workdir ghcr.io/royfrancis/scanpy:latest bash
## docker push ghcr.io/royfrancis/scanpy:1.2 
## docker push ghcr.io/royfrancis/scanpy:latest
