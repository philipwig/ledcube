APP = panel-ctrl

# Add any other object files to this list below
APP_OBJS = panel-ctrl.o include/uio_helper.o include/color.o
DEPS = system.h include/uio_helper.h include/color.h include/types.h

all: build

build: $(APP)

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

$(APP): $(APP_OBJS)
	$(CC) -o $@ $(APP_OBJS) $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(APP) *.o

