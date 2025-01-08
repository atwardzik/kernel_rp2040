set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER "/Applications/ArmGNUToolchain/14.2.rel1/arm-none-eabi/bin/arm-none-eabi-gcc" CACHE INTERNAL "")
set(CMAKE_ASM_COMPILER "/Applications/ArmGNUToolchain/14.2.rel1/arm-none-eabi/bin/arm-none-eabi-as" CACHE INTERNAL "")

set(CMAKE_C_FLAGS "-Wall -Wextra -Wpedantic -Werror -Wno-unused-variable -Wno-error=unused-parameter -std=c2x -mcpu=cortex-m0 -ffreestanding -mthumb -g -O0" CACHE INTERNAL "")
set(CMAKE_ASM_FLAGS "--warn --fatal-warnings -mcpu=cortex-m0 -mthumb -g" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "" CACHE INTERNAL "")

set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_ASM_COMPILER_FORCED TRUE)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

include_directories("/Applications/ArmGNUToolchain/14.2.rel1/arm-none-eabi/include")
set(CMAKE_FIND_ROOT_PATH "/Applications/ArmGNUToolchain/14.2.rel1/arm-none-eabi/arm-none-eabi/include")

SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

