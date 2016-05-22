class cfssl::install inherits cfssl {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  contain wget

  file { $cfssl::download_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  $cfssl::binaries.each |$key, $value| {
    wget::fetch { "${cfssl::download_url}/${value}":
      destination => "${cfssl::download_dir}/${value}",
      verbose     => true,
      mode        => '0755',
      require     => File[ $cfssl::download_dir ],
    }
    ->
    file { "${cfssl::download_dir}/${value}":
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    ->
    file { "${cfssl::install_dir}/${key}":
      ensure => link,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      target => "${cfssl::download_dir}/${value}",
    }
  }
}
