configure_file(daqmw_config.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/daqmw_config.h @ONLY)

configure_file(daqmw_version.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/daqmw_version.h @ONLY)

set(DaqMiddleware_HEADERS
  ${CMAKE_CURRENT_BINARY_DIR}/daqmw_config.h
  ${CMAKE_CURRENT_BINARY_DIR}/daqmw_version.h
  daqmw_lib.h
  )

set(DaqMiddleware_SOURCES
  daqmw_lib.cpp
  daqmw_version.cpp
  )

file(COPY ${DaqComponent_HEADERS}
  DESTINATION "${CMAKE_INCLUDE_OUTPUT_DIRECTORY}/daqmw/"
  )

install(FILES ${DaqComponent_HEADERS}
  DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/daqmw/"
  )

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}
  ${OPENRTM_INCLUDE_DIRS}
  )

add_library(daqmw SHARED ${DaqMiddleware_SOURCES} ${DaqComponent_HEADERS})

set_target_properties(daqmw PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/daqmw
  )
message(STATUS "OPENRTM_LIB_DIR      =${OPENRTM_LIB_DIR}")
message(STATUS "OPENRTM_LIBRARY_DIRS =${OPENRTM_LIBRARY_DIRS}")
message(STATUS "OPENRTM_LIBRARIES    =${OPENRTM_LIBRARIES}")
target_link_libraries(daqmw
  PUBLIC
  -L${OPENRTM_LIB_DIR}
  pthread;omniDynamic4;omniORB4;omnithread;
  #${OPENRTM_LIBRARIES}
  )
set_target_properties(daqmw PROPERTIES SKIP_BUILD_RPATH FALSE)
set_target_properties(daqmw PROPERTIES BUILD_WITH_INSTALL_RPATH TRUE)
set_target_properties(daqmw PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)
if(UNIX AND NOT APPLE)
  set_target_properties(daqmw
    PROPERTIES INSTALL_RPATH "\$ORIGIN/../${CMAKE_INSTALL_LIBDIR}/daqmw:${OPENRTM_LIB_DIR}"
    )
endif()

install(TARGETS daqmw
  EXPORT  DAQMWTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/daqmw
  PERMISSIONS
  OWNER_READ OWNER_WRITE OWNER_EXECUTE
  GROUP_READ GROUP_EXECUTE
  WORLD_READ WORLD_EXECUTE
  )

install(FILES ${DaqComponent_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/daqmw
  )

if(DAQMW_ENABLE_TESTING)

  set(daqmw_TESTS
    daqmwtest
    )

  foreach(_daqmw_test ${daqmw_TESTS})
    
    add_executable(${_daqmw_test}
      test/${_daqmw_test}.cpp)

    target_link_libraries(${_daqmw_test}
      PUBLIC
      daqmw)

    set_property(TARGET ${_daqmw_test}
      PROPERTY RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/daqmwTests"
      )

    add_test(NAME ${_daqmw_test} COMMAND ${_daqmw_test})

    set_target_properties(${_daqmw_test} PROPERTIES INSTALL_RPATH_USE_LINK_PATH 1)
    if(UNIX AND NOT APPLE)
      set_target_properties(${_daqmw_test}
	PROPERTIES INSTALL_RPATH "\$ORIGIN/../${CMAKE_INSTALL_LIBDIR}"
	)
    endif()
  endforeach()
endif(DAQMW_ENABLE_TESTING)