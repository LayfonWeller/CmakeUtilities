find_package(Doxygen OPTIONAL_COMPONENTS dot)
option(BUILD_DOCUMENTATION
       "Create and install the HTML based API documentation (requires Doxygen)"
       ${DOXYGEN_FOUND})

if(BUILD_DOCUMENTATION)

  # doxygen_from_file(doc
  # ${CMAKE_CURRENT_SOURCE_DIR}/Documentation/doxygen/pex.doxyfile
  # WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/Documentation/doxygen )

  if(NOT TARGET docs)
    add_custom_target(docs)
  endif()

  function(target_gen_doxygen_doc TARGET_NAME)

    if(NOT DOXYGEN_FOUND)
      message(ERROR "Doxygen is needed to build the documentation.")
    else()

      set(DOC_TARGET_NAME "docs-${PROJECT_NAME}-${TARGET_NAME}")

      set(DOXYGEN_CALLER_GRAPH TRUE)
      set(DOXYGEN_CALL_GRAPH TRUE)

      set(DOXYGEN_DOT_IMAGE_FORMAT "svg")
      set(DOXYGEN_INTERACTIVE_SVG TRUE)

      set(DOXYGEN_EXTRACT_ALL FALSE)
      set(DOXYGEN_EXTRACT_PRIVATE FALSE)
      set(DOXYGEN_EXTRACT_STATIC FALSE)
      set(DOXYGEN_EXTRACT_ANON_NSPACES FALSE)
      set(DOXYGEN_INTERNAL_DOCS TRUE)
      set(DOXYGEN_OPTIMIZE_OUTPUT_FOR_C TRUE)
      set(DOXYGEN_OUTPUT_DIRECTORY
          "${CMAKE_CURRENT_BINARY_DIR}/docs/${PROJECT_NAME}/${TARGET_NAME}")
      set(DOXYGEN_OUTPUT_XML TRUE)
      # GENERATE_TESTLIST GENERATE_BUGLIST GENERATE_DEPRECATEDLIST

      #get_target_property(TARGET_SOURCES ${TARGET_NAME} INTERFACE_SOURCES)
      get_target_property(TARGET_SOURCES ${TARGET_NAME} SOURCES)

      # set(DOXYGEN_HTML_STYLESHEET ${CMAKE_CURRENT_SOURCE_DIR}/Documentation/doxygen/pex.css)
      doxygen_add_docs(${DOC_TARGET_NAME} ${TARGET_SOURCES})
      install(
        DIRECTORY ${DOXYGEN_OUTPUT_DIRECTORY}/html
        DESTINATION share/doc
        COMPONENT Documentation)

      add_test(NAME ${DOC_TARGET_NAME} COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${DOC_TARGET_NAME} 2>&1)
      set_tests_properties(${DOC_TARGET_NAME} PROPERTIES
        FAIL_REGULAR_EXPRESSION "warning"
      )


      add_dependencies(docs ${DOC_TARGET_NAME})
    endif()

  endfunction()
else()
function(target_gen_doxygen_doc TARGET_NAME)
endfunction()
endif()
