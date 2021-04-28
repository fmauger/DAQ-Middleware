set(sitcpbcp_HEADERS
  sitcpbcp.h)

set(sitcpbcp_SOURCES
  sitcpbcp.c)

file(COPY ${sitcpbcp_HEADERS}
  DESTINATION "${CMAKE_INCLUDE_OUTPUT_DIRECTORY}/daqmw/"
  )  

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/../sock
  )

add_library(sitcpbcp SHARED ${sitcpbcp_SOURCES} ${sitcpbcp_HEADERS})

set_target_properties(sitcpbcp PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/daqmw
  )

target_link_libraries(sitcpbcp
  PUBLIC sock
  )

set_target_properties(sitcpbcp PROPERTIES SKIP_BUILD_RPATH FALSE)
set_target_properties(sitcpbcp PROPERTIES BUILD_WITH_INSTALL_RPATH TRUE)
set_target_properties(sitcpbcp PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)
if(UNIX AND NOT APPLE)
  set_target_properties(sitcpbcp
    PROPERTIES INSTALL_RPATH "\$ORIGIN/../../${CMAKE_INSTALL_LIBDIR}/daqmw"
    )
endif()

install(TARGETS sitcpbcp
  EXPORT  DAQMWTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/daqmw
  PERMISSIONS
  OWNER_READ OWNER_WRITE OWNER_EXECUTE
  GROUP_READ GROUP_EXECUTE
  WORLD_READ WORLD_EXECUTE
  )

install(FILES ${sitcpbcp_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/daqmw
  )

add_subdirectory(programs)

