obj-m += vmx_configuration.o
ccflags-y := -std=gnu99 -Wno-declaration-after-statement

all: modules run_vmx_configuration

modules:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

insert:
	insmod vmx_configuration.ko

remove:
	rmmod vmx_configuration

run_vmx_configuration: run_vmx_configuration.c vmx.h
	gcc -Wall -o run_vmx_configuration run_vmx_configuration.c

.PHONY: clean
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm run_vmx_configuration
