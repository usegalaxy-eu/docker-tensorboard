FROM condaforge/miniforge3:26.7.2-0 AS builder

RUN conda install -y -n base -c conda-forge \
        git \
        rattler-build \
        conda-index \
    && conda clean -afy

WORKDIR /src

# Fetch exactly the PR branch from the conda-forge feedstock
RUN git init \
    && git remote add origin https://github.com/conda-forge/tensorboard-feedstock.git \
    && git fetch --depth 1 origin pull/95/head \
    && git checkout FETCH_HEAD \
    && git log -1 --oneline

# Put the resulting package here
ENV CONDA_BLD_PATH=/tmp/conda-channel

# Build using the same variant config as the feedstock
RUN rattler-build build \
        --recipe recipe \
        -m .ci_support/linux_64_.yaml \
        --build-platform linux-64 \
        --target-platform linux-64

# Turn the output into a local conda channel
RUN conda index /tmp/conda-channel


FROM condaforge/miniforge3:26.7.2-0

COPY --from=builder /tmp/conda-channel /tmp/conda-channel

RUN conda create -y -n tensorboard \
        --override-channels \
        -c file:///tmp/conda-channel \
        -c conda-forge \
        python=3.14 \
        tensorboard=2.21.0 \
    && /opt/conda/envs/tensorboard/bin/tensorboard --version_tb \
    && /opt/conda/envs/tensorboard/bin/tensorboard -h >/dev/null \
    && conda clean -afy \
    && rm -rf /tmp/conda-channel

ENV PATH="/opt/conda/envs/tensorboard/bin:${PATH}"

EXPOSE 6006