FROM ubuntu:18.04

ENV RISCV=/opt/riscv/toolchains
WORKDIR /home/main
ENV PATH=$RISCV/bin:$PATH

RUN apt-get update && \
  # for essential
  apt-get install -y git \
  # for toolchain
  autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev \
  # for qemu
  pkg-config libglib2.0-dev libpixman-1-dev

# download riscv toolchain
RUN git clone --recursive https://github.com/riscv/riscv-gnu-toolchain

# install riscv toolchain
RUN cd riscv-gnu-toolchain && \
  ./configure --prefix=$RISCV && \
  make newlib > /dev/null 2>&1 && \
  make linux > /dev/null 2>&1

# build qemu
RUN git clone https://github.com/qemu/qemu.git -b v4.2.0 && \
  cd qemu && \
  ./configure --disable-werror --prefix=$RISCV --target-list=riscv64-softmmu,riscv32-softmmu,riscv64-linux-user,riscv32-linux-user && \
  make && make install
