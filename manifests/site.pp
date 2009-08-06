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
import 'nagios'
import 'ssh'

#######################################################################
##  Nodes  ############################################################
#######################################################################

node default
{
	# all hosts should have the munin agent installed
	include munin::client

	# watch all hosts
	include nagios::target

	# every host should be reachable by ssh
	# this is automatically checked with nagios
	include ssh::server
}

node 'monitoring' inherits default
{
	# this host gathers munin statistics
	include munin::host

	# co-host nagios monitoring
	include nagios

	# install apache
	include apache

	# host the munin site on 'munin.example.com'
	# and check it with nagios
	$munin_virtual_host = "munin.example.com"
	munin::apache_site { $munin_virtual_host: }
	nagios::service {
		"monitor-www":
			check_command => "check_http2!${munin_virtual_host}!0.1!0.2"
	}
}

