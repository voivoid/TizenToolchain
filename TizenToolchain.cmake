set(TIZEN_SDK_DIR $ENV{TIZEN_SDK_DIR})
if(NOT DEFINED TIZEN_SDK_DIR)
  message(FATAL_ERROR "Tizen SDK dir is not set")
endif()

set(TIZEN_SDK_VERSION 2.4)

if(DEFINED ENV{TIZEN_EMULATOR_BUILD})
  set(TIZEN_TARGET i386-linux-gnueabi)
  set(CMAKE_SYSROOT "${TIZEN_SDK_DIR}/platforms/tizen-${TIZEN_SDK_VERSION}/mobile/rootstraps/mobile-${TIZEN_SDK_VERSION}-emulator.core")
else()
  set(TIZEN_TARGET arm-linux-gnueabi)
  set(CMAKE_SYSROOT "${TIZEN_SDK_DIR}/platforms/tizen-${TIZEN_SDK_VERSION}/mobile/rootstraps/mobile-${TIZEN_SDK_VERSION}-device.core")
endif()

set(CMAKE_SYSTEM_NAME    Generic)
set(CMAKE_SYSTEM_VERSION 1)

find_program(GNU_ARM_C   NAMES arm-linux-gnueabi-gcc arm-linux-gnueabi-gcc-6)
find_program(GNU_ARM_CXX NAMES arm-linux-gnueabi-g++ arm-linux-gnueabi-g++-6)
find_program(GNU_ARM_AR        arm-linux-gnueabi-ar)
find_program(GNU_ARM_RANLIB    arm-linux-gnueabi-ranlib)

if((NOT(GNU_ARM_C STREQUAL "GNU_ARM_C-NOTFOUND")) AND
   (NOT(GNU_ARM_CXX STREQUAL "GNU_ARM_CXX-NOTFOUND")))
  set(CMAKE_C_COMPILER ${GNU_ARM_C})
  set(CMAKE_CXX_COMPILER ${GNU_ARM_CXX})
  set(CMAKE_AR ${GNU_ARM_AR})
  set(CMAKE_RANLIB ${GNU_ARM_RANLIB})
  set(CMAKE_EXE_LINKER_FLAGS "-static-libgcc -static-libstdc++ ${CMAKE_EXE_LINKER_FLAGS}")
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
else()
  set(TIZEN_TOOLCHAIN_DIR "${TIZEN_SDK_DIR}/tools/${TIZEN_TARGET}-gcc-4.9")
  set(CMAKE_C_COMPILER   "${TIZEN_TOOLCHAIN_DIR}/bin/${TIZEN_TARGET}-gcc")
  set(CMAKE_CXX_COMPILER   "${TIZEN_TOOLCHAIN_DIR}/bin/${TIZEN_TARGET}-g++")
  set(CMAKE_AR "${TIZEN_TOOLCHAIN_DIR}/bin/${TIZEN_TARGET}-ar")
  set(CMAKE_RANLIB "${TIZEN_TOOLCHAIN_DIR}/bin/${TIZEN_TARGET}-ranlib")
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
endif()

set(CMAKE_C_FLAGS "-fPIE ${CMAKE_C_FLAGS} --sysroot=${CMAKE_SYSROOT}" CACHE STRING "" )
set(CMAKE_CXX_FLAGS "-fPIE ${CMAKE_CXX_FLAGS} --sysroot=${CMAKE_SYSROOT}" CACHE STRING "" )
set(CMAKE_EXE_LINKER_FLAGS "-pie -s -Wl,--as-needed -Wl,--no-undefined ${CMAKE_EXE_LINKER_FLAGS}" CACHE STRING "")

set(CMAKE_FIND_ROOT_PATH  ${TIZEN_SDK_DIR})

set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
