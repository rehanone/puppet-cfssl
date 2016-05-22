class cfssl::firewall () inherits cfssl {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if $cfssl::firewall_manage and defined('::firewall') {
    $cfssl::allowed_networks.each |$network| {
      firewall { "${cfssl::service_port} Allow inbound CFSSL connection on port: ${cfssl::service_port} from: ${network}":
        dport  => $cfssl::service_port,
        source => $network,
        proto  => tcp,
        action => accept,
      }
    }
  }
}
