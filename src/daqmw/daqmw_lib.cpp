// Copyright (c) 2021 by Francois Mauger <mauger@lpccaen.in2p3.fr>
// Copyright (c) 2021 by Université de Caen Normandie

// Ourselves:
#include "daqmw_lib.h"

// Standard library
#include <string>
#include <iostream>

// OpenRTM:
#include <rtm/SystemLogger.h>

// This project:
#include "daqmw_config.h"

namespace DAQMW {

  struct library::pimpl_type
  {
    std::shared_ptr<RTC::Logger> logger;

    pimpl_type()
    {
      // Should forced link with OpenRTM
      logger.reset(new RTC::Logger("daqmwSyslog"));
      logger->setLevel("INFO");
    }
    
    ~pimpl_type()
    {
      logger.reset();
    }
    
  };
  
  // static
  std::string library::name()
  {
    return "daqmw";
  }

  // static
  std::string library::full_name()
  {
    return "DAQ-Middleware";
  }

  // static
  void library::log(int level_, const std::string & message_)
  {
    instance().m_pimpl->logger->write(level_, message_);
  }
  
  library::library()
  {
    std::cerr << "[daqmw.debug] daqmw core library is loaded\n";
    m_pimpl.reset(new pimpl_type);
    return;
  }

  library::~library()
  {
    m_pimpl.reset();
    std::cerr << "[daqmw.debug] daqmw core library is unloaded\n";
  }

  // static
  library & library::instance()
  {
    return library::_singleton_;
  }

  // static
  library library::_singleton_;
  
} // namespace DAQMW
