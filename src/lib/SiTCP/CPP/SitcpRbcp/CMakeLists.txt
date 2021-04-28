set(SitcpRbcp_HEADERS
  SitcpRbcp.h)

set(SitcpRbcp_SOURCES
  SitcpRbcp.cpp)

file(COPY ${SitcpRbcp_HEADERS}
  DESTINATION "${CMAKE_INCLUDE_OUTPUT_DIRECTORY}/daqmw/"
  )  

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/../Sock
  )

add_library(SitcpRbcp SHARED ${SitcpRbcp_SOURCES} ${SitcpRbcp_HEADERS})

set_target_properties(SitcpRbcp PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/daqmw
  )

target_link_libraries(SitcpRbcp
  PUBLIC
  Sock)

set_target_properties(SitcpRbcp PROPERTIES SKIP_BUILD_RPATH FALSE)
set_target_properties(SitcpRbcp PROPERTIES BUILD_WITH_INSTALL_RPATH TRUE)
set_target_properties(SitcpRbcp PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)
if(UNIX AND NOT APPLE)
  set_target_properties(SitcpRbcp
    PROPERTIES INSTALL_RPATH "\$ORIGIN/../../${CMAKE_INSTALL_LIBDIR}/daqmw"
    )
endif()

install(TARGETS SitcpRbcp
  EXPORT  DAQMWTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/daqmw
  PERMISSIONS
  OWNER_READ OWNER_WRITE OWNER_EXECUTE
  GROUP_READ GROUP_EXECUTE
  WORLD_READ WORLD_EXECUTE
  )

install(FILES ${SitcpRbcp_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/daqmw
  )

if(DAQMW_ENABLE_TESTING)
  set(SitcpRbcp_TESTS
    sample
    )

  foreach(_SitcpRbcp_test ${SitcpRbcp_TESTS})
    
    add_executable(${_SitcpRbcp_test}
      ${_SitcpRbcp_test}.cpp)

    target_link_libraries(${_SitcpRbcp_test}
      PUBLIC
      SitcpRbcp)

    set_property(TARGET ${_SitcpRbcp_test}
      PROPERTY RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/SitcpRbcpTests"
      )

    add_test(NAME ${_SitcpRbcp_test} COMMAND ${_SitcpRbcp_test})

    set_target_properties(${_SitcpRbcp_test} PROPERTIES BUILD_WITH_INSTALL_RPATH FALSE)
    set_target_properties(${_SitcpRbcp_test} PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)
    # if(UNIX AND NOT APPLE)
    #   set_target_properties(${_SitcpRbcp_test}
    # 	PROPERTIES INSTALL_RPATH "\$ORIGIN/../${CMAKE_INSTALL_LIBDIR}"
    # 	)
    # endif()
  endforeach()

endif(DAQMW_ENABLE_TESTING)
