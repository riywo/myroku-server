## v2.0.2:

* [COOK-2109] - lwrp uses incorrect action on underlying file
  resource.

## v2.0.0:

This is a major release because the LWRP's "nopasswd" attribute is
changed from true to false, to match the passwordless attribute in the
attributes file. This requires a change to people's LWRP use.

* [COOK-2085] - Incorrect default value in the sudo LWRP's nopasswd attribute

## v1.3.0:

* [COOK-1892] - Revamp sudo cookbook and LWRP
* [COOK-2022] - add an attribute for setting /etc/sudoers Defaults

## v1.2.2:

* [COOK-1628] - set host in sudo lwrp

## v1.2.0:

* [COOK-1314] - default package action is now :install instead of :upgrade
* [COOK-1549] - Preserve SSH agent credentials upon sudo using an attribute

## v1.1.0:

* [COOK-350] - LWRP to manage sudo files via includedir (/etc/sudoers.d)

## v1.0.2:

* [COOK-903] - freebsd support
