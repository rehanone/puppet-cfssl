
class cfssl (
  $download_url   = $cfssl::params::download_url,
  $download_dir   = $cfssl::params::download_dir,
  $install_dir    = $cfssl::params::install_dir,
  $conf_dir       = $cfssl::params::conf_dir,
  $keys_dir       = $cfssl::params::keys_dir,
  $certs_dir      = $cfssl::params::certs_dir,

  $ca_manage      = $cfssl::params::ca_manage,
  $key_algo       = $cfssl::params::key_algo,
  $key_size       = $cfssl::params::key_size,
  $root_ca_id     = $cfssl::params::root_ca_id,
  $root_ca_name   = $cfssl::params::root_ca_name,
  $root_ca_expire = $cfssl::params::root_ca_expire,
  $intermediate_ca_id     = $cfssl::params::intermediate_ca_id,
  $intermediate_ca_name   = $cfssl::params::intermediate_ca_name,
  $intermediate_ca_expire = $cfssl::params::intermediate_ca_expire,
  $country          = $cfssl::params::country,
  $state            = $cfssl::params::state,
  $city             = $cfssl::params::city,
  $organization     = $cfssl::params::organization,
  $org_unit         = $cfssl::params::org_unit,
  $service_manage   = $cfssl::params::service_manage,
  $service_ensure   = $cfssl::params::service_ensure,
  Variant[ Enum['mask', 'manual'], Boolean] $service_enable   = $cfssl::params::service_enable,
  $service_name     = $cfssl::params::service_name,
  $service_address  = $cfssl::params::service_address,
  $service_port     = $cfssl::params::service_port,
  $service_user     = $cfssl::params::service_user,
  $firewall_manage  = $cfssl::params::firewall_manage,
  $allowed_networks = $cfssl::params::allowed_networks,
  $requests         = hiera_hash('cfssl::requests', { }),
) inherits cfssl::params {


  validate_string($download_url)
  validate_string($download_dir)
  validate_string($install_dir)
  validate_absolute_path($conf_dir)
  validate_string($keys_dir)
  validate_string($certs_dir)

  validate_bool($ca_manage)
  validate_string($key_algo)
  validate_integer($key_size)
  validate_string($root_ca_id)
  validate_string($root_ca_name)
  validate_string($root_ca_expire)
  validate_string($intermediate_ca_id)
  validate_string($intermediate_ca_name)
  validate_string($intermediate_ca_expire)
  validate_string($country)
  validate_string($state)
  validate_string($city)
  validate_string($organization)
  validate_string($org_unit)

  validate_bool($service_manage)
  validate_re($service_ensure, [ '^running', '^stopped' ], 'service_ensure parameter must be running or stopped')
  validate_string($service_name)
  validate_string($service_user)
  validate_bool($firewall_manage)
  validate_array($allowed_networks)

  validate_ip_address($service_address)
  validate_integer($service_port)

  validate_hash($requests)

  anchor { "${module_name}::begin": } ->
  class { "${module_name}::install": } ->
  class { "${module_name}::config": } ~>
  class { "${module_name}::service": } ->
  class { "${module_name}::firewall": } ->
  anchor { "${module_name}::end": }
}
