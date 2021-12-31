CC=arm-linux-gnueabihf-gcc
CFLAGS=-Wall -Wextra 
DEPS = include/uio_helper.h include/color.h uio-driver.h
OBJ = include/uio_helper.o include/color.o uio-driver.o

%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

test: main.o $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)


.PHONY: copy
copy: test
	sshpass -p "root" scp test root@192.168.1.195:/home/root/


.PHONY: clean
clean:
	rm -f include/*.o
	rm -f *.o
	rm -f test
