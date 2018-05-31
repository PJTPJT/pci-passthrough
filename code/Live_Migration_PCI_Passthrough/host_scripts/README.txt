1) Run migrate_dest_vfio.sh at Destination Side. This will set up the evironment and also wait for the in coming vm.

Once the VM is completly migrated it will hot plug the VFIO device and then make it as primary.

2) Run migrate_source_vfio.sh at source side. This will set up all the environments and start the vm.
After 100 Seconds the VM will start migration by switching to VIRTIO

