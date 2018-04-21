# cfssl::ca
#
define cfssl::ca (
  String  $ensure       = present,
  String  $common_name  = $name,
  String  $key_algo     = $cfssl::key_algo,
  Integer $key_size     = $cfssl::key_size,
  String  $ca_expire    = $cfssl::root_ca_expire,
  String  $country      = $cfssl::country,
  String  $state        = $cfssl::state,
  String  $city         = $cfssl::city,
  String  $organization = $cfssl::organization,
  String  $org_unit     = $cfssl::org_unit,
) {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  file { "${cfssl::conf_dir}/${title}-csr.json":
    ensure  => $ensure,
    content => epp("${module_name}/ca-csr.json.epp",
      {
        'key_algo'     => $key_algo,
        'key_size'     => $key_size,
        'common_name'  => $common_name,
        'country'      => $country,
        'state'        => $state,
        'city'         => $city,
        'organization' => $organization,
        'org_unit'     => $org_unit,
        'ca_expire'    => $ca_expire,
      }),
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
