// Standard library
#include <iostream>

#include "daqmw_lib.h"
#include "daqmw_config.h"
#include "daqmw_version.h"

int main(int /* argc */, char** /* argv */) {
  
  std::clog << "Library : " << DAQMW::library::full_name() << '\n';
  std::clog << " - Version       : " << DAQMW::version::get_version() << '\n';
  std::clog << " - Major version : " << DAQMW::version::get_major() << '\n';
  std::clog << " - Minor version : " << DAQMW::version::get_minor() << '\n';
  std::clog << " - Patch version : " << DAQMW::version::get_patch() << '\n';
  std::clog << " - RTM version   : " << DAQMW::version::get_rtm_version() << '\n';
  return 0;
}
