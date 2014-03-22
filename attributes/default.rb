default[:home] = "/home/username"

default[:system][:user] = "username"
default[:system][:owner] = "username"
default[:system][:email] = "your-email@domain.com"

default[:p4settings][:P4USER] = "ldapusername"
default[:p4settings][:P4PORT] = "*****"
default[:p4settings][:P4MERGE] = "/usr/bin/p4merge"


default[:ldap][:LDAP_USER] = "ldapusername"
default[:ldap][:LDAP_PASSWD] = "your-ldap-password"

default[:temp] = "/Temp"
default[:binaries_folder] = "/workarea/softwares"
default[:binaries_sqat_folder] = "/workarea/chef/softwares"
default[:binaries_java] = "/jdk1.7.0/bin"
default[:workspace] = "define your workspace full path"
default[:seleniumserver] = "/SeleniumServer"
default[:programs] = "/programs"
default[:perforce] = "/perforce"
default[:build_chef] = ".chef"
default[:binaries][:perforce] = "p4v.tgz"
