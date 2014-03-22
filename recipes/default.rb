#new reciepe
require 'socket'
host=Socket.gethostname
node.default["system"]["host"]=host
puts "host: #{host}"

###### Create programs folder in home directory#######
directory "#{node[:home]}#{node[:programs]}" do
  owner "#{node[:system][:owner]}"
  mode "0775"
  recursive true
  action :create
end

directory "#{node[:home]}#{node[:programs]}#{node[:perforce]}" do
  owner "#{node[:system][:owner]}"
  mode "0775"
  recursive true
  action :create
end

directory "#{node[:home]}#{node[:programs]}#{node[:perforce]}/bin" do
  owner "#{node[:system][:owner]}"
  mode "0775"
  recursive true
  action :create
end


cookbook_file "#{node[:home]}#{node[:programs]}#{node[:perforce]}/bin/p4" do
  owner "#{node[:system][:owner]}"
  user "#{node[:system][:owner]}"
  mode "0755"
  source "p4"
end

directory "#{node[:workspace]}" do
  owner "#{node[:system][:owner]}"
  mode "0775"
  recursive true
  action :create
end

puts "home---:#{node[:home]}"
template "#{node[:home]}/.bashrc" do
  owner "#{node[:system][:owner]}"
  user "#{node[:system][:owner]}"
  mode "0644"
  source "bashrc.erb"
  variables(
    :USERHOME => node[:home],
    :P4PORT => node[:p4settings][:P4PORT],
    :P4USER => node[:p4settings][:P4USER],
    :P4CLIENT => node[:p4settings][:P4CLIENT],
  )
end

puts "picking p4client_spec"

  template "#{node[:workspace]}/p4client.txt" do
  owner "#{node[:system][:owner]}"
  user "#{node[:system][:owner]}"
  mode "0644"
  source "p4client_spec.erb"
  variables(
    :P4CLIENT => node[:p4settings][:P4CLIENT],
    :WORKSPACE => "#{node[:workspace]}",
    :P4USER => node[:p4settings][:P4USER],
    :HOST => "#{node[:system][:host]}",
  )
end
