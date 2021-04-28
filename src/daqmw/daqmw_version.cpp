// Copyright (c) 2013 by Ben Morgan <bmorgan.warwick@gmail.com>
// Copyright (c) 2013 by The University of Warwick
// Copyright (c) 2020-2021 by Francois Mauger <mauger@lpccaen.in2p3.fr>
// Copyright (c) 2020-2021 by Université de Caen Normandie

// Ourselves:
#include "daqmw_version.h"

// Standard library
#include <memory>
#include <set>
#include <sstream>

// OpenRTM-aist
#include <rtm/version.h>

// This project:
#include "daqmw_config.h"

namespace DAQMW {

  int version::get_major() {
    return static_cast<int>(DAQMW_VERSION_MAJOR);
  }

  int version::get_minor() {
    return static_cast<int>(DAQMW_VERSION_MINOR);
  }

  int version::get_patch() {
    return static_cast<int>(DAQMW_VERSION_PATCH);
  }

  std::string version::get_version() {
    static std::string version("");

    if (version.empty()) {
      std::ostringstream stream;
      stream << DAQMW_VERSION_MAJOR << "."
             << DAQMW_VERSION_MINOR << "."
             << DAQMW_VERSION_PATCH;
      version = stream.str();
    }

    return version;
  }

  bool version::is_at_least(int major_, int minor_, int patch_) {
    if (DAQMW_VERSION_MAJOR < major_) return false;
    if (DAQMW_VERSION_MAJOR > major_) return true;
    if (DAQMW_VERSION_MINOR < minor_) return false;
    if (DAQMW_VERSION_MINOR > minor_) return true;
    if (DAQMW_VERSION_PATCH < patch_) return false;
    return true;
  }

  bool version::has_feature(const std::string & name_) {
    /// - If you want to add features, then the following implementation
    ///   provides one example based on string features cached in a set.
    ///
    static std::unique_ptr<std::set<std::string>> _features;
    
    if (! _features.get()) {
      _features.reset(new std::set<std::string>);
      // Cache the feature list
      // if (DAQMW_WITH_XXX) _features->insert("with-xxx");
      // if (DAQMW_WITH_YYY) _features->insert("with-yyy");
    }
    
    return _features->find(name_) != _features->end();
  }

  // static
  std::string version::get_rtm_version()
  {
    return std::string(RTC::openrtm_version);
    // return DAQMW_OPENRTM_LIB_VERSION;
  }

} // namespace DAQMW
