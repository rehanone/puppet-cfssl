## 1.2.1 (November 25, 2017)

Improvements:

  - Added support for Puppet 5.

## 1.2.0 (June 11, 2017)

Improvements:

  - Replace deprecated `hiera_hash` to `lookup`.
  - Update minimum puppet version required is set to `4.7.0`.

## 1.1.1 (May 14, 2017)

Features:

  - Improved test coverage.

Bugfixes:

  - Fix the style issues in chaining arrows.

## 1.1.0 (March 25, 2017)

Bugfixes:

  - Correct detection and support for System V based init service provider in RHEL 6 (Contributed by [Lucas Emery](https://github.com/bt-lemery)).
  - Remove support for RedHat, CentOS and Scientific Linux version 5.
  - Updated [rehan-wget](https://forge.puppet.com/rehan/wget) dependency version.

## 1.0.0 (December 26, 2016)

Features:

  - Add support for RedHat, CentOS and Scientific Linux from version 5 to 7.
  - Introduce proper Puppet 4 types for parameters.
  - Remove legacy validate statements of puppet-stdlib module.
  - Increased unit and acceptance tests coverage.
  - Change `wget` dependency from [maestrodev-wget](https://forge.puppet.com/maestrodev/wget) to [rehan-wget](https://forge.puppet.com/rehan/wget)

## 0.1.0 (May 21, 2016)

Features:

  - Initial release


