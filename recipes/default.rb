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

ruby_block "p4login" do
 block do
  require "P4"
  p4 = P4.new
  p4.port="#{node[:p4settings][:P4PORT]}"
  p4.user="#{node[:p4settings][:P4USER]}"
  password=''
  File.open("#{node[:home]}/.p4passwd").each{|line| password << line}
  p4.password = password
  p4.connect
  p4.run_login
  text=''
  File.open("#{node[:workspace]}/p4client.txt").each { |line| text << line }
  p4.input=text
  p4.run_client("-i")
  p4.client="#{node[:p4settings][:P4CLIENT]}"
  begin
   p4.run_sync
  rescue => e
   puts e
  end

 end
end

script "copy p4 ticket" do
interpreter "bash"
code <<-EOH
cp /root/.p4tickets /home/sqat/.p4tickets
EOH
end
