# Class: htcondor::repositories
#
# Provides yum repositories for HTCondor installation
class htcondor::repositories (
  $install_repos   = true,
  $dev_repos       = false,
  $condor_priority = '99',) {

  $major_release = regsubst($::operatingsystemrelease, '^(\d+)\.\d+$', '\1')

  case $::osfamily {
    'RedHat'  : {
      if $dev_repos {
        yumrepo { 'htcondor-development':
          descr    => "HTCondor Development RPM Repository for Redhat Enterprise Linux ${major_release}",
          baseurl  => "http://research.cs.wisc.edu/htcondor/yum/development/rhel${major_release}",
          enabled  => 1,
          gpgcheck => 0,
          priority => "${condor_priority}",
          exclude  => 'condor.i386, condor.i686',
          before   => [Package['condor']],
        }
      } else {
        yumrepo { 'htcondor-stable':
          descr    => "HTCondor Stable RPM Repository for Redhat Enterprise Linux ${major_release}",
          baseurl  => "http://research.cs.wisc.edu/htcondor/yum/stable/rhel${major_release}",
          enabled  => 1,
          gpgcheck => 0,
          priority => "${condor_priority}",
          exclude  => 'condor.i386, condor.i686',
          before   => [Package['condor']],
        }
      }
    }
    'Debian'  : {
      case $::operatingsystem {
        'ubuntu': {
          notify { 'Ubuntu systems should manually install package and disable `install_repositories` and `install_package`': }
        }
        # http://research.cs.wisc.edu/htcondor/debian/
        'debian': {
          notify { 'Debian systems should manually install package and disable `install_repositories` and `install_package`': }
        }
        default: {
          notify { 'Debian based systems outside of Debian and Ubuntu are currently not supported': }
        }
      }
    }
    'Windows' : {
      # http://research.cs.wisc.edu/htcondor/manual/v8.0/3_2Installation.html#SECTION00425000000000000000
      notify { 'Windows based systems currently not supported': }
    }
    default   : {
      $osfamily = $::osfamily

      notify { "OS family '${osfamily}' not recognised": }
    }
  }


}
