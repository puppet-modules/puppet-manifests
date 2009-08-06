# necessary defaults
Exec { path => "/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin" }

# Default backup
File { backup => server }

# allow munin access from the central munin server
$munin_cidr_allow = [ '127.0.0.1/32' ]

# import common module first to get all variables to the other modules
import 'common'

# import all other modules
import 'apache'
import 'munin'
import 'ssh'

#######################################################################
##  Nodes  ############################################################
#######################################################################

node default
{
	# all hosts should have the munin agent installed
	include munin::client

	# every host should be reachable by ssh
	include ssh::server
}

node 'munin' inherits default
{
	# this host gathers munin statistics
	include munin::host

	# install apache, hosting the munin site on 'munin.example.com'
	include apache
	munin::apache_site { 'munin.example.com': }
}

