  # Class: cfssl::params
#
class cfssl::params {
  $wget_manage      = true
  $download_url     = 'https://pkg.cfssl.org/R1.2'
  $download_dir     = '/opt/cfssl'
  $install_dir      = '/usr/local/bin'
  $conf_dir         = '/etc/cfssl'
  $keys_dir         = "${conf_dir}/keys"
  $certs_dir        = "${conf_dir}/certs"
  $arch = $::facts['architecture'] ? {
    'i386'  => '386',
    default => 'amd64',
  }
  $binaries   = {
    'cfssl-bundle'    => "cfssl-bundle_linux-${arch}",
    'cfssl-certinfo'  => "cfssl-certinfo_linux-${arch}",
    'cfssl-newkey'    => "cfssl-newkey_linux-${arch}",
    'cfssl-scan'      => "cfssl-scan_linux-${arch}",
    'cfssl'           => "cfssl_linux-${arch}",
    'cfssljson'       => "cfssljson_linux-${arch}",
    'mkbundle'        => "mkbundle_linux-${arch}",
    'multirootca'     => "multirootca_linux-${arch}",
  }

  $ca_manage        = false
  $key_algo         = 'rsa'
  $key_size         = 4096
  $root_ca_id       = 'ca'
  $root_ca_name     = 'My Root CA'
  $root_ca_expire   = '262800h' #30 years (24x356x30)
  $intermediate_ca_id     = 'intermediate-ca'
  $intermediate_ca_name   = 'My Intermediate CA'
  $intermediate_ca_expire = '42720h'
  $country          = 'UK'
  $state            = 'England'
  $city             = 'Leeds'
  $organization     = 'My Company'
  $org_unit         = 'My Unit'

  $service_manage   = $ca_manage
  $service_ensure   = 'running'
  $service_enable   = true
  $service_name     = 'cfssl'
  $service_address  = '127.0.0.1'
  $service_port     = 8888
  $service_user     = 'root'
  $firewall_manage  = false
  $allowed_networks = [ '127.0.0.0/8' ]
}
