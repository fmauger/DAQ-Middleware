# -

configure_file(DAQMWBuildComponent.cmake.in
  ${PROJECT_BUILD_CMAKEDIR}/${DAQMW_TAG}/DAQMWBuildComponent.cmake
  @ONLY)


# file(COPY ${CMAKE_CURRENT_BINARY_DIR}/DAQMWBuildComponent.cmake
#   DESTINATION "${PROJECT_BUILD_CMAKEDIR}/${DAQMW_TAG}/"
#   )
