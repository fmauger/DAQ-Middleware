set(DAQMW_EXAMPLES
  SampleLogger
  SampleMonitor 
  SampleReader 
  SampleReader2 
  SampleFilter 
  Skeleton 
  SkeletonSink 
  SkeletonSource 
  ConditionSampleMonitor 
  TinySink 
  TinySource 
  Dispatcher 
  BestEffortDispatcher 
  SitcpRbcp 
  )

set(DAQMW_EXAMPLES_BUILT
  SampleLogger
  SampleReader 
  )

if(DAQMW_WITH_ROOT)
  list(APPEND DAQMW_EXAMPLES_BUILT SampleMonitor)
endif()

list(APPEND DAQMW_EXAMPLES_BUILT
  # SampleReader2 
  # SampleFilter 
  # Skeleton 
  # SkeletonSink 
  # SkeletonSource 
  # ConditionSampleMonitor 
  # TinySink 
  # TinySource 
  # Dispatcher 
  # BestEffortDispatcher 
  # SitcpRbcp 
  )

# set(DAQMW_EXAMPLES_UTILS change-SampleComp-name)

foreach(_daqmw_example ${DAQMW_EXAMPLES})
  file(COPY ${_daqmw_example}
    DESTINATION "${CMAKE_DATAROOT_OUTPUT_DIRECTORY}/daqmw/examples/${_daqmw_example}"
    )

  install(DIRECTORY ${_daqmw_example}
    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/daqmw/examples"
    FILE_PERMISSIONS
    OWNER_READ OWNER_WRITE
    GROUP_READ
    WORLD_READ
    FILES_MATCHING
    PATTERN "*.h" 
    PATTERN "*.cpp" 
    PATTERN "CMakeLists.txt" 
    )
  
endforeach()

if (DAQMW_BUILD_EXAMPLES)
  message(STATUS "Building examples...")
  set(DAQMW_DIR ${DAQMW_BUILD_CMAKEDIR}/${DAQMW_TAG})
  set(BOOST_ROOT ${DAQMW_BOOST_DIR})
  set(Boost_DIR ${DAQMW_BOOST_DIR})
  set(OpenRTM_DIR ${OPENRTM_DIR})
  # - Exported targets are not available yet so we by-pass targets loading from the CMake config script:
  set(DAQMW_TARGETS_LOADED 1)
  message(STATUS "OpenRTM_DIR=${OpenRTM_DIR}")
  foreach(_daqmw_example ${DAQMW_EXAMPLES_BUILT})
    message(STATUS "Building example ${_daqmw_example}...")
    add_subdirectory(${_daqmw_example})
  endforeach()
endif (DAQMW_BUILD_EXAMPLES)
