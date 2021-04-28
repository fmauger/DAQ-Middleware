
set(JsonSpirit_HEADERS
  json_spirit.h
  json_spirit_reader.h
  json_spirit_value.h
  json_spirit_writer.h
  )

set(JsonSpirit_SOURCES
  json_spirit_reader.cpp
  json_spirit_value.cpp
  json_spirit_writer.cpp
  )

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${Boost_INCLUDE_DIRS})

file(COPY ${JsonSpirit_HEADERS}
  DESTINATION "${CMAKE_INCLUDE_OUTPUT_DIRECTORY}/daqmw/"
  )  

add_compile_options("-Wno-error=unused-parameter")
add_library(JsonSpirit SHARED ${JsonSpirit_SOURCES} ${JsonSpirit_HEADERS})

# target_link_libraries(JsonSpirit
#   )

set_target_properties(JsonSpirit PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/daqmw
  )

# set_target_properties(JsonSpirit PROPERTIES SKIP_BUILD_RPATH FALSE)
# set_target_properties(JsonSpirit PROPERTIES BUILD_WITH_INSTALL_RPATH TRUE)
# set_target_properties(JsonSpirit PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)
# if(UNIX AND NOT APPLE)
#   set_target_properties(JsonSpirit
#     PROPERTIES INSTALL_RPATH "\$ORIGIN/../${CMAKE_INSTALL_LIBDIR}/daqmw"
#     )
# endif()

install(TARGETS JsonSpirit
  EXPORT  DAQMWTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/daqmw
  PERMISSIONS
  OWNER_READ OWNER_WRITE OWNER_EXECUTE
  GROUP_READ GROUP_EXECUTE
  WORLD_READ WORLD_EXECUTE
  )

install(FILES ${JsonSpirit_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/daqmw
  )