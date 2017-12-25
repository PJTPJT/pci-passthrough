obj-m += read_vmcs_control_field.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm *.o *.ko *.mod.c .*.cmd modules.order
