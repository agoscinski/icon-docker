# Use an Ubuntu base image
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV SPACK_ROOT=/opt/spack
#ENV PATH="$SPACK_ROOT/bin:$PATH" # this should be taken over by spack/setup-env.sh but it has to be run for every RUN command

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    python3 \
    python3-pip \
    python3-venv \
    vim \
    wget \
    unzip \
    tar \
    g++ \
    gfortran \
    && rm -rf /var/lib/apt/lists/*

# Clone SPACK
RUN git clone --depth=1 https://github.com/spack/spack.git $SPACK_ROOT

# Set environment variables for SPACK
# TODO migh need to be in ~/.bashrc, not sure
RUN echo "export SPACK_ROOT=/opt/spack" >> /etc/profile.d/spack.sh && \ 
    echo ". /opt/spack/share/spack/setup-env.sh" >> /etc/profile.d/spack.sh

# Source SPACK in the container
SHELL ["/bin/bash", "-c"]

# Set up SPACK environment
RUN . /opt/spack/share/spack/setup-env.sh && spack bootstrap now && spack install icon

# Expose a shell with SPACK preloaded
CMD ["/bin/bash", "-l"]
