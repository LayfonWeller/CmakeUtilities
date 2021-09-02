# Prepend ${CMAKE_CURRENT_SOURCE_DIR} to a ${directory} name and save it in PARENT_SCOPE ${variable}
macro(prepend_cur_dir variable directory)
  set(${variable} ${CMAKE_CURRENT_SOURCE_DIR}/${directory})
endmacro()

# Add custom command to print firmware size in Berkley format
function(firmware_size target)
  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND ${CMAKE_SIZE_UTIL} -B "${CMAKE_CURRENT_BINARY_DIR}/${target}${CMAKE_EXECUTABLE_SUFFIX}"
    COMMENT "Size of ${target}"
  )
endfunction()

# Add a command to generate firmare in a provided format
function(generate_object target suffix type)
  add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${target}${suffix}"
    DEPENDS ${target}
    COMMAND ${CMAKE_OBJCOPY} -O ${type} "${CMAKE_CURRENT_BINARY_DIR}/${target}${CMAKE_EXECUTABLE_SUFFIX}"
            "${CMAKE_CURRENT_BINARY_DIR}/${target}${suffix}"
    COMMENT "Generating ${target}${suffix}"
  )
  add_custom_target(${target}_${type} ALL
  DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${target}${suffix}"
  )
endfunction()

# Add custom linker script to the linker flags
function(linker_script_add path_to_script)
  string(APPEND CMAKE_EXE_LINKER_FLAGS " -T ${path_to_script}")
endfunction()

# Update a target LINK_DEPENDS property with a custom linker script. That allows to rebuild that target if the linker
# script gets changed
function(linker_script_target_dependency target path_to_script)
  string(STRIP "${path_to_script}" path_to_script)
  get_target_property(_cur_link_deps ${target} LINK_DEPENDS)
  if (_cur_link_deps)
  string(APPEND _cur_link_deps " ${path_to_script}")
  else ()
  set(_cur_link_deps "${path_to_script}")
  endif()
  set_target_properties(${target} PROPERTIES LINK_DEPENDS ${_cur_link_deps})
endfunction()


# function(gen_linkScript)
# # add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Project_Settings/Linker_Files/ProcessorExpert_Release.ld
# #                    MAIN_DEPENDENCY ${CMAKE_CURRENT_BINARY_DIR}/Project_Settings/Linker_Files/ProcessorExpert_Release.ld.s
# #                    COMMAND ${CMAKE_C_COMPILER}
# #                    -E ${CMAKE_CURRENT_BINARY_DIR}/Project_Settings/Linker_Files/ProcessorExpert_Release.ld.s -P
# #                    -o ${CMAKE_CURRENT_BINARY_DIR}/Project_Settings/Linker_Files/ProcessorExpert_Release.ld
# #                    -I ${CMAKE_CURRENT_SOURCE_DIR}/Project_Settings/Linker_Files/
# #                    VERBATIM
# #                    COMMENT "[PREPROCESSING LDSCRIPT]")

# # configure_file("${CMAKE_CURRENT_SOURCE_DIR}/Project_Settings/Linker_Files/ProcessorExpert_Release.ld.s.in" "${CMAKE_CURRENT_BINARY_DIR}/Project_Settings/Linker_Files/ProcessorExpert_Release.ld")
# # linker_script_target_dependency(${PROJECT_NAME} "${CMAKE_CURRENT_BINARY_DIR}/Project_Settings/Linker_Files/ProcessorExpert_Release.ld")

# # add_custom_target(linkerscript
# #                   DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/Project_Settings/Linker_Files/ProcessorExpert_Release.ld"
# #                   VERBATIM)

# # add_dependencies(${PROJECT_NAME} linkerscript)
# endfunction()