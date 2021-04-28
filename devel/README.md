= Developers' corner scripts

Contents:

-`build.bash` : an experimental Bash script which configures, build and install
  the DAQ-Middleware software package from the CMake build system on some Linux
  system (Ubuntu).

On Ubuntu 20.04 (on which this script has been developped and tested), you must
install the following packages:

```
$ sudo apt-get install libboost-dev
$ sudo apt-get install libxalan-c-dev libxerces-c-dev
$ sudo apt-get install libxml2-utils # For xmllint
$ sudo apt-get install libomniorb4-dev
$ sudo apt-get install libomnithread4-dev
$ sudo apt-get install omniorb-nameserver
$ sudo apt-get install omniidl
$ sudo apt-get install cmake
```

Install the OpenRTM-aist library from `https://github.com/OpenRTM/OpenRTM-aist`

```
$ mkdir -p ${HOME}/sw/OpenRTM
$ cd ${HOME}/sw/OpenRTM
$ git clone https://github.com/OpenRTM/OpenRTM-aist.git OpenRTM-aist.git
$ cd OpenRTM-aist.git
$ mkdir _build.d
$ cd _build.d
$ cmake -DCMAKE_INSTALL_PREFIX:PATH=${HOME}/sw/OpenRTM/install/bin:${PATH} ..
$ make -j4
$ make install
$ export PATH=${HOME}/sw/OpenRTM/install/bin:${PATH}
$ which rtm-config
$ which rtm-skelwrapper
$ which rtm-naming
```