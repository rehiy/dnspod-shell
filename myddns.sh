#!/bin/sh
#

run_dnspod() {
    get_ipv6
    # Import ardnspod functions
    . /root/myddns/ardnspod

    # Combine your token ID and token together as follows
    arToken="$DNSpod_ID,$DNSpod_Token"

    # Place each domain you want to check as follows
    # you can have multiple arDdnsCheck blocks

    # IPv6:
    mac_ipv6="$mac_ipv6"
    # arDdnsCheck "test.org" "subdomain6" 6
    #              "域名"   "子域(主机记录)"
    arDdnsCheck "$domainU" "$subdomainU" "6"
}

# get openwrt-all-device ip list
get_ipv6() {
    ip neigh > 1.txt
    awk "/${mac}/" 1.txt > 2.txt # 列出含有《45:52:82:9e:73:86》mac地址的行
    sed  "/fe80:/d" 2.txt > 1.txt # 删除含有《fe80:》的行
    sed  "/192.168./d" 1.txt > 2.txt # 删除含有ipv4的行
    awk '{print $1}' 2.txt > 1.txt # 保留第一列的ipv6
    mac_ipv6=$(sed -n 1p 1.txt) # 打印第一行的ipv6，赋值到变量
    echo "$subdomainU.$domainU = $mac_ipv6"
}

######----------######----------######----------######----------######----------######

# dnspod的API密钥 申请地址：https://console.dnspod.cn/account/token/token
DNSpod_ID="243177"
DNSpod_Token="357e3a1280d6dfcaf7ea30c3e4e701cc"

# 域名解析ddns1
mac="00:11:32:9E:12:7B" # 设备mac地址
domainU="bueess.top" # 主域名
subdomainU="xnas" # 子域(主机记录)
run_dnspod # 运行程序

# 域名解析ddns2
mac="02:42:C0:A8:7B:E1" # 设备mac地址
domainU="bueess.top" # 主域名
subdomainU="xqb" # 子域(主机记录)
run_dnspod # 运行程序 (启动ddns2，请删除最前面的#号)

# 域名解析ddns3
mac="" # 设备mac地址
domainU="" # 主域名
subdomainU="" # 子域(主机记录)
# run_dnspod # 运行程序
