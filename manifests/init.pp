
class cfssl (
  Boolean               $wget_manage    = $cfssl::params::wget_manage,
  Stdlib::Httpsurl      $download_url   = $cfssl::params::download_url,
  Stdlib::Absolutepath  $download_dir   = $cfssl::params::download_dir,
  Stdlib::Absolutepath  $install_dir    = $cfssl::params::install_dir,
  Stdlib::Absolutepath  $conf_dir       = $cfssl::params::conf_dir,
  Stdlib::Absolutepath  $keys_dir       = $cfssl::params::keys_dir,
  Stdlib::Absolutepath  $certs_dir      = $cfssl::params::certs_dir,

  Boolean               $ca_manage      = $cfssl::params::ca_manage,
  Enum[ecdsa, rsa]      $key_algo       = $cfssl::params::key_algo,
  Integer[0]            $key_size       = $cfssl::params::key_size,
  String                $root_ca_id     = $cfssl::params::root_ca_id,
  String                $root_ca_name   = $cfssl::params::root_ca_name,
  String                $root_ca_expire = $cfssl::params::root_ca_expire,
  String                $intermediate_ca_id     = $cfssl::params::intermediate_ca_id,
  String                $intermediate_ca_name   = $cfssl::params::intermediate_ca_name,
  String                $intermediate_ca_expire = $cfssl::params::intermediate_ca_expire,
  String                $country          = $cfssl::params::country,
  String                $state            = $cfssl::params::state,
  String                $city             = $cfssl::params::city,
  String                $organization     = $cfssl::params::organization,
  String                $org_unit         = $cfssl::params::org_unit,
  Boolean               $service_manage   = $cfssl::params::service_manage,
  Enum[stopped, running]
                        $service_ensure   = $cfssl::params::service_ensure,
  Variant[Enum[mask, manual], Boolean]
                        $service_enable   = $cfssl::params::service_enable,
  String                $service_name     = $cfssl::params::service_name,
  String                $service_address  = $cfssl::params::service_address,
  Integer[0]            $service_port     = $cfssl::params::service_port,
  String                $service_user     = $cfssl::params::service_user,
  Boolean               $firewall_manage  = $cfssl::params::firewall_manage,
  Array[String]         $allowed_networks = $cfssl::params::allowed_networks,
  Hash                  $requests         = hiera_hash('cfssl::requests', {}),
) inherits cfssl::params {

  anchor { "${module_name}::begin": } ->
    class { "${module_name}::install": } ->
    class { "${module_name}::config": } ~>
    class { "${module_name}::service": } ->
    class { "${module_name}::firewall": } ->
  anchor { "${module_name}::end": }
}
