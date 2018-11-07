#ifndef MONITOR_QDEV_H
#define MONITOR_QDEV_H

#include "hw/qdev-core.h"

/* OSNET-HOTPLUG-VFIO */
#include "osnet.h"
/* OSNET-END */

/*** monitor commands ***/

void hmp_info_qtree(Monitor *mon, const QDict *qdict);
void hmp_info_qdm(Monitor *mon, const QDict *qdict);
void hmp_info_qom_tree(Monitor *mon, const QDict *dict);
void qmp_device_add(QDict *qdict, QObject **ret_data, Error **errp);

int qdev_device_help(QemuOpts *opts);
DeviceState *qdev_device_add(QemuOpts *opts, Error **errp);
void qdev_set_id(DeviceState *dev, const char *id);

#if OSNET_HOTPLUG_VFIO
DeviceState *find_device_state(const char *id, Error **errp);
//DeviceState *osnet_qmp_device_add(QDict *qdict, QObject **ret_data, Error **errp);
void qmp_osnet_device_add(QDict *qdict, QObject **ret_data, Error **errp);
void qmp_osnet_vfio_nic_realize_top_half(QDict *qdict, QObject **ret_data, Error **errp);
void qmp_osnet_vfio_nic_realize_bottom_half(QDict *qdict, QObject **ret_data, Error **errp);
DeviceState *osnet_qdev_device_add(QemuOpts *opts, Error **errp);
#endif

#endif
