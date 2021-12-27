APP = led-test-uio

# Add any other object files to this list below
APP_OBJS = led-test-uio.o include/color.o include/mathey.o include/types.o

TARGET_CC_ARCH += "${LDFLAGS}"

all: build

build: $(APP)

%.o: %.c
	$(CC) -c $(LDLIBS)-o $@ $<

$(APP): $(APP_OBJS)
	$(CC) -o $@ $(APP_OBJS) -lm $(LDLIBS) $(LDFLAGS)
clean:
	rm -f $(APP) *.o

