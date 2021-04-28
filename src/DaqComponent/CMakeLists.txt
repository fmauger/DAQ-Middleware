configure_file(version.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/version.h @ONLY)


set(DaqComponent_HEADERS
  ${CMAKE_CURRENT_BINARY_DIR}/version.h
  Condition.h
  DaqComponentBase.h
  DaqComponentException.h
  DaqLog.h
  FatalType.h
  json2conlist.h
  Timer.h
  )

file(COPY ${DaqComponent_HEADERS}
  DESTINATION "${CMAKE_INCLUDE_OUTPUT_DIRECTORY}/daqmw/"
  )

install(FILES ${DaqComponent_HEADERS}
  DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/daqmw/"
)

add_subdirectory(idl)

