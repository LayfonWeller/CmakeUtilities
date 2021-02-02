if (GIT_INFO_INCLUDED)
return()
endif()
set(GIT_INFO_INCLUDED true)

find_package(Git QUIET)

set(GIT_IS_TAG false)
set(GIT_NAME false)
set(GIT_HAS_COMMIT_ID false)
set(GIT_IS_DIRTY true)

if(Git_FOUND)
  execute_process(
    COMMAND ${GIT_EXECUTABLE} describe --tags --exact-match
    RESULT_VARIABLE GitGotTagName
    OUTPUT_VARIABLE GitTagName
    ERROR_QUIET
  )
  if(NOT GitGotTagName) # Program return 0 on sucess
    set(GIT_IS_TAG true)
    string(STRIP "${GitTagName}" GIT_NAME)
  else()
    execute_process(
      COMMAND ${GIT_EXECUTABLE} symbolic-ref -q --short HEAD
      RESULT_VARIABLE GitGotBranchName
      OUTPUT_VARIABLE GitBranchName ERROR_QUIET
    )
    if(NOT GitGotBranchName) # Program return 0 on sucess
      string(STRIP "${GitBranchName}" GIT_NAME)
    else()
      message(
        WARNING
          "Could not get either a tag name nor a branch name\n\tGitGotTagName=${GitGotTagName},\n\t GitTagName=${GitTagName},\n\t GitGotBranchName=${GitGotBranchName},\n\t GitBranchName=${GitBranchName}"
      )
    endif()
  endif()

  execute_process(
    COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
    RESULT_VARIABLE GitGotCommitId
    OUTPUT_VARIABLE GitCommitID ERROR_QUIET
  )
  if(NOT GitGotCommitId) # Program return 0 on sucess
    set(GIT_HAS_COMMIT_ID true)
    string(STRIP "${GitCommitID}" GIT_COMMIT_ID)
  endif()

  execute_process(COMMAND ${GIT_EXECUTABLE} diff --quiet RESULT_VARIABLE GitGotIsDirty OUTPUT_QUIET ERROR_QUIET)

  if(NOT GitGotIsDirty) # Program return 0 on sucess
    set(GIT_IS_DIRTY false)
  endif()

#   message(STATUS "Is Tag = ${GIT_IS_TAG}; name is : ${GIT_NAME}, Commit is : ${GIT_COMMIT_ID}")

else()
  message(WARNING "Git Not Found, can't identify the package")
endif()