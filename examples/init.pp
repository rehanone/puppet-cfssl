node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'cfssl':
    ca_manage => true,
    require   => Notify['enduser-before'],
    before    => Notify['enduser-after'],
  }
}
