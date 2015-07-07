#
# Cookbook Name:: erln8
# Recipe:: default
#
# Copyright (c) 2015 Dave Parfitt, All Rights Reserved.
#
#
execute "apt-get update" do
      command "apt-get update"
      ignore_failure true
  only_if { node["platform"] == "ubuntu" && node["erln8"]["update_apt"] }
end

remote_file '/tmp/dmd.deb' do
  source node["dmd"]["url"]
  action :create
end

remote_file 'tmp/dub.tar.gz' do
  source node["dub"]["url"]
  action :create
end

package ["wget", "build-essential", "gawk", "m4", "gcc-multilib", "libcurl3", "xdg-utils", "git"]

dpkg_package 'dmd' do
  source '/tmp/dmd.deb'
end

script 'install dub' do
  interpreter "bash"
  user 'root'
  cwd "/tmp"
  code <<-EOH
    tar xvzf /tmp/dub.tar.gz
    cp /tmp/dub /usr/bin/dub
  EOH
  creates "/usr/bin/dub"
end

git '/tmp/reo' do
  repository node[:erln8][:repo_url]
  action :sync
end


script 'compile erln8' do
  interpreter "bash"
  user 'root'
  cwd '/tmp/reo'
  code <<-EOH
    make
    chmod 777 ./erln8
  EOH
end



script 'compile erln8' do
  interpreter "bash"
  user node["erln8"]["username"]
  cwd '/tmp/reo'
  code <<-EOH
    make install
  EOH
end
