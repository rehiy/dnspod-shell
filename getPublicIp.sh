#!/bin/bash

function getPublicIp() {
    case $1 in
        1)
            WanIp=`curl -s 'https://api.ipify.org?format=json' | grep ip |sed 's/.*ip":"\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)".*/\1/g'`
            echo $WanIp
            ;;
        2)
            WanIp=`curl -s 'https://ipapi.co/ip/'`
            echo $WanIp
            ;;
        3)
            WanIp=`curl -s 'http://ip-api.com/json/?fields=query' | grep query |sed 's/.*query":"\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)".*/\1/g'`
            echo $WanIp
            ;;
        4)
            WanIp=`curl -s 'https://ip4.seeip.org'`
            echo $WanIp
            ;;
        5)
            WanIp=`curl -s 'https://api.myip.com' | grep ip |sed 's/.*ip":"\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)".*/\1/g'`
            echo $WanIp
            ;;
        *)
            WanIp=`curl -s 'https://ifconfig.co'`
            echo $WanIp
            ;;
    esac
}

# Index=$(( $RANDOM % 7))
Index=$1
WanIp=$(getPublicIp $Index)
echo "get WanIp from" $Index ":"$WanIp
