class cfssl::install inherits cfssl {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  file { $cfssl::download_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  if ! defined(Package['wget']) {
    ensure_packages(['wget'])
  }

  contain ::archive

  $cfssl::binaries.each |$key, $value| {
    archive { "${cfssl::download_dir}/${value}":
      ensure       => present,
      extract      => false,
      extract_path => $cfssl::download_dir,
      source       => "${cfssl::download_url}/${value}",
      creates      => "${cfssl::download_dir}/${value}",
      require      => [ File[ $cfssl::download_dir ], Package['wget'] ],
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
