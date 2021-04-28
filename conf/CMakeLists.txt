
set(DAQMW_CONFS
  condition.xml
  config.xsd
  sample.xml
  skel.xml
  tiny.xml
  4comps.xml
  reader-logger.xml
  )

file(COPY ${DAQMW_CONFS}
  DESTINATION "${CMAKE_DATAROOT_OUTPUT_DIRECTORY}/daqmw/conf"
)  

install(FILES ${DAQMW_CONFS}
  DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/daqmw/conf"
  PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
  )
