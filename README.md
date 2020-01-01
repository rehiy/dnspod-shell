# ArDNSPod

基于DNSPod用户API实现的纯Shell动态域名客户端，优先适配网卡地址，无法获得合法外网地址则使用外部接口获取IP地址

# 使用方法

-   修改`ddnspod.sh`中的`/your_real_path/ardnspod`为真实路径

-   运行`/your_real_path/ddnspod.sh`执行更新，_支持添加为cron任务_

### 小提示

-   如需单文件运行，将`ddnspod.sh`中的配置项添加到`ardnspod`底部，直接运行`ardnspod`即可

# 最近更新

2020/1/1

-   适配新版API（2019-11-26）
-   当`wget`不存在时，尝试使用`curl`提交
-   由于`readlink`不可靠，更改为手动设置路径
-   当无法从本地网卡获得外网ip时，尝试从外部api获取

2015/2/24

-   增加token鉴权方式 (by wbchn)

2015/7/7

-   使用D+服务获取域名解析

2016/2/25

-   增加配置文件，分离脚本与配置，适配内网。
-   加入Mac支持
-   sed脚本POSIX化，可跨平台

2016/3/23

-   进一步POSIX化，支持Mac和大部分Linux发行版
-   更改配置文件格式

# 共同维护者

ProfFan, <https://github.com/ProfFan>
