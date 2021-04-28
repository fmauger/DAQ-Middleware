# - Top level CMake script for daqmw

#-----------------------------------------------------------------------
# Enforce an out-of-source build.
#
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

#-----------------------------------------------------------------------
# CMake/project requirements and configuration
#
cmake_minimum_required(VERSION 3.12 FATAL_ERROR)
project(DAQMW VERSION 1.4.5)
message(STATUS "[info] Project version = '${PROJECT_VERSION}'")

# - Load Custom Modules
list(INSERT CMAKE_MODULE_PATH 0 ${PROJECT_SOURCE_DIR}/cmake)

set(_daqmw_CMAKE_MODULE_PATH $ENV{CMAKE_MODULE_PATH})
if (_daqmw_CMAKE_MODULE_PATH)
  list(INSERT CMAKE_MODULE_PATH 0 ${_daqmw_CMAKE_MODULE_PATH})
endif()

include(DAQMWCMakeSettings)
include(CMakeDependentOption)

include(WriteCompilerDetectionHeader)
write_compiler_detection_header(
  FILE "${DAQMW_BUILD_INCLUDEDIR}/daqmw/compiler_detection.h"
  PREFIX "DAQMW"
  EPILOG "#include \"daqmw/compiler_macros.h\""
  COMPILERS GNU Clang AppleClang MSVC
  FEATURES cxx_thread_local cxx_attribute_deprecated
  )

option(DAQMW_ENABLE_TESTING "Build unit testing system for DAQ-Middleware" OFF)
option(DAQMW_BUILD_EXAMPLES "Build DAQ-Middleware Component examples projects at build step" OFF)
option(DAQMW_WITH_ROOT "Build DAQ-Middleware with ROOT" ON)

# - If testing required, *must* call enable_testing here!!
if(DAQMW_ENABLE_TESTING)
  message(STATUS "DAQ-Middleware will be built with tests")
  enable_testing()
endif()

if(DAQMW_BUILD_EXAMPLES)
  message(STATUS "DAQ-Middleware will build examples projects")
  enable_testing()
endif()

# - Dependencies
include(DAQMWDependencies)

add_subdirectory(src)
add_subdirectory(bin)
add_subdirectory(conf)
add_subdirectory(docs)
add_subdirectory(etc/remote-boot)

#-----------------------------------------------------------------------
# Install targets and resources
#
# install(TARGETS Sock sock sitcpbcp # JsonSpirit #SitcpRbcp
#   EXPORT  DAQMWTargets
#   ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/daqmw
#   LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/daqmw
#   PERMISSIONS
#   OWNER_READ OWNER_WRITE OWNER_EXECUTE
#   GROUP_READ GROUP_EXECUTE
#   WORLD_READ WORLD_EXECUTE
#   RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#   )

# install(DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
#   DESTINATION ${CMAKE_INSTALL_BINDIR}
#   FILE_PERMISSIONS
#   OWNER_READ OWNER_WRITE OWNER_EXECUTE
#   GROUP_READ GROUP_EXECUTE
#   WORLD_READ WORLD_EXECUTE  
#   )

# install(DIRECTORY ${DAQMW_BUILD_DATAROOTDIR}/daqmw
#   DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}
#   )

#-----------------------------------------------------------------------
# Configure/Install support files
# Done here so that external package variables are visible
#
include(CMakePackageConfigHelpers)

# - Versioning file is the same for the build and install trees
write_basic_package_version_file(
  ${DAQMW_BUILD_CMAKEDIR}/${DAQMW_TAG}/DAQMWConfigVersion.cmake
  VERSION ${DAWMW_VERSION}
  COMPATIBILITY SameMajorVersion
  )

# - Config file is also the same in build/install trees as we use same layout
configure_package_config_file(
  ${PROJECT_SOURCE_DIR}/cmake/DAQMWConfig.cmake.in
  ${DAQMW_BUILD_CMAKEDIR}/${DAQMW_TAG}/DAQMWConfig.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_CMAKEDIR}/${DAQMW_TAG}
  PATH_VARS
    CMAKE_INSTALL_BINDIR
    CMAKE_INSTALL_LIBDIR
    CMAKE_INSTALL_LIBEXECDIR
    CMAKE_INSTALL_INCLUDEDIR
    CMAKE_INSTALL_DATAROOTDIR
    )

# - Targets (build tree)
export(EXPORT DAQMWTargets
  NAMESPACE DAQMW::
  FILE ${DAQMW_BUILD_CMAKEDIR}/${DAQMW_TAG}/DAQMWTargets.cmake
  )

# - Targets (install tree)
install(EXPORT DAQMWTargets
  NAMESPACE DAQMW::
  DESTINATION ${CMAKE_INSTALL_CMAKEDIR}/${DAQMW_TAG}
  )

# - Installation of, well, install tree files
install(
  FILES
  ${DAQMW_BUILD_CMAKEDIR}/${DAQMW_TAG}/DAQMWConfigVersion.cmake
  ${DAQMW_BUILD_CMAKEDIR}/${DAQMW_TAG}/DAQMWConfig.cmake
  ${DAQMW_BUILD_CMAKEDIR}/${DAQMW_TAG}/DAQMWBuildComponent.cmake
  ${DAQMW_BUILD_CMAKEDIR}/${DAQMW_TAG}/DAQMWTargets.cmake
  DESTINATION
  ${CMAKE_INSTALL_CMAKEDIR}/${DAQMW_TAG}
  )

# ---------------------------------------------------------------
add_subdirectory(examples)


# - end
