CC = g++
CCFLAGS = -Wall -O2 -std=c++0x `PATH="$$HOST_PATH:PATH" kcutilmgr conf -i` 

all: lib

lib: objects
	if [ ! -d lib ]; then mkdir lib; fi
	ar rvs lib/libterminator.a *.o

objects:
	$(CC) $(CCFLAGS) -c src/terminator*.cc

clean:
	rm -rf *.o
	if [ -d lib ]; then rm -rf lib/*; fi
	rm -rf demo/train.model demo/corpus/ demo/run-demo

format:
	cd src; astyle --style=google --indent=spaces=2 *.cc *.h; rm -f *.orig
	cd demo; astyle --style=google --indent=spaces=2 *.cc; rm -f *.orig

demo: lib
	cd demo; tar -xjf corpus.tar.bz2; [ -f train.model ] && rm train.model; $(CC) $(CCFLAGS) main.cc `PATH="$$HOST_PATH:PATH" kcutilmgr conf -l` -I../src -L../lib -lterminator -o run-demo

run-demo: demo
	cd demo; ./run-demo;
