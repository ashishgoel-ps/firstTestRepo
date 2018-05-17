#
# Cookbook:: jenkins
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.warn('The jenkins::java recipe has been deprecated. We recommend adding the Java coobook to the runlist of your jenkins node instead as it provides more tuneables')

case node['platform_family']
when 'debian'
  package 'openjdk-8-jdk'
when 'rhel'
  package 'java-1.8.0-openjdk'
else
  raise "`#{node['platform_family']}' is not supported!"
end

# execute 'update' do
#   command 'wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo'
#   action :run
# end

case node['platform_family']
when 'rhel'
remote_file '/etc/yum.repos.d/jenkins.repo' do
  source 'http://pkg.jenkins-ci.org/redhat/jenkins.repo'
  owner 'root'
  group 'root'
  #  checksum 'abc123'
end
execute 'import_rpm' do
  command 'rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key'
  action :run
end
package 'jenkins' do
  # version node['jenkins']['master']['version']
  action :install
end
service 'jenkins' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

when 'debian'
remote_file '/etc/yum.repos.d/jenkins.repo' do
  source 'https://pkg.jenkins.io/debian binary/'
  owner 'root'
  group 'root'
  #  checksum 'abc123'
end
execute 'import_rpm' do
  command 'rpm --import https://pkg.jenkins.io/debian/jenkins.io.key'
  action :run
end
package 'jenkins' do
  # version node['jenkins']['master']['version']
  action :install
end
service 'jenkins' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
else
  raise "`#{node['platform_family']}' is not supported!"
end
