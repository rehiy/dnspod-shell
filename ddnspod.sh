#!/bin/sh
#

# Import ardnspod functions
. /your_real_path/ardnspod

# Combine your token ID and token together as follows
arToken="12345,7676f344eaeaea9074c123451234512d"

# Place each domain you want to check as follows
# you can have multiple arDdnsCheck blocks
# add 4 or 6 to tail will specify the IP version used, default 4
# IPv6:
#   arDdnsCheck "test.org" "subdomain6" 6
arDdnsCheck "test.org" "subdomain"
