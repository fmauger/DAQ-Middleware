if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(STATUS "DAQ-Middleware requires an out-of-source build.")
  message(STATUS "Please remove these files from ${CMAKE_BINARY_DIR} first:")
  message(STATUS "  CMakeCache.txt")
  message(STATUS "  CMakeFiles")
  message(STATUS "Once these files are removed, create a separate directory")
  message(STATUS "and run CMake from there, pointing it to:")
  message(STATUS "  ${CMAKE_SOURCE_DIR}")
  message(FATAL_ERROR "in-source build detected")
endif()

cmake_minimum_required(VERSION 3.12 FATAL_ERROR)
project(DAQMW_SampleLogger VERSION 1.4.5)
message(STATUS "[info] Project version = '${PROJECT_VERSION}'")

find_package(DAQMW 1.4.5)
find_package(Boost 1.35 COMPONENTS filesystem date_time)
message(STATUS "Boost_LIBRARIES=${Boost_LIBRARIES}")
message(STATUS "Boost_INCLUDE_DIR=${Boost_INCLUDE_DIR}")
find_program(BX_EXECUTABLE bc)

add_compile_options("-Wno-error=unused-parameter")

set(compName "SampleLogger")

set(compSources
  ${compName}.cpp
  ${compName}Comp.cpp
  FileUtils.cpp
  )

set(compFiles
  ${compName}.cpp
  ${compName}.h
  ${compName}Comp.cpp
  FileUtils.cpp
  FileUtils.h
  )

set(compTarget "${compName}Comp")

message(STATUS "compName=${compName}")
message(STATUS "compSources=${compSources}")
message(STATUS "compFiles=${compFiles}")
message(STATUS "compTarget=${compTarget}")
message(STATUS "OPENRTM_LIB_DIR=${OPENRTM_LIB_DIR}")
message(STATUS "OPENRTM_LIBRARY_DIRS=${OPENRTM_LIBRARY_DIRS}")
message(STATUS "OPENRTM_LIBRARIES=${OPENRTM_LIBRARIES}")

include_directories(${Boost_INCLUDE_DIR})
include_directories(${DAQMW_INCLUDE_DIRS})
include_directories(${OPENRTM_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

# - Invoke component target builder function
daqmw_build_component(
  "${compName}"
  "${compSources}"
  "${compFiles}"
  "${CMAKE_CURRENT_BINARY_DIR}")

target_link_libraries(${compTarget}
  ${Boost_LIBRARIES}
  # daqmw
  )

set_target_properties(${compTarget} PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${CMAKE_LIBEXEC_OUTPUT_DIRECTORY}/daqmw/examples
  )
set_target_properties(${compTarget} PROPERTIES SKIP_BUILD_RPATH FALSE)
set_target_properties(${compTarget} PROPERTIES BUILD_WITH_INSTALL_RPATH TRUE)
set_target_properties(${compTarget} PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)
if(UNIX AND NOT APPLE)
  set_target_properties(${compTarget}
    PROPERTIES INSTALL_RPATH "\$ORIGIN/../../../${CMAKE_INSTALL_LIBDIR}/daqmw:${OPENRTM_LIB_DIR}"
    )
endif()
  
install(TARGETS ${compTarget}
  DESTINATION "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBEXECDIR}/daqmw/examples"
  PERMISSIONS
  OWNER_READ OWNER_WRITE OWNER_EXECUTE
  GROUP_READ GROUP_EXECUTE
  WORLD_READ WORLD_EXECUTE
 )
  
  