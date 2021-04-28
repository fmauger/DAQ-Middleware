#include <iostream>
#include <arpa/inet.h>
#include <string.h>
#include "Sock.h"

int main(int /* argc */, char** /*argv*/) {
  using namespace DAQMW;
  using namespace std;

  int status(0);
  unsigned int packet[2], data;
  char buffer[1000];

  try {
    Sock* sock = new Sock();
    for(int i=0; i<10; i++) {
      status = sock->connect("127.0.0.1", 23);
      if(status==Sock::ERROR_TIMEOUT) {
        clog << "Sock connect timeout. retry..." << endl;
      }
      else
        break;
    }
    int len = 8;
    packet[0] = 0xa3;
    packet[1] = 0x28000000; // write length of 10 events
    for(int i=0; i<10; i++) {
      status = sock->sendAll(packet, len);
      if(status==Sock::ERROR_TIMEOUT) {
        clog << "Sock sendAll timeout. retry..." << endl;
      }
      else
        break;
    }
    clog << "Lenght of written data  = " << len;
    clog << "    Length of Actual written data = " << status << endl;

    len = 4; // read actual length of data which can be read.
    for(int i=0;i<10;i++) {
      status = sock->recvAll(&data, len);
      if(status==Sock::ERROR_TIMEOUT) {
        clog << "Sock recvAll Timeout. retry..." << endl;
      } else
        break;
    }
    clog << "actual length of data in short word = " << ntohl(data) << endl;

    len = ntohl(data)*2; // actual length in bytes
    for(int i=0; i<10; i++) {
      status = sock->recvAll((unsigned int*)buffer, len);
      if(status==Sock::ERROR_TIMEOUT) {
        clog << "Sock recvAll timeout. retry..." << endl;
      } else
        break;
    }
    clog << "Actual length of read data in byte = " << status << endl;
  } catch (SockException& e) {
    std::cerr << "Sock Fatal Error : " << e.what() << std::endl;
  } catch (...) {
    std::cerr << "Sock Fatal Error : Unknown" << std::endl;
  }
  return 0;
}
