
set(sitcpbcp_PROGS
  readReg
  writeReg
  )

foreach(_sitcpbcp_prog ${sitcpbcp_PROGS})
  
  add_executable(${_sitcpbcp_prog}
    ${_sitcpbcp_prog}.c)

  target_link_libraries(${_sitcpbcp_prog}
    PUBLIC
    sitcpbcp
    sock)

  # target_include_directories(${_sitcpbcp_prog}
  #   PRIVATE
  #    ${CMAKE_CURRENT_BINARY_DIR}    
  #   )

  set_target_properties(${_sitcpbcp_prog} PROPERTIES INSTALL_RPATH_USE_LINK_PATH 1)
  if(UNIX AND NOT APPLE)
    set_target_properties(${_sitcpbcp_prog}
      PROPERTIES INSTALL_RPATH "\$ORIGIN/../${CMAKE_INSTALL_LIBDIR}"
      )
  endif()
endforeach()


