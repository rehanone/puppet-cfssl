class cfssl::config () inherits cfssl {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  file { $cfssl::conf_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  if $cfssl::ca_manage {
    cfssl::ca { $cfssl::root_ca_id:
      common_name => $cfssl::root_ca_name,
      ca_expire   => $cfssl::root_ca_expire,
      require     => File[$cfssl::conf_dir],
    }
    ->
    cfssl::ca { $cfssl::intermediate_ca_id:
      common_name => $cfssl::intermediate_ca_name,
      ca_expire   => $cfssl::intermediate_ca_expire,
    }
    ->
    file { "${cfssl::conf_dir}/signing.json":
      ensure => file,
      source => "puppet:///modules/${module_name}/signing.json",
    }
    ->
    cfssl::sign { "${cfssl::intermediate_ca_id}-signed":
      ca_id    => $cfssl::root_ca_id,
      csr_file => "${cfssl::conf_dir}/${cfssl::intermediate_ca_id}.csr",
      profile  => 'ca',
    }
    ->
    exec { 'intermediate-ca-to-ca-chain':
      command   => "cat ${cfssl::intermediate_ca_id}-signed.pem ${cfssl::root_ca_id}.pem > ${cfssl::conf_dir}/chain.pem",
      cwd       => $cfssl::conf_dir,
      creates   => [ "${cfssl::conf_dir}/chain.pem" ],
      provider  => shell,
      path      => ['/sbin', '/bin'],
      timeout   => 0,
      logoutput => true,
    }
  }

  create_resources('cfssl::certificate_request', $cfssl::requests)
}
