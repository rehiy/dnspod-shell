#!/bin/sh

cd "$(dirname "$0")"

# Import ardnspod functions
. ardnspod

# Combine your token ID and token together as follows

arToken="12345,7676f344eaeaea9074c123451234512d"

# Web endpoint to be used for querying the public IPv6 address
# Set this to override the default url provided by ardnspod

arIp4QueryUrl="http://ipv4.rehi.org/ip"
arIp6QueryUrl="http://ipv6.rehi.org/ip"

# The temp file to store the last record ip

arLastRecordFile=/tmp/ardnspod_last_record

# Return code when the last record IP is same as current host IP
# Set this to a value other than 0 to distinguish with a successful ddns update

arErrCodeUnchanged=0

# Place each domain you want to check as follows
# you can have multiple arDdnsCheck blocks

# IPv4:
arDdnsCheck "test.org" "subdomain"

# IPv6:
arDdnsCheck "test.org" "subdomain6" 6
