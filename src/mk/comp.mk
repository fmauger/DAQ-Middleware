# GNU make 3.80 does not allow else ifdef clause.
INCLUDE_PATH = /usr/include/daqmw

ifdef DAQMWSRCROOT
# in source tree
INCLUDE_PATH = $(DAQMWSRCROOT)/src/DaqComponent
endif

# use special install directory
ifdef DAQMWINSTALLROOT
INCLUDE_PATH = $(DAQMWINSTALLROOT)/include/daqmw
endif

IDL_PATH = $(INCLUDE_PATH)/idl

AUTO_GEN_DIR = autogen

VPATH += $(INCLUDE_PATH)
VPATH += $(IDL_PATH)

CPPFLAGS += -I$(INCLUDE_PATH)
CPPFLAGS += -I$(IDL_PATH)
CPPFLAGS += -I.
CPPFLAGS += -I$(AUTO_GEN_DIR)

SKEL_OBJ  = $(AUTO_GEN_DIR)/DAQServiceSkel.o  	
IMPL_OBJ  = $(AUTO_GEN_DIR)/DAQServiceSVC_impl.o 
OBJS     += $(SKEL_OBJ) $(IMPL_OBJ)
OBJS     += $(subst .cpp,.o, $(SRCS))

CXXFLAGS += $(shell rtm-config --cflags)
LDFLAGS  += $(shell rtm-config --libs)
SHFLAGS  = -shared

IDLC     = `rtm-config --idlc`
IDLFLAGS = `rtm-config --idlflags` -I`rtm-config --rtm-includedir`/rtm/idl
WRAPPER  = rtm-skelwrapper
WRAPPER_FLAGS = --include-dir="" --skel-suffix=Skel --stub-suffix=Stub

LIB_DIR=lib
try_lib64 = $(shell ls -d /usr/lib64 2>/dev/null)
arch = $(shell uname -m)
ifeq "$(strip $(try_lib64))" "/usr/lib64"
ifeq "$(strip $(arch))"      "x86_64"
LIB_DIR=lib64
endif
endif
DAQMW_LIB_DIR=/usr/$(LIB_DIR)/daqmw

$(COMP_NAME)Comp: .depend $(OBJS)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS) $(LDLIBS)

#$(COMP_NAME).h: DAQServiceSVC_impl.h
$(COMP_NAME).o: $(COMP_NAME).h $(COMP_NAME).cpp $(FILES)
$(COMP_NAME)Comp.o: $(COMP_NAME)Comp.cpp $(COMP_NAME).h

.depend:
	rm -fr $(AUTO_GEN_DIR)
	mkdir $(AUTO_GEN_DIR)
	(cd $(AUTO_GEN_DIR); ln -s $(IDL_PATH)/DAQService.idl; $(IDLC) $(IDLFLAGS) DAQService.idl; $(WRAPPER) $(WRAPPER_FLAGS) --idl-file=DAQService.idl)
	(cd $(AUTO_GEN_DIR); $(IDLC) $(IDLFLAGS) DAQService.idl; $(WRAPPER) $(WRAPPER_FLAGS) --idl-file=DAQService.idl)
	@touch .depend

# install target should be defined in the user's makefile
# because we don't know where is the install directory.
# Please do not remove this comment out.
#install: all
#	mkdir -p $(BINDIR)
#	install -m 755 $(COMP_NAME)Comp $(BINDIR)

clean:
	@rm -f $(wildcard *.o) $(COMP_NAME)Comp.o $(COMP_NAME)Comp
	@rm -f *Skel.h *Skel.cpp
	@rm -f *Stub.h *Stub.cpp
	@rm -f *~
	@rm -f DAQService.hh DAQServiceDynSK.cc DAQServiceSK.cc
	@rm -f DAQService.idl
	@rm -f symlink
	@rm -fr $(AUTO_GEN_DIR) .depend

#DAQServiceSkel.cpp: DAQService.idl
#	$(IDLC) $(IDLFLAGS) DAQService.idl
#	$(WRAPPER) $(WRAPPER_FLAGS) --idl-file=DAQService.idl
#DAQServiceSkel.h : DAQService.idl
#	$(IDLC) $(IDLFLAGS) DAQService.idl
#	$(WRAPPER) $(WRAPPER_FLAGS) --idl-file=DAQService.idl

#DAQServiceSVC_impl.h: DAQServiceSkel.h

$(AUTO_GEN_DIR)/DAQServiceSVC_impl.o: DAQServiceSVC_impl.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<
#$(AUTO_GEN_DIR)/DAQServiceSkel.o: $(AUTO_GEN_DIR)/DAQServiceSkel.cpp $(AUTO_GEN_DIR)/DAQServiceSkel.h

# comp.mk ends here
