
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../json_spirit)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${Boost_INCLUDE_DIRS})
add_compile_options("-Wno-error=unused-variable")

set(JsonSpiritTest_HEADERS
  utils_test.h
  json_spirit_reader_test.h
  json_spirit_value_test.h
  json_spirit_writer_test.h
  )

set(JsonSpiritTest_SOURCES
  json_spirit_reader_test.cpp
  json_spirit_value_test.cpp
  json_spirit_writer_test.cpp
  )

# add_library(JsonSpiritTest SHARED
#   ${JsonSpiritTest_SOURCES}
#   ${JsonSpiritTest_HEADERS}
#   ) 

# target_link_libraries(JsonSpiritTest
#   PUBLIC
#   JsonSpirit)

set(JsonSpiritTest_PROGS
  json_test
  )

foreach(_JsonSpiritTest_prog ${JsonSpiritTest_PROGS})
  
  add_executable(${_JsonSpiritTest_prog}
    ${_JsonSpiritTest_prog}.cpp
    ${JsonSpiritTest_HEADERS}
    ${JsonSpiritTest_SOURCES}
    )

  target_link_libraries(${_JsonSpiritTest_prog}
    PUBLIC
    JsonSpirit)
  
  set_property(TARGET ${_JsonSpiritTest_prog}
    PROPERTY RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/JsonSpiritTests"
    )

  set_target_properties(${_JsonSpiritTest_prog} PROPERTIES INSTALL_RPATH_USE_LINK_PATH 1)
  if(UNIX AND NOT APPLE)
    set_target_properties(${_JsonSpiritTest_prog}
      PROPERTIES INSTALL_RPATH "\$ORIGIN/../${CMAKE_INSTALL_LIBDIR}"
      )
  endif()

  add_test(NAME ${_JsonSpiritTest_prog} COMMAND ${_JsonSpiritTest_prog})

endforeach()
