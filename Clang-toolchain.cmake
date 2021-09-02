# TODO : See https://github.com/vpetrigo/arm-cmake-toolchains/

# WIP : NOT WORKING RIGHT NOW

cmake_minimum_required(VERSION 3.13)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

if(DEFINED ENV{GCC_ARM_TOOLCHAIN})
    set(GCC_ARM_TOOLCHAIN $ENV{GCC_ARM_TOOLCHAIN})
else()
    set(GCC_ARM_TOOLCHAIN "/usr/xcc/arm-none-eabi-cross")
endif()

LIST(APPEND CMAKE_PROGRAM_PATH ${GCC_ARM_TOOLCHAIN})

# Specify the cross compiler
# The target triple needs to match the prefix of the binutils exactly
# (e.g. CMake looks for arm-none-eabi-ar)
set(CLANG_TARGET_TRIPLE arm-none-eabi)
set(GCC_ARM_TOOLCHAIN_PREFIX ${CLANG_TARGET_TRIPLE})
set(CMAKE_C_COMPILER clang-11)
set(CMAKE_C_COMPILER_TARGET ${CLANG_TARGET_TRIPLE})
set(CMAKE_CXX_COMPILER clang++-11)
set(CMAKE_CXX_COMPILER_TARGET ${CLANG_TARGET_TRIPLE})
set(CMAKE_ASM_COMPILER clang-11)
set(CMAKE_ASM_COMPILER_TARGET ${CLANG_TARGET_TRIPLE})

# Don't run the linker on compiler check
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(ARM_TOOLCHAIN_DIR "/usr/xcc/arm-none-eabi-cross/bin")

# Specify compiler flags
# set(ARCH_FLAGS "-mcpu=cortex-a5 -mthumb -mfpu=neon-vfpv4 -mfloat-abi=hard -mno-unaligned-access")

set(GCC_VERSION 9.3.1)
set(GCC_MULTIDIR_CPU_SPECIFIC "thumb/v7e-m+fp/hard")

set(CMAKE_C_FLAGS "-B${ARM_TOOLCHAIN_DIR} -Wall ${ARCH_FLAGS}" CACHE STRING "Common flags for C compiler")
set(CMAKE_CXX_FLAGS "-B${ARM_TOOLCHAIN_DIR} -Wall -std=c++17 -fno-exceptions -fno-rtti -fno-threadsafe-statics ${ARCH_FLAGS}" CACHE STRING "Common flags for C++ compiler")
set(CMAKE_ASM_FLAGS "-B${ARM_TOOLCHAIN_DIR} -Wall ${ARCH_FLAGS} -x assembler-with-cpp" CACHE STRING "Common flags for assembler")
set(CMAKE_EXE_LINKER_FLAGS "-B${ARM_TOOLCHAIN_DIR} -nostartfiles -Wl,-Map,kernel.map,--gc-sections -fuse-linker-plugin --specs=nano.specs --specs=nosys.specs -nostdlib -L/usr/xcc/arm-none-eabi-cross/arm-none-eabi/lib/${GCC_MULTIDIR_CPU_SPECIFIC} -lgcc" CACHE STRING "")
# FIXME : CMAKE_EXE_LINKER_FLAGS:STRING=-B/usr/xcc/arm-none-eabi-cross/bin -nostartfiles -Wl,-Map,kernel.map,--gc-sections -fuse-linker-plugin -nostdlib -L/usr/xcc/arm-none-eabi-cross/lib/gcc/arm-none-eabi/9.3.1/thumb/v7e-m+fp/hard -L/usr/xcc/arm-none-eabi-cross/arm-none-eabi/lib/thumb/v7e-m+fp/hard/ -lgcc -lm -lc --specs=nano.specs --specs=nosys.specs /usr/xcc/arm-none-eabi-cross/lib/gcc/arm-none-eabi/9.3.1/thumb/v7e-m+fp/hard/crti.o /usr/xcc/arm-none-eabi-cross/lib/gcc/arm-none-eabi/9.3.1/thumb/v7e-m+fp/hard/crtn.o /usr/xcc/arm-none-eabi-cross/lib/gcc/arm-none-eabi/9.3.1/thumb/v7e-m+fp/hard/crtfastmath.o /usr/xcc/arm-none-eabi-cross/lib/gcc/arm-none-eabi/9.3.1/thumb/v7e-m+fp/hard/crtbegin.o /usr/xcc/arm-none-eabi-cross/lib/gcc/arm-none-eabi/9.3.1/thumb/v7e-m+fp/hard/crtend.o


include_directories(SYSTEM "/usr/xcc/arm-none-eabi-cross/arm-none-eabi/include/c++/${GCC_VERSION}/" "/usr/xcc/arm-none-eabi-cross/arm-none-eabi/include/c++/${GCC_VERSION}/arm-none-eabi/${GCC_MULTIDIR_CPU_SPECIFIC}")

# C/C++ toolchain
set(GCC_ARM_SYSROOT "${GCC_ARM_TOOLCHAIN}/${GCC_ARM_TOOLCHAIN_PREFIX}")
set(CMAKE_SYSROOT ${GCC_ARM_SYSROOT})
set(CMAKE_FIND_ROOT_PATH ${GCC_ARM_SYSROOT})

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)