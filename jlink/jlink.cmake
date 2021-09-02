# JLink functions Adds targets for JLink programmers and emulators Copyright (c) 2016 Ryan Kurte This file is covered
# under the MIT license available at: https://opensource.org/licenses/MIT

# # Configure flasher script for the project
# set(BINARY ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.bin)
# configure_file(${CMAKE_CURRENT_LIST_DIR}/flash.in ${CMAKE_CURRENT_BINARY_DIR}/flash.jlink)


add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/flash.jlink
  COMMAND ${CMAKE_COMMAND} -DDEVICE=${DEVICE} -DINPUT_FILE=${CMAKE_CURRENT_BINARY_DIR}/flash.csv -DOUTPUT_FILE=${CMAKE_CURRENT_BINARY_DIR}/flash.jlink -P ${CMAKE_CURRENT_LIST_DIR}/flash.cmake
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/flash.csv
)

list(APPEND JLinkPossibleLocation "C:/Program Files (x86)/SEGGER/JLink")

find_program(JLinkExe JLink NAMES JLinkExe PATHS ${JLinkPossibleLocation})
find_program(JLinkGdbServer JLinkGDBServer PATHS ${JLinkPossibleLocation})

if(DEFINED ENV{JLINK_SERVER_IP})
  set(JLINK_IP_CONFIG -IP $ENV{JLINK_SERVER_IP})
  set(JLINK_IP_CONFIG_DEBUG -select ip=$ENV{JLINK_SERVER_IP})
else()
  set(JLINK_IP_CONFIG "")
  set(JLINK_IP_CONFIG_DEBUG "")
endif()

# Add JLink commands
add_custom_target(
  debug
  COMMAND ${CMAKE_GDB} -tui -command ${CMAKE_CURRENT_LIST_DIR}/remote.gdbconf ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
  DEPENDS ${PROJECT_NAME}
  COMMENT [DEBUG]
  Running debugger script
)

add_custom_target(
  d
  COMMAND ${CMAKE_GDB} -command ${CMAKE_CURRENT_LIST_DIR}/remote.gdbconf ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
  DEPENDS ${PROJECT_NAME}
  USES_TERMINAL
  COMMENT [DEBUG]
  Running debugger script
)

add_custom_target(
  debug-server
  COMMAND ${JLinkGdbServer} -device ${DEVICE} -speed 4000 -if SWD ${JLINK_IP_CONFIG_DEBUG}
  DEPENDS ${PROJECT_NAME} flash
  COMMENT [DEBUG]
  Running the debug server
)

add_custom_target(
  ds
  COMMAND ${JLinkGdbServer} -device ${DEVICE} -speed 4000 -if SWD ${JLINK_IP_CONFIG_DEBUG}
  DEPENDS ${PROJECT_NAME}
  COMMENT [DEBUG]
  Running the debug server
)

add_custom_target(
  flash
  COMMAND ${JLinkExe} -device ${DEVICE} -speed 10000 -if SWD -CommanderScript ${CMAKE_CURRENT_BINARY_DIR}/flash.jlink ${JLINK_IP_CONFIG}
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/flash.jlink
  USES_TERMINAL
  COMMENT [FLASH]
  Flashing ${PROJECT_NAME} to ${DEVICE}
)

add_custom_target(
  erase
  USES_TERMINAL
  COMMAND ${JLinkExe} -device ${DEVICE} -speed 4000 -if SWD -CommanderScript ${CMAKE_CURRENT_LIST_DIR}/erase.jlink ${JLINK_IP_CONFIG}
  COMMENT [ERASE]
  Erasing ${PROJECT_NAME}
)


add_custom_target(
  reset
  USES_TERMINAL
  COMMAND ${JLinkExe} -device ${DEVICE} -speed 4000 -if SWD -CommanderScript ${CMAKE_CURRENT_LIST_DIR}/reset.jlink ${JLINK_IP_CONFIG}
  COMMENT [RESET]
  Resetting ${PROJECT_NAME}
)

