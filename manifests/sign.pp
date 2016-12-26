define cfssl::sign (
  String  $ca_id,
  String  $csr_file,
  Enum[ca, server, client]
          $profile,
) {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  exec { "sign-${title}":
    command   => "cfssl sign -profile ${profile} -ca ${cfssl::conf_dir}/${ca_id}.pem -ca-key ${cfssl::conf_dir}/${ca_id}-key.pem -config signing.json ${csr_file} | cfssljson -bare ${title}",
    cwd       => $cfssl::conf_dir,
    creates   => [ "${cfssl::conf_dir}/${title}.pem" ],
    provider  => shell,
    path      => [ $cfssl::install_dir ],
    timeout   => 0,
    logoutput => true,
    require   => Cfssl::Ca[$ca_id],
  }
}
