set(DaqComponentIdl_HEADERS
  DAQService.idl
  DAQServiceSVC_impl.h
  )

set(DaqComponentIdl_SOURCES
  DAQServiceSVC_impl.cpp
  )

file(COPY ${DaqComponentIdl_HEADERS} ${DaqComponentIdl_SOURCES}
  DESTINATION "${CMAKE_INCLUDE_OUTPUT_DIRECTORY}/daqmw/idl"
  )
