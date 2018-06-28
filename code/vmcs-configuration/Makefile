obj-m += vmcs_configuration.o
ccflags-y := -std=gnu99 -Wno-declaration-after-statement

all: modules run_vmcs_configuration

modules:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

insert:
	insmod vmcs_configuration.ko

remove:
	rmmod vmcs_configuration

run_vmcs_configuration: run_vmcs_configuration.c vmcs.h vmcs_field.h
	gcc -Wall -o run_vmcs_configuration run_vmcs_configuration.c

.PHONY: clean
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm run_vmcs_configuration
