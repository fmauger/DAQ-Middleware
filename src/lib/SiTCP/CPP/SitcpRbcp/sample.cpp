#include <cstdio>
#include <iostream>

#include "SitcpRbcp.h"

int main(int /* argc */, char * /*argv*/[])
{
    int address = 0x1ad;
    int length  = 1;
    SitcpRbcp bcp;
    unsigned char * buf = new unsigned char[length];

    //if (bcp.read_registers("192.168.10.16", address , sizeof(buf), buf) < 0) {
    //    return 1;
    //}

    //for (int i = 0; i < length; i++) {
    //    printf("%02x %02x\n", address + i, buf[i]);
    //}

    //buf[0] = 100;
    //bcp.write_registers("192.168.0.20", address, length, buf, NEED_VERIFY);
    //bcp.read_registers("192.168.0.20", address, length, buf);

    buf[0] = 100;
    bcp.set_verify_mode();
    std::clog << "trying to write" << std::endl;
    if (bcp.write_registers("192.168.0.32", address, length, buf) < 0) {
        std::cerr << "ERROR!" << std::endl;
    }

    address = 0x80;
    length  = 6;
    unsigned char * mac = new unsigned char[length];
    if (bcp.read_registers("192.168.0.32", address , sizeof(mac), mac, 100) < 0) {
      std::cerr << "ERROR: cannot read registers" << std::endl;
    } else {
      std::clog << "LOG: read registers:" << std::endl;
      for (int i = 0; i < length; i++) {
        printf("%02x %02x\n", address + i, mac[i]);
      }
    }

    delete[] buf;
    delete[] mac;
    return 0;
}
