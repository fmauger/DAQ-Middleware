set(DaqOperator_SOURCES
  DaqOperator.cpp
  DaqOperatorComp.cpp
  ConfFileParser.cpp
  CreateDom.cpp
  )

set(DaqOperator_FILES
  ComponentInfoContainer.h
  ConfFileParser.cpp
  ConfFileParser.h
  CreateDom.cpp
  CreateDom.h
  DaqOperator.cpp
  DaqOperator.h
  DaqOperatorComp.cpp
  Parameter.h
  ParameterServer.h
  callback.h
  )

file(COPY ${DaqOperator_FILES}
  DESTINATION "${CMAKE_DATAROOT_OUTPUT_DIRECTORY}/daqmw/DaqOperator"
  )

message(STATUS "OPENRTM_INCLUDE_DIRS=${OPENRTM_INCLUDE_DIRS}")
message(STATUS "OPENRTM_LIB_DIR=${OPENRTM_LIB_DIR}")
message(STATUS "OPENRTM_LIBRARY_DIRS=${OPENRTM_LIBRARY_DIRS}")
message(STATUS "OPENRTM_LIBRARIES=${OPENRTM_LIBRARIES}")
message(STATUS "OPENRTM_LDFLAGS=${OPENRTM_LDFLAGS}")

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../daqmw)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../DaqComponent)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../DaqComponent/idl)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../lib/SiTCP/CPP/Sock)
include_directories(${OPENRTM_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${XercesC_INCLUDE_DIR})

add_custom_command(
  OUTPUT
  ${CMAKE_CURRENT_BINARY_DIR}/DAQServiceDynSK.cc
  ${CMAKE_CURRENT_BINARY_DIR}/DAQService.hh
  ${CMAKE_CURRENT_BINARY_DIR}/DAQServiceSK.cc
  ${CMAKE_CURRENT_BINARY_DIR}/DAQServiceSkel.h
  ${CMAKE_CURRENT_BINARY_DIR}/DAQServiceSkel.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/DAQServiceStub.h
  ${CMAKE_CURRENT_BINARY_DIR}/DAQServiceStub.cpp
  COMMAND
    test -L DAQService.idl || ln -s ${CMAKE_CURRENT_SOURCE_DIR}/../DaqComponent/idl/DAQService.idl DAQService.idl
  COMMAND
    ${OPENRTM_IDLC}
    ${OPENRTM_IDLFLAGS} 
    DAQService.idl
  COMMAND
  ${OPENRTM_IDL_WRAPPER}
  ${OPENRTM_IDL_WRAPPER_FLAGS}
    --idl-file=DAQService.idl
  COMMAND
    ${OPENRTM_IDLC}
    ${OPENRTM_IDLFLAGS} 
    DAQService.idl
  COMMAND
  ${OPENRTM_IDL_WRAPPER}
  ${OPENRTM_IDL_WRAPPER_FLAGS}
    --idl-file=DAQService.idl
  COMMAND
    test -L DAQService.idl && rm -f DAQService.idl
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  VERBATIM
  )

# Workaround:
# CorbaConsumer.h:363:5: error: base class ‘class RTC::CorbaConsumerBase’ should be
# explicitly initialized in the copy constructor [-Werror=extra]
add_compile_options("-Wno-error=extra" ${OPENRTM_CFLAGS}) 

add_library(DaqOperatorStatic OBJECT
  ${CMAKE_CURRENT_BINARY_DIR}/DAQServiceStub.h
  DaqOperator.h
  DaqOperator.cpp
  ${DaqOperator_FILES}
  )

add_executable(DaqOperatorComp
  ${CMAKE_CURRENT_BINARY_DIR}/DAQServiceSkel.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/../DaqComponent/idl/DAQServiceSVC_impl.cpp
  ${DaqOperator_SOURCES}
  ${DaqOperatorStatic}
  )

set_target_properties(DaqOperatorComp PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${CMAKE_LIBEXEC_OUTPUT_DIRECTORY}/daqmw
  )

set_target_properties(DaqOperatorComp PROPERTIES SKIP_BUILD_RPATH FALSE)
set_target_properties(DaqOperatorComp PROPERTIES BUILD_WITH_INSTALL_RPATH TRUE)
set_target_properties(DaqOperatorComp PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)
if(UNIX AND NOT APPLE)
  set_target_properties(DaqOperatorComp
    PROPERTIES INSTALL_RPATH "\$ORIGIN/../../${CMAKE_INSTALL_LIBDIR}/daqmw:${OPENRTM_LIB_DIR}"
    )
endif()

target_link_libraries(DaqOperatorComp
  Sock
  # daqmw
  -L${OPENRTM_LIB_DIR}
  # pthread;RTC;omniDynamic4;omniORB4;omnithread;
  ${OPENRTM_LIBRARIES}
  ${OPENRTM_LDFLAGS}
  ${XercesC_LIBRARIES}
  )

install(TARGETS DaqOperatorComp
  DESTINATION "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBEXECDIR}/daqmw/"
  PERMISSIONS
  OWNER_READ OWNER_WRITE OWNER_EXECUTE
  GROUP_READ GROUP_EXECUTE
  WORLD_READ WORLD_EXECUTE
)

install(FILES ${DaqOperator_FILES}
  DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/daqmw/DaqOperator"
  )
