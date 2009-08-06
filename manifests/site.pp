# necessary defaults
Exec { path => "/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin" }

# Default backup
File { backup => server }

# allow munin access from the central munin server
$munin_cidr_allow = [ '127.0.0.1/32' ]

# import common module first to get all variables to the other modules
import 'common'

# import all other modules
import 'munin'

#######################################################################
##  Nodes  ############################################################
#######################################################################

node default
{
	include munin::client
}

node 'munin'
{
	include munin::host
}

