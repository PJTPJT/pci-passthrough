Steps for Live Migration Automation
-----------------------------------
1. Run guest migration agent in /etc/rc.local
   + cd /
   + mkdir migration-agent
   + Add all the files in guest-migration-agent directory to migration-agent
   + Add the following lines to rc.local
   ```
    migration_dir="/migration-agent"
    cd ${migration_dir}
    ./setup_bonding_driver.sh
    ./guest_migration_agent DESTINATION_IP prepared SOURCE_IP &
    cd /etc
   ```

2. Similary, place destination migration agent in /etc/rc.local
   + cd /
   + mkdir migration-agent
   + Add all the files in destination-migration-agent to "migration-agent" directory
   + Modify the parameters smp (number of processors), m (memory) and file (virtual machine image) in run_destination_vm.sh as required.
   + Add the following lines to rc.local
   ```
    migration_dir="migration-agent"
    cd ${migration_dir}
    ./setup_vf.sh 1
    ./destination_migration_agent GUEST_IP switch connected &
    cd /etc
   ```

3. To run the guest and source migration agent in source host machine
   + cd /
   + mkdir migration-agent
   + Add setup_vf.sh to migration-agent directory
   + Add the following lines to /etc/rc.local
   ```
    migration_dir="migration-agent"
    cd ${migration_dir}
    ./setup_vf.sh 1
    cd /etc
   ```
   + Modify the parameters smp (number of processors), m (memory), file (virtual machine image) and host (device id) in run_source_vm.sh as required.
   + Run the guest using ./run_source_vm.sh &

4. To initiate migration, run the following command on source host machine:
   + ./source_migration_agent GUEST_IP DESTINATION_IP prepare
