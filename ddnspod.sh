#!/bin/bash
#

# Import ardnspod functions
. /your_real_path/ardnspod

# Combine your token ID and token together as follows
arToken="12345,7676f344eaeaea9074c123451234512d"

# Place each domain you want to check as follows
# you can have multiple arDdnsCheck blocks

# IPv4:
arDdnsCheck "test.org" "subdomain"

# IPv6:
arDdnsCheck "test.org" "subdomain6" 6
