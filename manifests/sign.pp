define cfssl::sign (
  $ca_id,
  $csr_file,
  $profile,
) {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  validate_string($ca_id)
  validate_string($csr_file)
  validate_re($profile, [ '^ca', '^server', '^client' ], 'profile parameter must be ca, server or client')

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
