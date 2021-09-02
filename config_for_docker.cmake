# WIP check if we are in a Docker container and return it to var
# To be used by other modules
function(InDocker ret) {
    execute_process(
        COMMAND sh -c "cat /proc/1/cgroup | grep -q docker"
        RESULT_VARIABLE inDocker
    )
    if(ret NOT EQUAL "0")
    set(${ret} FALSE)
    else ()
    set(${ret} TRUE)
    endif()
endfunction()
