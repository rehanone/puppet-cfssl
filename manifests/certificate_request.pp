define cfssl::certificate_request (
  Enum[ca, server, client] $profile,
  Array[String]            $hosts,
  String                   $remote_address,
  Integer[0]               $remote_port    = $cfssl::service_port,
  String                   $common_name    = $title,
  Enum[ecdsa, rsa]         $key_algo       = $cfssl::key_algo,
  Integer[0]               $key_size       = $cfssl::key_size,
  String[2]                $country        = $cfssl::country,
  String                   $state          = $cfssl::state,
  String                   $city           = $cfssl::city,
  String                   $organization   = $cfssl::organization,
  String                   $org_unit       = $cfssl::org_unit,
) {

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
