set(Sock_TESTS
  socktest
  socktestexception
  )
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/..)

foreach(_Sock_test ${Sock_TESTS})
  
  add_executable(${_Sock_test}
    ${_Sock_test}.cpp)

  target_link_libraries(${_Sock_test}
    PUBLIC
    Sock)

  set_property(TARGET ${_Sock_test}
    PROPERTY RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/SockTests"
    )

  add_test(NAME ${_Sock_test} COMMAND ${_Sock_test})

  # target_include_directories(${_sitcpbcp_prog}
  #   PRIVATE
  #    ${CMAKE_CURRENT_BINARY_DIR}    
  #   )

  set_target_properties(${_Sock_test} PROPERTIES BUILD_WITH_INSTALL_RPATH FALSE)
  set_target_properties(${_Sock_test} PROPERTIES INSTALL_RPATH_USE_LINK_PATH 1)
  # if(UNIX AND NOT APPLE)
  #   set_target_properties(${_Sock_test}
  #     PROPERTIES INSTALL_RPATH "\$ORIGIN/../${CMAKE_INSTALL_LIBDIR}"
  #     )
  # endif()
endforeach()
