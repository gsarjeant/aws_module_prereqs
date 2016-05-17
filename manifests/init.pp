# Class: aws_module_prereqs
# ===========================
#
# This module manages the items that must be in place in order to use the puppetlabs/aws
# module to manage your AWS infrastructure. These items are:
#
# - gem dependencies
#   - aws-sdk-core
#   - retries
# - AWS credentials file
#   - root's ~/.aws/credentials
#
# Parameters
# ----------
#
# NOTE: These values will allow anyone who can see them to use your AWS credentials to create AWS resources.
#       They will appear in any catalogs and reports for puppet runs that set them.
#       Please don't store these credentials in hiera or define them in puppet code 
#       in a publicly accessible location like github.
#
# $aws_access_key_id       - the access key ID that you use for programmatic access to AWS
# $aws_secret_access_key   - the access key that you use for programmatic access to AWS
# $aws_user                - the user that will be invoking AWS commands
#                            default: root
# $aws_user_primary_group  - the primary group of the user that will be invoking aws commands
#                            default: root
# $aws_user_home_directory - the home directory of the user that will be invoking AWS commands
#                            default: /root/
#
# Examples
# --------
#
# @example
#    class { 'aws_module_prereqs':
#      aws_access_key_id     => YOUR_AWS_ACCESS_KEY_ID,
#      aws_secret_access_key => YOUR_AWS_SECRET_ACCESS_KEY
#    }
#
# Authors
# -------
#
# Author Name Greg Sarjeant
#
# Copyright
# ---------
#
# Copyright 2016 Greg Sarjeant, unless otherwise noted.
#
class aws_module_prereqs (
  $aws_access_key_id,
  $aws_secret_access_key,
  $aws_user = 'root',
  $aws_user_primary_group = 'root',
  $aws_user_home_directory = '/root/'
){

  # ruby gems required by the aws module
  package { 'ruby_gem_aws-sdk-core':
    name     => 'aws-sdk-core',
    ensure   => present,
    provider => 'puppet_gem',
  }

  package { 'ruby_gem_retries':
    name     => 'retries',
    ensure   => present,
    provider => 'puppet_gem',
  }

  # aws credentials file
  $aws_credentials_directory = "${aws_user_home_directory}/.aws"

  file { $aws_credentials_directory:
    ensure => directory,
    owner  => $aws_user,
    group  => $aws_user_primary_group,
    mode   => '0700',
  }

  file { "${aws_credentials_directory}/credentials":
    ensure  => file,
    owner   => $aws_user,
    group   => $aws_user_primary_group,
    mode    => 0400,
    content => template('credentials.erb'),
  }
}
