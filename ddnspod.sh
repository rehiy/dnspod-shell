#!/bin/sh

#################################################
# AnripDdns v5.08
# Dynamic DNS using DNSPod API
# Original by anrip<mail@anrip.com>, http://www.anrip.com/ddnspod
# Edited by ProfFan
#################################################

# OS Detection
case $(uname) in
  'Linux')
    echo "Linux"
    ;;
  'FreeBSD')
    echo 'FreeBSD'
    exit 100
    ;;
  'WindowsNT')
    echo "Windows"
    exit 100
    ;;
  'Darwin')
    echo "Mac"
    ;;
  'SunOS')
    echo 'Solaris'
    exit 100
    ;;
  'AIX')
    echo 'AIX'
    exit 100
    ;;
  *) ;;
esac

#Get IpAddress
arIpAddress(){
  if [ "x${WanIp}" = "x" ]; then
    WanIp=`curl -s -d "ip=myip" http://ip.taobao.com/service/getIpInfo2.php  |  sed 's/.*ip":"\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)".*/\1/g'`
  fi
  
  if [ "x${WanIp}" = "x" ]; then
    WanIp=`curl -s http://city.ip138.com/ip2city.asp | grep center | sed 's/.*\[\([0-9\.]*\)\].*/\1/g' `
  fi
echo $WanIp
}

