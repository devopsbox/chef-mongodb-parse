define :create_raided_drives_from_snapshot, :disk_counts => 4,
       :disk_size => 999, :level => 10, :filesystem => "ext4",
       :disk_type => "standard", :disk_piops => 0 do
  Chef::Log.info("cluster name is #{node[:mongodb][:cluster_name]}")
  require 'aws/s3'

  aws_access_key_id     = node[:mongodb][:aws_access_key_id]
  aws_secret_access_key = node[:mongodb][:aws_secret_access_key]


  aws_ebs_raid "createmongodir" do
        aws_access_key        aws_access_key_id
        aws_secret_access_key aws_secret_access_key
        mount_point node[:mongodb][:dbpath]
        disk_count params[:disk_counts]
        disk_size  params[:disk_size]
        disk_type  params[:disk_type]
        disk_piops params[:disk_piops]
        filesystem params[:filesystem]
        level      params[:level]

        action     [:auto_attach]
        snapshots  MongoDB.find_snapshots(aws_access_key_id,
                                          aws_secret_access_key,
                                          node[:backups][:region],
                                          node[:backups][:mongo_volumes],
                                          node[:mongodb][:cluster_name])
  end
  # Remove the lock file
  execute "remove_mongo_lock" do
    command "rm -f /var/lib/mongodb/mongod.lock && mkdir -p /var/chef/state && touch /var/chef/state/finish_ebs_volumes"
        creates "/var/chef/state/finish_ebs_volumes"
        action :run
  end
end
