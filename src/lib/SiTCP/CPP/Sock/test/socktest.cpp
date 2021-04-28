#include <iostream>
#include <arpa/inet.h>
#include <string.h>
#include "Sock.h"

int main(int /* argc */, char** /* argv */) {
  using namespace DAQMW;
  using namespace std;

  int status(0);
  unsigned int packet[2], data;
  unsigned char buffer[1000];

  Sock* sock = new Sock("127.0.0.1", 23);
  // Sock* sock = new Sock("192.168.0.16", 23);
  //  Sock* sock = new Sock("192.168.0.19", 23);
  status = sock->connectTCP();
  if(status < 0) {
    cerr << "Sock connect fail" << endl;
  } else {
    int len = 8;
    packet[0] = 0xa3;
    packet[1] = 0x28000000; // write length of 10 events
    status = sock->write((unsigned char*)packet, len);
    if(status < 0) {
      cerr << "Sock write fail" << endl;
    } else {
      clog << "Length of written data  = " << len;
      clog << "  Length of Actual written data = " << status << endl;
      
      len = 4; // read actual length of data which can be read.
      status = sock->read((unsigned char*)&data, len);
      if(status < 0) {
        cerr << "Sock read fail" << endl;
      } else {
        clog << "actual length of data in short word = " << ntohl(data) << endl;
        
        len = ntohl(data)*2; // actual length in bytes
        status = sock->read(buffer, len);
        if(status < 0) {
          cerr << "Sock read fail" << endl;
        } else {
          clog << "Actual length of read data in byte = " << status << endl;
        }
      }
    }
  }
  return 0;
}
