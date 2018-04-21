# cfssl
#

class cfssl (
  Boolean               $wget_manage,
  Stdlib::Httpsurl      $download_url,
  Stdlib::Absolutepath  $download_dir,
  Stdlib::Absolutepath  $install_dir,
  Stdlib::Absolutepath  $conf_dir,
  Stdlib::Absolutepath  $keys_dir,
  Stdlib::Absolutepath  $certs_dir,

  Boolean               $ca_manage,
  Enum[ecdsa, rsa]      $key_algo,
  Integer[0]            $key_size,
  String                $root_ca_id,
  String                $root_ca_name,
  String                $root_ca_expire,
  String                $intermediate_ca_id,
  String                $intermediate_ca_name,
  String                $intermediate_ca_expire,
  String                $country,
  String                $state,
  String                $city,
  String                $organization,
  String                $org_unit,
  Boolean               $service_manage,
  Enum[stopped, running]
                        $service_ensure,
  Variant[Enum[mask, manual], Boolean]
                        $service_enable,
  String                $service_name,
  String                $service_address,
  Integer[0]            $service_port,
  String                $service_user,
  Boolean               $firewall_manage,
  Array[String]         $allowed_networks,
  Hash[String, String]  $binaries,
  Hash                  $requests         = lookup('cfssl::requests', Hash, 'hash', {}),
) {

  anchor { "${module_name}::begin": }
  -> class { "${module_name}::install": }
  -> class { "${module_name}::config": }
  ~> class { "${module_name}::service": }
  -> class { "${module_name}::firewall": }
  -> anchor { "${module_name}::end": }
}
