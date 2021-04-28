2021-04-28 :

- Add a devel directory for utility scripts and notes for developpers


2021-04-28 : dc10724cf5bf92289b7590bd129c116fd3b6c59f

- Results:
  - commit: dc10724cf5bf92289b7590bd129c116fd3b6c59f
  - First version of the CMake build system for DAQ-Middleware:
    Processed directories: 
    - src, bin, conf, docs, remote-boot
    - examples (installation + optional build during build process)  
  - Fixed various C++ warnings/errors (due to the use of -Werror)
  - Add the ``daqmw`` library (not build by default) besides the legacy `sock`, `sitcpbcp`,
    `Sock`, `SitcpRbcp` and `JsonSpirit` libraries
  - Use RPATH for automatic resolution of shared libraries path
  - Provide CMake configuration scripts for client packages with
    CMake helper function to help the automatic build of binary components

2021-04-26 : 

- Objectives:
 
  - original commit: bec161a0cd9c5de69659199521da3be8996cfef4
    from https://github.com/h-sendai/DAQ-Middleware (version 1.4.4)
  - setup a full CMake setup to manage the DAQ-Middleware build/install procedure
  - build and install DAQ-Middleware on Ubuntu 20.04 LTS with GCC 9 and
    a recent OpenRTM-aist (2.0.0)
