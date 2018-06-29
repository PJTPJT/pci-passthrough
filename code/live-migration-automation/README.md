### Steps for Live Migration Automation:
1. Run vm migration agent in /etc/rc.local
   + cd /
   + mkdir migration-agent
   + Add all the files required for live migration to "migration-agent" directory
   + Add the following lines to rc.local
   + migration_dir="/migration-agent"
   + sh "${migration_dir}/setup_bonding_driver.sh"
   + cd ${migration_dir}
   + ./vm_migration_agent 10.128.0.41 prepared 10.128.0.42 &
   + cd /etc

2. Similary, place destination migration agent in /etc/rc.local
   + cd /
   + mkdir destination-migration_agent
   + Add all the files required for live migration to "destination-migration-agent" directory
   + Add the following lines to rc.local
   + destination_migration_dir="destination-migration-agent"
   + cd ${destination_migration_dir}
   + ./destination_migration_agent 10.128.33.11 switch connected&
   + cd /etc

3. To run guest use the following command in source host machine:
   + ./prepare_and_run_vm_nic_bonding.sh 1 1024 /nfs/ubuntu_16_nic_bonding_source.img

4. To initiate migration, run the following command on source host machine:
   + ./source_migration_agent 10.128.33.11 10.128.0.42 prepare
