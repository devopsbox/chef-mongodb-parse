define :generate_raid_backups do

  aws_access_key_id     = node[:mongodb][:aws_access_key_id]
  aws_secret_access_key = node[:mongodb][:aws_secret_access_key]
#  volumes = node[:backups][:mongo_volumes].join(" ")

  template "/usr/local/bin/raid_snapshot.sh" do
    source "raid_snapshot.sh.erb"
    owner "root"
    group "root"
    mode "0755"
    variables("awskey" => aws_access_key_id,
              "seckey" => aws_secret_access_key )
  end
end

