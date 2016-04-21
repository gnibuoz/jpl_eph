# Makefile for gcc (and MinGW,  and clang)
# Note dependence of 'sub_eph' on the 'lunar' library.  This is available
# at http://www.projectpluto.com/source.htm .
# Note also that 'sub_eph' is the last file to be built.  You can make
# everything else and ignore the missing dependency error if you aren't
# interested in building 'sub_eph'.
#	'XCOMPILE' = cross-compile for Windows,  using MinGW,  on a Linux box
#	'MSWIN' = compile for Windows,  using MinGW,  on a Windows machine
#	'CLANG' = use clang instead of GCC;  Linux only
# None of these: compile using g++ on Linux,  for Linux

CFLAGS=-Wall -O3 -Wextra -pedantic

ifdef CLANG
	CC=clang
	LIB=-lm
	else
	CC=g++
	LIB=
endif

ifdef MSWIN
	EXE=.exe
else
	EXE=
endif

ifdef XCOMPILE
	CC=x86_64-w64-mingw32-g++
	EXE=.exe
endif

all: asc2eph$(EXE) dump_eph$(EXE) eph2asc$(EXE) ftest$(EXE) merge_de$(EXE) testeph$(EXE) sub_eph$(EXE)

install:
	cp jpleph.h /usr/local/include
	cp libjpl.a /usr/local/lib

uninstall:
	rm /usr/local/include
	rm /usr/local/lib

libjpl.a: jpleph.o
	$(RM) libjpl.a
	ar rv libjpl.a jpleph.o

.cpp.o:
	$(CC) $(CFLAGS) -c $<

asc2eph$(EXE):          asc2eph.o f_strtod.o
	$(CC) -o asc2eph$(EXE) asc2eph.o f_strtod.o $(LIB)

ftest$(EXE):          ftest.o f_strtod.o
	$(CC) -o ftest$(EXE) ftest.o f_strtod.o

eph2asc$(EXE):          eph2asc.o libjpl.a
	$(CC) -o eph2asc$(EXE) eph2asc.o libjpl.a $(LIB)

dump_eph$(EXE):          dump_eph.o libjpl.a
	$(CC) -o dump_eph$(EXE) dump_eph.o libjpl.a $(LIB)

merge_de$(EXE):          merge_de.o libjpl.a
	$(CC) -o merge_de$(EXE) merge_de.o libjpl.a $(LIB)

sub_eph$(EXE):          sub_eph.o libjpl.a
	$(CC) -o sub_eph$(EXE) sub_eph.o libjpl.a -llunar $(LIB)

sub_eph.o: sub_eph.cpp
	$(CC) $(CFLAGS) -c -DTEST_MAIN sub_eph.cpp

testeph$(EXE):          testeph.o libjpl.a
	$(CC) -o testeph$(EXE) testeph.o libjpl.a $(LIB)

clean:
	$(RM) *.o
	$(RM) asc2eph$(EXE)
	$(RM) dump_eph$(EXE)
	$(RM) eph2asc$(EXE)
	$(RM) ftest$(EXE)
	$(RM) merge_de$(EXE)
	$(RM) sub_eph$(EXE)
	$(RM) testeph$(EXE)
	$(RM) libjpl.a
