# rehan-cfssl

[![Build Status](https://travis-ci.org/rehanone/puppet-cfssl.svg?branch=master)](https://travis-ci.org/rehanone/puppet-cfssl)

#### Table of Contents
1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
    * [Classes](#classes)
    * [Referances](#referances)
5. [Dependencies](#dependencies)
6. [Development](#development)

## Overview
The `rehan-cfssl` module for installing, managing and generating SSL certificates using CloudFlare's PKI toolkit - CFSSL.

## Module Description
A puppet module for managing the installation and configuration of CloudFlare's PKI toolkit. This module installs and 
configures CFSSL as a service so clients can request certificates from the local PKI server.

CFSS is not the easiest toolkit to understand and work with. The main reason is lack of proper documentation. However, 
more information on it is available at:

  - [cfssl.org](https://cfssl.org/ "cfssl.org")

#### Implemented Features:
* Installs cfssl binaries to /opt/cfssl and creates links under /usr/local/bin
* Can be configured to become a PKI server in which case it will generate Root and Intermediate CA certificates.
* Sets up PKI service that clients on the network can use to request certificates.
* If `puppetlabs-firewall` module is used, this module can setup proper rules for opening local port for the PKI server.

#### Features not yet updated
* Allow multiple Intermediate CA certificates.

## Setup
In order to install `rehan-cfssl`, run the following command:
```bash
$ sudo puppet module install rehan-cfssl
```
The module does expect all the data to be provided through 'Hiera'. See [Usage](#usage) for examples on how to configure it.

#### Requirements
This module is designed to be as clean and compliant with latest puppet code guidelines. It works with:

  - `puppet >=4.0.0`

## Usage

### Classes

#### `cfssl`

A basic install with the defaults would be:
```puppet
include cfssl
```

Or the PKI Server using the parameters:
```puppet
class{ 'cfssl':
  ca_manage       => true,
  service_port    => 8888,
  service_address => '10.20.30.40',
}
```

##### Parameters

* **download_url**: Download URL for cfssl binaries, the default is https://pkg.cfssl.org/R1.2.
* **download_dir**: Download loaction for cfssl binaries. The default value `/opt/cfssl`.
* **install_dir**: Install location for cfssl binaries. The default is `/usr/local/bin`.
* **conf_dir**: Root directory for cfssl configuration and certificate creation. The default is `/etc/cfssl`.
* **ca_manage**: Controls the generation of Root and Intermediate CA certificates that allow the system to serve as a PKI server. The default is `false`.
* **key_algo**: The key algorithm to use, the possible values are `rsa` or `ecdsa`. The default is `rsa`.
* **key_size**: The key size to use for certificate creation. The default is `4096`.
* **root_ca_name**: The name for the Root CA. The default is `My Root CA`.     
* **root_ca_expire**: Time in hours for the CA to expire. The default is `262800h` (30 years).     
* **intermediate_ca_name**: The name for the Intermediate CA. The default is `My Intermediate CA`.     
* **intermediate_ca_expire**: Time in hours for the CA to expire. The default is `42720h`.     
* **service_manage**: Controls if the service will be created to generate certificates on a CA server. The default is same as`ca_manage`.
* **service_ensure**: Controls the status of the service. The default is `running`.
* **service_enable**: Enables or disables the service. the default is `true`.
* **service_name**: Name of the service. the default is `cfssl`.
* **service_address**: The service bind address. the default is `127.0.0.1`.
* **service_port**: The service port. the default is `8888`.
* **service_user**: The service user. the default is `root`.
* **firewall_manage**: Controls the firewall if it is managed by puppet. The default is `false`.
* **allowed_networks**: Array of networks that are allowd to access service through the firewall. The default is `'127.0.0.0/8'`.
* **requests**: A hash of certificate requests, see `cfssl::certificate_request` for more details.


All of this data can be provided through `Hiera`. 

##### For PKI Server


**YAML**
```yaml
---
cfssl::ca_manage: true
cfssl::root_ca_name: 'Root Authority X1'
cfssl::intermediate_ca_name: "Intermediate Authority X2"
cfssl::country: 'UK'
cfssl::state: 'England'
cfssl::city: 'Dewsbury'
cfssl::organization: 'Corp'
cfssl::org_unit: 'NetLink'
cfssl::service_manage: true
cfssl::service_ensure: 'running'
cfssl::service_enable: 'true'
cfssl::service_port: 8888
cfssl::service_address: '10.20.30.40'
cfssl::firewall_manage: true
cfssl::allowed_networks:
  - '127.0.0.0/8'
  - '10.0.0.0/8'
```

##### For PKI Client


**YAML**
```yaml
---
cfssl::ca_manage: false
cfssl::requests:
  'example.com':
    remote_port: 8888
    remote_address: '10.20.30.40'
    profile: 'server'
    hosts: ['example.com', 'www.example.com']
    key_algo: 'rsa'
    key_size: '2048'
    country: 'UK'
    state: 'England'
    city: 'Leeds'
    organization: 'Corp'
    org_unit: 'NetLink'
```

### Resources

#### `cfssl::certificate_request`

This resource creates a request for a certificate that will be signed by the remote PKI server.

Usage:
```puppet
cfssl::certificate_request { 'example.com':
 remote_port    => 8888,
 remote_address => '10.20.30.40',
 profile        => 'server',
 hosts          => ['example.com', 'www.example.com'],
 key_algo       => 'rsa',
 key_size       => '2048',
 country        => 'UK',
 state          => 'England',
 city           => 'Leeds',
 organization   => 'Corp',
 org_unit       => 'NetLink',
}
```

##### Parameters

* **common_name** Common Name for the certficate, the default is `$title`.
* **hosts** Alternative host names for this certficate.

## Dependencies

* [stdlib][1]
* [archive][2]

[1]:https://forge.puppet.com/puppetlabs/stdlib
[2]:https://forge.puppet.com/puppet/archive

## Development

You can submit pull requests and create issues through the official page of this module: https://github.com/rehan/puppet-cfssl.
Please do report any bug and suggest new features/improvements.
