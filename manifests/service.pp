# cfssl::service
#
class cfssl::service () inherits cfssl {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  $service_provider = $facts['service_provider'] ? {
    'debian' => 'systemd',
    default  => $facts['service_provider'],
  }

  if $cfssl::service_manage {

    $service_attributes = {
      'conf_dir'           => $cfssl::conf_dir,
      'install_dir'        => $cfssl::install_dir,
      'service_user'       => $cfssl::service_user,
      'service_address'    => $cfssl::service_address,
      'service_port'       => $cfssl::service_port,
      'intermediate_ca_id' => $cfssl::intermediate_ca_id,
    }

    case $service_provider {
      'upstart': {
        file { "add-${cfssl::service_name}-conf":
          ensure  => file,
          path    => "/etc/init/${cfssl::service_name}.conf",
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => epp("${module_name}/service/upstart/cfssl.conf.epp", $service_attributes),
        }
      }
      'systemd', 'debian': {
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
          content => epp("${module_name}/service/systemd/cfssl.service.epp", $service_attributes),
        }
      }
      'redhat': {
        file { "add-${cfssl::service_name}-conf":
          ensure  => file,
          path    => "/etc/rc.d/init.d/${cfssl::service_name}",
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => epp("${module_name}/service/redhat/cfssl.epp", $service_attributes),
        }
      }
      default: {}
    }

    service { $cfssl::service_name:
      ensure    => $cfssl::service_ensure,
      enable    => $cfssl::service_enable,
      name      => $cfssl::service_name,
      provider  => $service_provider,
      subscribe => [
        Class["${module_name}::config"],
        File["add-${cfssl::service_name}-conf"]
      ],
    }
  }
}
