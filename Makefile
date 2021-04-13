PREFIX = $(PS2DEV)

SUBMAKE = $(MAKE) -C
SHELL = /bin/sh
SYSTEM = $(shell uname)
LIBZA = -lz
LIBLZMAA = lzma/lzma.a
LZMA_MT ?= 1
ifeq ($(LZMA_MT),1)
	LIBLZMAA += -lpthread
endif
LZMA_CPPFLAGS = -I common/lzma
VERSION = 1.1.0
BIN2C = $(PS2SDK)/bin/bin2c
CPPFLAGS := -O3 -Wall -I. -DVERSION=\"$(VERSION)\" -DPREFIX=\"$(PREFIX)\" $(CPPFLAGS)
INSTALL = install

ifeq ($(SYSTEM),Darwin)
	CPPFLAGS += -D__APPLE__
	SHARED = -dynamiclib
	SHAREDSUFFIX = .dylib
	CC = /usr/bin/gcc
	CPPFLAGS += -I/usr/local/include -L/usr/local/lib
else ifeq ($(OS),Windows_NT)
	SHAREDSUFFIX = .dll
	EXECSUFFIX = .exe
	DIST_PACK_CMD = zip -9
	DIST_PACK_EXT = .zip
	LDFLAGS = #Libdl is built into glibc for both Cygwin and MinGW.
else ifeq ($(findstring BSD, $(SYSTEM)), BSD)
	ifeq ($(SYSTEM),NetBSD)
		CPPFLAGS += -I/usr/pkg/include -L/usr/pkg/lib  -R/usr/pkg/lib
	else
		CPPFLAGS += -I/usr/local/include -L/usr/local/lib
	endif
	CC = cc
	LDFLAGS =
endif

CC ?= gcc
SHARED ?= -shared
SHAREDSUFFIX ?= .so
EXECSUFFIX ?=
DIST_PACK_CMD ?= tar cvfz
DIST_PACK_EXT ?= .tar.gz
LDFLAGS ?= -ldl



all:  ps2-packer-lite 

install: all
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/bin
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/share/ps2-packer/module

	
	$(INSTALL) -m 755  $(DESTDIR)$(PREFIX)/share/ps2-packer/module
	$(INSTALL) -m 755 ps2-packer-lite $(DESTDIR)$(PREFIX)/bin
	PREFIX=$(PREFIX) 

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/ps2-packer$(EXECSUFFIX) $(DESTDIR)$(PREFIX)/bin/ps2-packer-lite$(EXECSUFFIX)
	



ps2-packer-lite: ps2-packer.c  lzma
	$(CC) $(CPPFLAGS) $(LZMA_CPPFLAGS) -DPS2_PACKER_LITE ps2-packer.c lzma-packer.c $(LIBLZMAA) $(LDFLAGS) -o ps2-packer-lite$(EXECSUFFIX)



lzma: lzma-tag.stamp

lzma-tag.stamp:
	$(SUBMAKE) lzma
	touch lzma-tag.stamp





lzma-packer$(SHAREDSUFFIX): lzma lzma-packer.c
	$(CC) -fPIC $(CPPFLAGS) $(LZMA_CPPFLAGS) lzma-packer.c $(SHARED) -o lzma-packer$(SHAREDSUFFIX) $(LIBLZMAA)






clean:
	rm -f  ps2-packer-lite  ps2-packer-lite.exe *.zip *.gz *.dll  *$(SHAREDSUFFIX) *.o
	$(SUBMAKE) lzma clean
	rm -f lzma-tag.stamp
	

rebuild: clean all



#
# Everything below is for me, building the distribution packages.
#

dist: all COPYING stubs-dist README.txt ps2-packer.c 
	strip ps2-packer$(EXECSUFFIX) ps2-packer-lite$(EXECSUFFIX) 
	$(DIST_PACK_CMD) ps2-packer-$(VERSION)$(DIST_PACK_EXT) ps2-packer$(EXECSUFFIX)  COPYING README.txt
	$(DIST_PACK_CMD) ps2-packer-lite-$(VERSION)$(DIST_PACK_EXT) ps2-packer-lite$(EXECSUFFIX) COPYING README.txt README-lite.txt
	tar cvfz ps2-packer-$(VERSION)-src.tar.gz *.{c,h} Makefile README.txt README-lite.txt

redist: clean dist

release: redist
	rm -f /var/www/softwares/ps2-packer/*
	cp *.gz *.zip COPYING README.txt README-lite.txt /var/www/softwares/ps2-packer
