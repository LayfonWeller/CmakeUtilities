include(${CMAKE_CURRENT_LIST_DIR}/3rdParty/JSONParser.cmake)

function(Get_Version_Info FROM JSON_PATH VER)
file(READ "${FROM}" jsonFile)

sbeParseJson(config jsonFile)


set(ver ${config.${JSON_PATH}})

string(REGEX MATCH "([0-9]*).([0-9]*).([0-9]*)" _ "${ver}")
set(${VER}.major ${CMAKE_MATCH_1} PARENT_SCOPE)
set(${VER}.minor ${CMAKE_MATCH_2} PARENT_SCOPE)
set(${VER}.patch ${CMAKE_MATCH_3} PARENT_SCOPE)

sbeClearJson(config)

endfunction(Get_Version_Info)