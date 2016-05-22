define cfssl::ca (
  $ensure       = present,
  $common_name  = $name,
  $key_algo     = $cfssl::key_algo,
  $key_size     = $cfssl::key_size,
  $ca_expire    = $cfssl::root_ca_expire,
  $country      = $cfssl::country,
  $state        = $cfssl::state,
  $city         = $cfssl::city,
  $organization = $cfssl::organization,
  $org_unit     = $cfssl::org_unit,
) {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  validate_string($common_name)
  validate_string($key_algo)
  validate_string($key_size)
  validate_string($ca_expire)
  validate_string($country)
  validate_string($state)
  validate_string($city)
  validate_string($organization)
  validate_string($org_unit)

  file { "${cfssl::conf_dir}/${title}-csr.json":
    ensure  => $ensure,
    content => template("${module_name}/ca-csr.json.erb"),
  }

  if $ensure == present {
    # This also creates the "${cfssl::conf_dir}/${title}-key.pem" file which can be moved off to a scure location and that is why it is not checked
    exec { "ca-build-${title}":
      command     => "cfssl gencert -initca ${cfssl::conf_dir}/${title}-csr.json | cfssljson -bare ${title}",
      cwd         => $cfssl::conf_dir,
      creates     => [ "${cfssl::conf_dir}/${title}.pem", "${cfssl::conf_dir}/${title}.csr" ],
      provider    => shell,
      path        => [ $cfssl::install_dir ],
      timeout     => 0,
      logoutput   => true,
      subscribe   => File["${cfssl::conf_dir}/${title}-csr.json"],
      refreshonly => true,
    }
  }
}
