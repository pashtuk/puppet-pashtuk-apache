class pashtuk_apache (
	$vhost,
	$docroot,
	$source_repo,
	)
{
# Include the apache class to install the packages etc.
	class{'apache':}

# Define a name based VirtualHost
apache::vhost { $vhost:
	port	=> '80',
	docroot	=> $docroot,
	}

# Install the git package for vcsrepo
package{'git':
	ensure	=> present,
	}

# Clone the site content into place
vcsrepo { $docroot:
	owner	=> 'apache',
	group	=> 'apache',
	provier	=> git,
	source	=> $source_repo,
	}

# Ensure things fire off in correct order
Class['apache'] -> Apache::Vhost[$vhost] -> Vcsrepo[$docroot]
Package['git'] -> Vcsrepo[$docroot]
}