# Get script dir
# See: http://stackoverflow.com/a/29835459/4449544
rreadlink() ( # Execute the function in a *subshell* to localize variables and the effect of `cd`.

  target=$1 fname= targetDir= CDPATH=

  # Try to make the execution environment as predictable as possible:
  # All commands below are invoked via `command`, so we must make sure that `command`
  # itself is not redefined as an alias or shell function.
  # (Note that command is too inconsistent across shells, so we don't use it.)
  # `command` is a *builtin* in bash, dash, ksh, zsh, and some platforms do not even have
  # an external utility version of it (e.g, Ubuntu).
  # `command` bypasses aliases and shell functions and also finds builtins 
  # in bash, dash, and ksh. In zsh, option POSIX_BUILTINS must be turned on for that
  # to happen.
  { \unalias command; \unset -f command; } >/dev/null 2>&1
  [ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on # make zsh find *builtins* with `command` too.

  while :; do # Resolve potential symlinks until the ultimate target is found.
      [ -L "$target" ] || [ -e "$target" ] || { command printf '%s\n' "ERROR: '$target' does not exist." >&2; return 1; }
      command cd "$(command dirname -- "$target")" # Change to target dir; necessary for correct resolution of target path.
      fname=$(command basename -- "$target") # Extract filename.
      [ "$fname" = '/' ] && fname='' # !! curiously, `basename /` returns '/'
      if [ -L "$fname" ]; then
        # Extract [next] target path, which may be defined
        # *relative* to the symlink's own directory.
        # Note: We parse `ls -l` output to find the symlink target
        #       which is the only POSIX-compliant, albeit somewhat fragile, way.
        target=$(command ls -l "$fname")
        target=${target#* -> }
        continue # Resolve [next] symlink target.
      fi
      break # Ultimate target reached.
  done
  targetDir=$(command pwd -P) # Get canonical dir. path
  # Output the ultimate target's canonical path.
  # Note that we manually resolve paths ending in /. and /.. to make sure we have a normalized path.
  if [ "$fname" = '.' ]; then
    command printf '%s\n' "${targetDir%/}"
  elif  [ "$fname" = '..' ]; then
    # Caveat: something like /var/.. will resolve to /private (assuming /var@ -> /private/var), i.e. the '..' is applied
    # AFTER canonicalization.
    command printf '%s\n' "$(command dirname -- "${targetDir}")"
  else
    command printf '%s\n' "${targetDir%/}/$fname"
  fi
)

DIR=$(dirname -- "$(rreadlink "$0")")

# Global Variables:

# Token-based Authentication
arToken=""
# Account-based Authentication
arMail=""
arPass=""

# Get Domain IP
# arg: domain
arDdnsInfo() {
    local domainID recordID recordIP
    # Get domain ID
    domainID=$(arApiPost "Domain.Info" "domain=${1}")
    domainID=$(echo $domainID | sed 's/.*{"id":"\([0-9]*\)".*/\1/')
    
    # Get Record ID
    recordID=$(arApiPost "Record.List" "domain_id=${domainID}&sub_domain=${2}")
    recordID=$(echo $recordID | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')
    
    # Last IP
    recordIP=$(arApiPost "Record.Info" "domain_id=${domainID}&record_id=${recordID}")
    recordIP=$(echo $recordIP | sed 's/.*,"value":"\([0-9\.]*\)".*/\1/')

    # Output IP
    case "$recordIP" in 
      [1-9][0-9]*)
        echo $recordIP
        return 0
        ;;
      *)
        echo "Get Record Info Failed!"
        return 1
        ;;
    esac
}

# Get data
# arg: type data
arApiPost() {
    local agent="AnripDdns/5.07(mail@anrip.com)"
    local inter="https://dnsapi.cn/${1:?'Info.Version'}"
    if [ "x${arToken}" = "x" ]; then # undefine token
        local param="login_email=${arMail}&login_password=${arPass}&format=json&${2}"
    else
        local param="login_token=${arToken}&format=json&${2}"
    fi
    curl -s -A $agent -d $param $inter
}

# Update
# arg: main domain  sub domain
arDdnsUpdate() {
    local domainID recordID recordRS recordCD recordIP myIP
    # Get domain ID
    domainID=$(arApiPost "Domain.Info" "domain=${1}")
    domainID=$(echo $domainID | sed 's/.*{"id":"\([0-9]*\)".*/\1/')
    
    # Get Record ID
    recordID=$(arApiPost "Record.List" "domain_id=${domainID}&sub_domain=${2}")
    recordID=$(echo $recordID | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')
    
    # Update IP
    myIP=$(arIpAddress)
    recordRS=$(arApiPost "Record.Ddns" "domain_id=${domainID}&record_id=${recordID}&sub_domain=${2}&record_type=A&value=${myIP}&record_line=默认")
    recordCD=$(echo $recordRS | sed 's/.*{"code":"\([0-9]*\)".*/\1/')
    recordIP=$(echo $recordRS | sed 's/.*,"value":"\([0-9\.]*\)".*/\1/')

    # Output IP
    if [ "$recordIP" = "$myIP" ]; then
        if [ "$recordCD" = "1" ]; then
            echo $recordIP
            return 0
        fi
        # Echo error message
        echo $recordRS | sed 's/.*,"message":"\([^"]*\)".*/\1/'
        return 1
    else
        echo "Update Failed! Please check your network."
        return 1
    fi
}

# DDNS Check
# Arg: Main Sub
arDdnsCheck() {
    local postRS
    local lastIP
    local hostIP=$(arIpAddress)
    echo "Updating Domain: ${2}.${1}"
    echo "hostIP: ${hostIP}"
    lastIP=$(arDdnsInfo $1 $2)
    if [ $? -eq 0 ]; then
        echo "lastIP: ${lastIP}"
        if [ "$lastIP" != "$hostIP" ]; then
            postRS=$(arDdnsUpdate $1 $2)
            if [ $? -eq 0 ]; then
                echo "postRS: ${postRS}"
                return 0
            else
                echo ${postRS}
                return 1
            fi
        fi
        echo "Last IP is the same as current IP!"
        return 1
    fi
    echo ${lastIP}
    return 1
}

# DDNS
#echo ${#domains[@]}
#for index in ${!domains[@]}; do
#    echo "${domains[index]} ${subdomains[index]}"
#    arDdnsCheck "${domains[index]}" "${subdomains[index]}"
#done

. $DIR/dns.conf
