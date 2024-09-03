FROM jupyter/minimal-notebook:python-3.10

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG TARGETARCH

USER root

COPY install_scanpy.sh /tmp/

RUN bash /tmp/install_scanpy.sh

RUN mamba install --yes --channel conda-forge --channel bioconda \
    python=3.10 \
    bioconda::cellxgene=1.2.0 \
    bbknn=1.6.0 \
    celltypist=1.6.2 \
    conda-forge::distinctipy=1.3.4 \
    fa2=0.3.5 \
    gseapy=1.0.6 \
    bioconda::harmonypy=0.0.9 \
    matplotlib-venn=0.11.9 \
    openpyxl=3.1.2 \
    pybiomart=0.2.0 \
    scanorama=1.7.4 \
    scanpy=1.9.6 \
    scrublet=0.2.3 \
    scvi-tools=1.0.4  && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
    leidenalg==0.10.1 \
    louvain==0.8.1

USER ${NB_UID}
WORKDIR /home/jovyan

## docker build --platform=linux/amd64 -t scanpy --file dockerfile .
## docker run --rm -ti --platform=linux/amd64 -p 8888:8888 -v ${PWD}:/home/jovyan/workdir scanpy
##
## docker tag scanpy royfrancis/scanpy:latest
## docker push royfrancis/scanpy:latest
