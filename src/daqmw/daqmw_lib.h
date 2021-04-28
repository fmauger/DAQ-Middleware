//! \file    daqmw/daqmw_lib.h
//! \brief   Describe the DAQ-Middleware API library
// Copyright (c) 2021 by Francois Mauger <mauger@lpccaen.in2p3.fr>
// Copyright (c) 2021 by Université de Caen Normandie

#ifndef DAQMW_DAQMW_LIB_H
#define DAQMW_DAQMW_LIB_H

// Standard library
#include <string>
#include <memory>

namespace DAQMW {

  struct library
  {
    static std::string name();
    static std::string full_name();

    static library & instance();
    static void log(int level_, const std::string & message_);
    
  private:

    library();

  public:
    
    ~library();

  private:
    
    // Non copyable
    library(const library &) = delete;
    library & operator=(const library &) = delete;

    static library _singleton_;

    struct pimpl_type;
    std::unique_ptr<pimpl_type> m_pimpl;
    
  };
  
} // namespace DAQMW

#endif // DAQMW_DAQMW_LIB_H
