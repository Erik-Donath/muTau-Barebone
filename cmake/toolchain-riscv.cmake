# cmake/toolchain-riscv.cmake

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv32)

# Use the SiFive toolchain from the Docker image
set(CMAKE_C_COMPILER   /opt/riscv-toolchain/bin/riscv64-unknown-elf-gcc)
set(CMAKE_CXX_COMPILER /opt/riscv-toolchain/bin/riscv64-unknown-elf-g++)

# Avoid trying to run target binaries on the host
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Bare-metal flags
set(CMAKE_C_FLAGS_INIT   "-ffreestanding -fno-builtin -Wall -Wextra -Werror")
set(CMAKE_CXX_FLAGS_INIT "-ffreestanding -fno-exceptions -fno-rtti -Wall -Wextra -Werror")
