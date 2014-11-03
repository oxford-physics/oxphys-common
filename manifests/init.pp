class common {
   $package_list = [ "screen", "vim-enhanced", "strace", "mlocate", "tree", "ntp", "augeas" ,"telnet","ruby-json", "ipmitool", "jwhois"]
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
  
    file { '/etc/ntp.conf':
    ensure  => present,
    mode       => '0644',
    owner   => 'root',
    group   => 'root',
    source => "puppet:///modules/common/ntp.conf",
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
