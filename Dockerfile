# Use an Ubuntu base image
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
# this is wrongly resolved when using docker run
#ENV SPACK_ROOT=/opt/spack

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
      sudo \
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
      gfortran && \
    rm -rf /var/lib/apt/lists/*

## Add sudo user

RUN adduser root sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

## Icon


# clone currently latest release
RUN git clone --depth=2 --branch=releases/v0.23 https://github.com/spack/spack.git /opt/spack
#RUN echo "export SPACK_ROOT=/opt/spack" >> /etc/profile.d/spack.sh && \ 

# Set environment variables for SPACK
# TODO might need to be in ~/.bashrc, not sure
#RUN echo "export SPACK_ROOT=/opt/spack" >> /etc/profile.d/spack.sh && \ 
#    echo ". /opt/spack/share/spack/setup-env.sh" >> /etc/profile.d/spack.sh

# Set up SPACK environment
#RUN . /opt/spack/share/spack/setup-env.sh && spack bootstrap now && spack install icon


# Source SPACK in the container
# Expose a shell with SPACK preloaded

#RUN echo ". $SPACK_ROOT/share/spack/setup-env.sh" >> ~/.bashrc
# to source the ~/.bashrc always, I am not sure if smart
#SHELL ["/bin/bash", "-i"]
RUN . /opt/spack/share/spack/setup-env.sh && spack install gmake 
ENTRYPOINT . /opt/spack/share/spack/setup-env.sh && spack load gmake
#CMD ["/bin/bash", "-c", ". $SPACK_ROOT/share/spack/setup-env.sh && exec bash"]
