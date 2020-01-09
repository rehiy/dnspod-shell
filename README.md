# ArDNSPod

基于DNSPod用户API实现的纯Shell动态域名客户端，适配网卡地址。

# Usage

[详细介绍使用方法的博文](https://blog.csdn.net/Imkiimki/article/details/83794355)（老鸟请略过）

首先要在dnspod网页上新建解析记录，然后获得api token。  
复制`dns.conf.example`到同一目录下的`dns.conf`并根据你的配置修。  
在 `ddnspod.sh` 文件开头修改要解析的ip类型(ipv4/ipv6)    

执行时直接运行`ddnspod.sh`，支持cron任务。

配置文件格式：

```
# 安全起见，不推荐使用密码认证
# arMail="test@gmail.com"
# arPass="123"
(现在dnspod已经完全废除密码认证的方式了)

# 推荐使用Token认证
# 按`TokenID,Token`格式填写
arToken="12345,7676f344eaeaea9074c123451234512d"

# 每行一个域名
arDdnsCheck "test.org" "subdomain"
```

# 最近更新

2015/2/24

- 增加token鉴权方式 (by wbchn)

2015/7/7

- 使用D+服务获取域名解析

2016/2/25

- 增加配置文件，分离脚本与配置，适配内网。
- 加入Mac支持
- sed脚本POSIX化，可跨平台

2016/3/23

- 进一步POSIX化，支持Mac和大部分Linux发行版
- 更改配置文件格式

------forked from origin-----

2018-11-07

- 支持选择IP地址类型，包括外网/内网/IPv6

2019-05-24

- 支持IPV6(如你所料，之前所说的支持是假的)
- 根据网站的更新，api调用使用TLS v1.2，解决了之前调用失败的问题（感谢@lth410 指出）。

2020-01-03
- 修复了12月31日由于 dnspod API 改动导致的失效。

2020-01-09
- API返回格式又变了，更改正则表达匹配。

# Credit

Original: anrip
Forked form anrip/ArDNSPod
