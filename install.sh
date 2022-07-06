#!/bin/sh
#
mkdir /root/myddns
rm -f /root/myddns/*
wget -P /root/myddns/ https://cdn.jsdelivr.net/gh/Howardnm/dnspod-shell@master/ardnspod
wget -P /root/myddns/ https://cdn.jsdelivr.net/gh/Howardnm/dnspod-shell@master/ddnspod.sh
wget -P /root/myddns/ https://cdn.jsdelivr.net/gh/Howardnm/dnspod-shell@master/myddns.sh
echo "安装完成"
rm -- "$0"
