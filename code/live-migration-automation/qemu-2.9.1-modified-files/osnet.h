/** Hotplug VFIO NIC
 *  The VFIO NIC hotplug updates the QEMU device state and
 *  induces the network downtime, when the guest handles the
 *  network traffic through the Virtio network device. We
 *  would like to see if we can eliminate such network
 *  downtime.
 */

#ifndef OSNET_H
#define OSNET_H

#define OSNET_HOTPLUG_VFIO 1
#define OSNET_HOTPLUG_VFIO_PRINT 0 

#endif
