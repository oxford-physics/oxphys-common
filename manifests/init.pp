class common (
   $ntpservers = hiera("common::ntpservers", ["ntp0.physics.ox.ac.uk", "ntp1.physics.ox.ac.uk", "ntp1.oucs.ox.ac.uk" ])
)
 {
#   $package_list = [ "screen", "vim-enhanced", "strace", "mlocate", "tree", "ntp", "augeas" ,"telnet","ruby-json", "ipmitool", "jwhois" , "iperf" ]
#  XXX Remove ruby-json as it doesn't exist on EL7 - Ewan 20150625
   $package_list = [ "screen", "vim-enhanced", "strace", "mlocate", "tree", "ntp", "augeas" ,"telnet", "ipmitool", "jwhois" , "iperf" ]
   package { $package_list : ensure => installed, tag=>"basepackage"}
   
#   ensure_packages ( ['perf'] )
       
    file { '/etc/puppet/puppet.conf':
    ensure  => present,
    mode       => '0644',
    owner   => 'root',
    group   => 'root',
    source => "puppet:///modules/common/puppet.conf",
     }
     
#    service { "puppet":
#    name   => 'puppet',
#    ensure     => running,
#    enable     => true,
#    hasrestart => true,
#    hasstatus  => true,
#    subscribe  => File['/etc/puppet/puppet.conf'], 
#     }
  
    file { '/root/.vimrc':
    ensure  => present,
    mode       => '0644',
    owner   => 'root',
    group   => 'root',
    source => "puppet:///modules/common/vimrc",
     }

    file { '/etc/ntp.conf':
    ensure  => present,
    mode       => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("common/ntp.conf.erb"),
    require => Package['ntp'],
     }
   
    service { "ntpd":
    name   => 'ntpd',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => [ File['/etc/ntp.conf'], Package["ntp"] ],
    require    => Package [ "ntp" ],
     }
}
