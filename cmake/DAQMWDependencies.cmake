# - DAQ-Middleware dependencies

# -----------------------------------------------------------------------
# - Boost
set(DAQMW_BOOST_MIN_VERSION "1.69.0")
set(DAQMW_BOOST_COMPONENTS
  filesystem
  date_time
  # system
  )
set(Boost_NO_BOOST_CMAKE ON)
find_package(Boost ${DAQMW_BOOST_MIN_VERSION}
  REQUIRED
  ${DAQMW_BOOST_COMPONENTS}
  )
message(STATUS "Boost version ${Boost_VERSION} has been detected.")
message(STATUS "Found Boost ${Boost_VERSION}")
message(STATUS " - Boost include dirs : '${Boost_INCLUDE_DIRS}'")
message(STATUS " - Boost library dirs : '${Boost_LIBRARY_DIRS}'")
if (Boost_VERSION GREATER_EQUAL 106900)
  add_definitions("-DBOOST_MATH_DISABLE_STD_FPCLASSIFY")
endif()
foreach(_boost_lib ${DAQMW_BOOST_COMPONENTS})
  list(APPEND DAQMW_Boost_LIBRARIES Boost::${_boost_lib})
endforeach()
get_filename_component(DAQMW_BOOST_ROOT ${Boost_INCLUDE_DIR} DIRECTORY)
#include_directories(SYSTEM ${Boost_INCLUDE_DIRS})

# -----------------------------------------------------------------------
# - OpenRTM-aist
# set(DAQMW_OPENRTM_MIN_VERSION "2.0.0")
find_package(OpenRTM CONFIG)
message(STATUS "Found OpenRTM ${OPENRTM_VERSION}")
message(STATUS " - OPENRTM_ORB=${OPENRTM_ORB}")
message(STATUS " - COIL_INCLUDE_DIR=${COIL_INCLUDE_DIR}")
message(STATUS " - OPENRTM_INCLUDE_DIR=${OPENRTM_INCLUDE_DIR}")
message(STATUS " - OPENRTM_DATA_DIR=${OPENRTM_DATA_DIR}")
message(STATUS " - OPENRTM_INCLUDE_DIRS=${OPENRTM_INCLUDE_DIRS}")
message(STATUS " - OPENRTM_CFLAGS=${OPENRTM_CFLAGS}")
message(STATUS " - OPENRTM_LIB_DIR=${OPENRTM_LIB_DIR}")
message(STATUS " - OPENRTM_LIBRARY_DIRS=${OPENRTM_LIBRARY_DIRS}")
message(STATUS " - OPENRTM_LIBRARIES=${OPENRTM_LIBRARIES}")
message(STATUS " - OPENRTM_LDFLAGS=${OPENRTM_LDFLAGS}")
message(STATUS " - OPENRTM_IDL_WRAPPER=${OPENRTM_IDL_WRAPPER}")
message(STATUS " - OPENRTM_IDL_WRAPPER_FLAGS=${OPENRTM_IDL_WRAPPER_FLAGS}")
message(STATUS " - OPENRTM_IDLC=${OPENRTM_IDLC}")
message(STATUS " - OPENRTM_IDLFLAGS=${OPENRTM_IDLFLAGS}")
set(DAQMW_OPENRTM_VERSION ${OPENRTM_VERSION})
set(DAQMW_OPENRTM_VERSION_MAJOR ${OPENRTM_VERSION_MAJOR})
set(DAQMW_OPENRTM_VERSION_MINOR ${OPENRTM_VERSION_MINOR})
message(STATUS " - DAQMW_OPENRTM_VERSION=${DAQMW_OPENRTM_VERSION}")
message(STATUS " - DAQMW_OPENRTM_VERSION_MAJOR=${DAQMW_OPENRTM_VERSION_MAJOR}")
message(STATUS " - DAQMW_OPENRTM_VERSION_MINOR=${DAQMW_OPENRTM_VERSION_MINOR}")


# find_program(RTM_CONFIG_EXE rtm-config
#   DOC "The full path of the OpenRTM-aist's rtm-config executable"
#   REQUIRED
#   )
# message(STATUS "Found rtm-config at : ${RTM_CONFIG_EXE}")
# find_program(RTM_SKELWRAPPER_EXE rtm-skelwrapper
#   DOC "The full path of the OpenRTM-aist's rtm-skelwrapper executable"
#   REQUIRED
#   )
# message(STATUS "Found rtm-skelwrapper at : ${RTM_SKELWRAPPER_EXE}")

# -----------------------------------------------------------------------
# - XercesC
find_package(XercesC MODULE)
message(STATUS "Found XercesC ${XercesC_VERSION}")
set(DAQMW_XERCESC_VERSION ${XercesC_VERSION})

# -----------------------------------------------------------------------
# - XalanC
find_package(XalanC MODULE)
message(STATUS "Found XalanC ${XalanC_VERSION}")
set(DAQMW_XALANC_VERSION ${XalanC_VERSION})

# find_program(xalan_EXECUTABLE xalan
#   DOC "The full path of the xalan executable"
#   REQUIRED
#   )

find_program(XALAN_EXECUTABLE Xalan
  DOC "The full path of the Xalan executable"
  REQUIRED
  )
message(STATUS "XALAN_EXECUTABLE=${XALAN_EXECUTABLE}")

# -----------------------------------------------------------------------
# - XmlLint
find_program(XMLLINT_EXECUTABLE xmllint
  DOC "The full path of the xmllint executable"
  REQUIRED
  )
message(STATUS "XMLLINT_EXECUTABLE=${XMLLINT_EXECUTABLE}")

# -----------------------------------------------------------------------
# - ldd
find_program(LDD_EXECUTABLE ldd
  DOC "The full path of the ldd executable"
  REQUIRED
  )
message(STATUS "LDD_EXECUTABLE=${LDD_EXECUTABLE}")

# -----------------------------------------------------------------------
# - omniNames
find_program(OMNINAMES_EXECUTABLE omniNames
  DOC "The full path of the omniNames executable"
  REQUIRED
  )
message(STATUS "OMNINAMES_EXECUTABLE=${OMNINAMES_EXECUTABLE}")


# -----------------------------------------------------------------------
# - ROOT
if(DAQMW_WITH_ROOT)
  message(STATUS "ROOT_DIR=${ROOT_DIR}")
  set(DAQMW_ROOT_MIN_VERSION "6.08.00")
  set(DAQMW_ROOT_COMPONENTS Core Hist RIO Tree)
  set(CMAKE_MODULE_PATH_PREROOT ${CMAKE_MODULE_PATH})
  find_package(ROOT ${DAQMW_ROOT_MIN_VERSION} REQUIRED COMPONENTS ${DAQMW_ROOT_COMPONENTS} CONFIG)
  # if(ROOT_VERSION VERSION_LESS 6)
  #   include(RootNewMacros)
  # else()
  #   include(${ROOT_DIR}/modules/RootNewMacros.cmake)
  # endif()
  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH_PREROOT})
  message(STATUS "Found ROOT at ROOT_DIR      = '${ROOT_DIR}'")
  #include_directories(SYSTEM ${ROOT_INCLUDE_DIRS})
endif()



# ---------------------------------------------------
