define cfssl::certificate_request (
  $profile,
  $hosts,
  $remote_address,
  $remote_port    = $cfssl::service_port,
  $common_name    = $title,
  $key_algo       = $cfssl::key_algo,
  $key_size       = $cfssl::key_size,
  $country        = $cfssl::country,
  $state          = $cfssl::state,
  $city           = $cfssl::city,
  $organization   = $cfssl::organization,
  $org_unit       = $cfssl::org_unit,
) {

  validate_string($common_name)
  validate_string($key_algo)
  validate_string($key_size)
  validate_string($country)
  validate_string($state)
  validate_string($city)
  validate_string($organization)
  validate_string($org_unit)

  validate_integer($remote_port)
  validate_string($remote_address)
  validate_re($profile, [ '^ca', '^server', '^client' ], 'profile parameter must be ca, server or client')
  validate_array($hosts)

  file { "${cfssl::conf_dir}/${common_name}-csr.json":
    ensure  => present,
    content => template("${module_name}/ca-csr.json.erb"),
  }

  exec { "req-${common_name}":
  command     => "cfssl gencert -remote ${remote_address}:${remote_port} -profile ${profile} -hostname ${hosts.join(',')} ${cfssl::conf_dir}/${common_name}-csr.json | cfssljson -bare ${common_name}",
  cwd         => $cfssl::conf_dir,
  creates     => [ "${cfssl::conf_dir}/${common_name}.pem", "${cfssl::conf_dir}/${common_name}.csr", "${cfssl::conf_dir}/${common_name}-key.pem" ],
  provider    => shell,
  path        => [ $cfssl::install_dir ],
  timeout     => 0,
  logoutput   => true,
  subscribe   => File["${cfssl::conf_dir}/${common_name}-csr.json"],
  refreshonly => true,
  }
}
