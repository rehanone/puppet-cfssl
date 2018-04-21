# cfssl::install
#
class cfssl::install inherits cfssl {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  file { $cfssl::download_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  if $cfssl::wget_manage {
    require ::wget
  }

  $cfssl::binaries.each |$key, $value| {
    wget::retrieve { "${cfssl::download_url}/${value}":
      destination => "${cfssl::download_dir}/${value}",
      verbose     => true,
      mode        => '0755',
      require     => File[ $cfssl::download_dir ],
    }
    -> file { "${cfssl::download_dir}/${value}":
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    -> file { "${cfssl::install_dir}/${key}":
      ensure => link,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      target => "${cfssl::download_dir}/${value}",
    }
  }
}
