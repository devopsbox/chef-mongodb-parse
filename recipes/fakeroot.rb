## http://askubuntu.com/questions/74061/install-packages-without-starting-background-processes-and-services
script = %Q{
mkdir /root/fake
cd /root/fake
ln -s /bin/true initctl
ln -s /bin/true invoke-rc.d
ln -s /bin/true restart
ln -s /bin/true start
ln -s /bin/true stop
ln -s /bin/true start-stop-daemon
ln -s /bin/true service
}


bash "create fake root" do
  code script
  not_if "test -e /root/fake"
end