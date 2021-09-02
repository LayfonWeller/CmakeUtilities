macro(make_executable_target TARGET_NAME DebuglinkerFileLocation ReleaselinkerFileLocation)

  if(NOT TARGET target_settings)
    generatetargetsettings()
  endif()

  add_executable(${TARGET_NAME})
  target_link_libraries(${TARGET_NAME} target_settings)

  # target_link_options(${TARGET_NAME} PRIVATE -Wl,-Map,${TARGET_NAME}.map -Wl,--print-memory-usage)
  target_link_options(${TARGET_NAME} PRIVATE -Wl,-Map,${TARGET_NAME}.map)

  firmware_size(${TARGET_NAME})

  generate_object(${TARGET_NAME} .bin binary)



  message(STATUS "BUILD with ${linkerFileLocation}")
  target_link_options(${TARGET_NAME} PRIVATE -T $<$<CONFIG:DEBUG>:${DebuglinkerFileLocation}> $<$<CONFIG:RELEASE>:${ReleaselinkerFileLocation}>)
  get_target_property(linkerOptions ${TARGET_NAME} LINK_OPTIONS)
  message(STATUS "BUILD with ${linkerOptions}")
  # linker_script_target_dependency(${TARGET_NAME} ${linkerFileLocation})
endmacro()

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/flash.csv.cmake
     "file(\${WRITE_MODE} ${CMAKE_CURRENT_BINARY_DIR}/flash.csv \"\${WHAT}\\n\")"
)

macro(flashtarget target location)
  message(STATUS "Add target to flash : ${target} @ ${location}")
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/flash.csv
    COMMAND ${CMAKE_COMMAND} -E echo "file,${CMAKE_CURRENT_BINARY_DIR}/${target}.bin,${location}"
    COMMAND ${CMAKE_COMMAND} -DWRITE_MODE=WRITE -DWHAT="file,${CMAKE_CURRENT_BINARY_DIR}/${target}.bin,${location}" -P
            ${CMAKE_CURRENT_BINARY_DIR}/flash.csv.cmake
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${target}.bin
    COMMENT [FLASH] CREATING CSV
  )
endmacro()

macro(flashfile file location)
  message(STATUS "Add file to flash : ${file} @ ${location}")
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/flash.csv
    COMMAND ${CMAKE_COMMAND} -E echo "file,${file},${location}"
    COMMAND ${CMAKE_COMMAND} -DWRITE_MODE=APPEND -DWHAT="file,${file},${location}" -P ${CMAKE_CURRENT_BINARY_DIR}/flash.csv.cmake
    DEPENDS ${file}
    APPEND
  )
endmacro()

macro(flashsleep time)
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/flash.csv
    COMMAND ${CMAKE_COMMAND} -E echo "cmd,sleep,${time}"
    COMMAND ${CMAKE_COMMAND} -DWRITE_MODE=APPEND -DWHAT="cmd,sleep,${time}" -P ${CMAKE_CURRENT_BINARY_DIR}/flash.csv.cmake
    APPEND
  )
endmacro()

macro(flashwrite size what where)
  if(${size} EQUAL 4)
    set(cmd "w4")
  elseif(${size} EQUAL 2)
    set(cmd "w2")
  elseif(${size} EQUAL 1)
    set(cmd "w1")
  else()
    message(FATAL_ERROR "Incorect size with size = ${size} needs to be {1,2,4}")
  endif()
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/flash.csv
    COMMAND ${CMAKE_COMMAND} -E echo "cmd,${cmd},${what},${where}"
    COMMAND ${CMAKE_COMMAND} -DWRITE_MODE=APPEND -DWHAT="cmd,${cmd},${what},${where}" -P
            ${CMAKE_CURRENT_BINARY_DIR}/flash.csv.cmake
    APPEND
  )
endmacro()
