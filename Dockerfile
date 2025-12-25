FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        ninja-build \
        wget \
        ca-certificates \
        make && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Install RISC-V toolchain
RUN wget -q https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14.tar.gz && \
    tar -xzf riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14.tar.gz -C /opt && \
    mv /opt/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14 /opt/riscv-toolchain && \
    rm riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14.tar.gz

RUN mkdir -p /opt/riscv-bin && \
    cd /opt/riscv-bin && \
    for tool in gcc g++ ar as ld objcopy objdump ranlib readelf size strip nm; do \
        ln -sf /opt/riscv-toolchain/bin/riscv64-unknown-elf-${tool} riscv64-unknown-elf-${tool}; \
        ln -sf /opt/riscv-toolchain/bin/riscv64-unknown-elf-${tool} riscv-none-elf-${tool}; \
        ln -sf /opt/riscv-toolchain/bin/riscv64-unknown-elf-${tool} riscv32-unknown-elf-${tool}; \
    done && \
    ln -sf /opt/riscv-toolchain/bin/riscv64-unknown-elf-ar riscv64-unknown-elf-gcc-ar

ENV PATH="/opt/riscv-bin:/opt/riscv-toolchain/bin:${PATH}"

WORKDIR /work

CMD ["/bin/bash"]
