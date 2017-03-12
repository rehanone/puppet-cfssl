class cfssl::service () inherits cfssl {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if $cfssl::service_manage {

    case $::service_provider {
      'upstart': {
        file { "add-${cfssl::service_name}-conf":
          ensure  => file,
          path    => "/etc/init/${cfssl::service_name}.conf",
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => template("${module_name}/service/upstart/cfssl.conf.erb"),
        }
      }
      'systemd': {
        file { "remove-${cfssl::service_name}-conf":
          ensure => absent,
          path   => "/etc/init/${cfssl::service_name}.conf",
        }

        file { "add-${cfssl::service_name}-conf":
          ensure  => file,
          path    => "/etc/systemd/system/${cfssl::service_name}.service",
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => template("${module_name}/service/systemd/cfssl.service.erb"),
        }
      }
      'redhat': {
        file { "add-${cfssl::service_name}-conf":
          ensure  => file,
          path    => "/etc/rc.d/init.d/${cfssl::service_name}",
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => template("${module_name}/service/redhat/cfssl.erb"),
        }
      }
      default: { }
    }

    service { $cfssl::service_name:
      ensure    => $cfssl::service_ensure,
      enable    => $cfssl::service_enable,
      name      => $cfssl::service_name,
      provider  => $::service_provider,
      subscribe => [
        Class["${module_name}::config"],
        File["add-${cfssl::service_name}-conf"]
      ],
    }
  }
}
