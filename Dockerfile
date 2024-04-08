FROM ubuntu:22.04

WORKDIR /root

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
  ca-certificates \
  nano \
  wget \
  curl \
  gnupg \
  ripgrep \
  ltrace \
  file\
  python3-minimal \
  build-essential \
  git \
  cmake \
  ninja-build \
  jq
ENV PATH="${PATH}:/opt/rocm/bin:/opt/rocm/llvm/bin:/usr/local/cuda/bin/"

ARG CUDA_VERSION=11-8
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb && \
  dpkg -i cuda-keyring_1.0-1_all.deb && \
  apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
  nvidia-headless-no-dkms-515 \
  nvidia-utils-515 \
  cuda-cudart-${CUDA_VERSION} \
  cuda-compiler-${CUDA_VERSION} \
  libcufft-dev-${CUDA_VERSION} \
  libcusparse-dev-${CUDA_VERSION} \
  libcublas-dev-${CUDA_VERSION} \
  cuda-nvml-dev-${CUDA_VERSION} \
  libcudnn8-dev

ARG RUST_VERSION=1.77.1
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain=${RUST_VERSION}
RUN . $HOME/.cargo/env && cargo install bindgen-cli --locked

ARG ROCM_VERSION=5.7.3
RUN echo "Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600" > /etc/apt/preferences.d/rocm-pin-600
RUN mkdir --parents --mode=0755 /etc/apt/keyrings && \
  sh -c 'wget https://repo.radeon.com/rocm/rocm.gpg.key -O - |  gpg --dearmor | tee /etc/apt/keyrings/rocm.gpg > /dev/null' && \
  sh -c 'echo deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/${ROCM_VERSION} jammy main > /etc/apt/sources.list.d/rocm.list' && \
  apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
  rocminfo \
  rocm-gdb \
  rocprofiler \
  rocm-smi-lib \
  hip-runtime-amd \
  comgr \
  hipblaslt-dev \
  hipfft-dev \
  rocblas-dev \
  rocsolver-dev \
  rocsparse-dev \
  miopen-hip-dev \
  rocm-device-libs && \
  echo 'export PATH="$PATH:/opt/rocm/bin"' > /etc/profile.d/rocm.sh && \
  echo '/opt/rocm/lib' > /etc/ld.so.conf.d/rocm.conf && \
  ldconfig

RUN git clone --recurse-submodules https://github.com/vosen/zluda.git
RUN cd zluda && \
    . $HOME/.cargo/env && \
    cargo xtask --release

ARG QLI_VERSION="1.9.0"
ENV QLI_VERSION=$QLI_VERSION
COPY run.sh .
RUN wget https://dl.qubic.li/downloads/qli-Client-${QLI_VERSION}-Linux-x64.tar.gz && \
    tar xf qli-Client-${QLI_VERSION}-Linux-x64.tar.gz && \
    chmod +x qli-Client

CMD ["./run.sh"]
