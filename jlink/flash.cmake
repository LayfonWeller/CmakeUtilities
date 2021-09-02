# Read the entire CSV file.
file(READ ${INPUT_FILE} CSV_CONTENTS)

# Split the CSV by new-lines.
string(REPLACE "\n" ";" CSV_LIST ${CSV_CONTENTS})

file(
  WRITE ${OUTPUT_FILE}
  "
h
r
unlock kinetis
device ${DEVICE}
erase
speed 12000
"
)

# Loop through each line in the CSV file.
foreach(CSV_ROW ${CSV_LIST})
  # Get a list of the elements in this CSV row.
  string(REPLACE "," ";" CSV_ROW_CONTENTS ${CSV_ROW})

  # Get variables to each element.
  list(GET CSV_ROW_CONTENTS 0 ELEM0)
  list(GET CSV_ROW_CONTENTS 1 ELEM1)
  list(GET CSV_ROW_CONTENTS 2 ELEM2)

  if(ELEM0 STREQUAL "file")
    file(APPEND ${OUTPUT_FILE} "loadbin ${ELEM1} ${ELEM2}\n")
  elseif(ELEM0 STREQUAL "cmd")
    if(ELEM1 STREQUAL "sleep")
      file(
        APPEND ${OUTPUT_FILE}
        "
r
g
sleep ${ELEM2}
"
      )
    else()
      list(GET CSV_ROW_CONTENTS 3 ELEM3)
      file(
        APPEND ${OUTPUT_FILE}
        "
${ELEM1} ${ELEM3}, ${ELEM2}
"
      )
    endif()
  endif()
endforeach()

file(
  APPEND ${OUTPUT_FILE}
  "
r
g
qc
"
)
