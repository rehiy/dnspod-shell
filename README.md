# ArDNSPod

基于 DNSPod 用户 API 实现的纯 Shell 动态域名客户端。

- IPv4 优先适配网卡地址，无法获得合法外网地址则从*第三方*接口获取地址，依然失败则使用`DNSPod`接口自动更新
- IPv6 优先适配网卡地址，无法获得合法外网地址则从*第三方*接口获取地址，依然失败则退出
- IP地址接口项目源码参见 https://github.com/rehiy/docker-geoip-api

**官方DDNS接口已支持设置IPv6，如有兼容问题请使用`v6.1`分支版本**

# 使用方法

- 编辑`ddnspod.sh`，分别修改`/your_real_path/ardnspod`、`arToken`和`arDdnsCheck`为真实信息

- 运行`ddnspod.sh`，开启循环更新任务；建议将此脚本支持添加到计划任务；

- 成功运行后，结果如下所示：

```
=== Check test.rehi.org ===
Fetching Host Ip
> Host Ip: Auto
> Record Type: A
Fetching RecordId
> Record Id: 998534425
Updating Record value
> arDdnsUpdate - 1.2.3.4
```

### 小提示

- 如需单文件运行，参考`ddnspod.sh`中的配置项，添加到`ardnspod`底部，直接运行`ardnspod`即可

```
echo "arToken=12345,7676f344eaeaea9074c123451234512d" >> ./ardnspod
echo "arDdnsCheck test.org subdomain" >> ./ardnspod
```

# 最近更新

2025/2/21

- 支持创建记录，当记录不存在时创建

2023/8/5

- 根据记录Id缓存本地IP

2023/7/22

- Bug fix: 当需要替换根域名时, 如果传入 @ `(如 @.domain.xx)`, 会错误得到 `*.domain.xx` 的结果 `(A记录设置了*的话)`, 导致更新失败. 修改后在传入 `@` 作为子域名时, 直接请求根域名的结果

2023/5/24

- 恢复支持变更检测

2022/11/24

- 支持指定网卡
- 增加 arRequest 方法，实现 curl/wget 封装

2022/03/11

- 改用ddns接口更新数据
- ipv4 先从本机获取，若没有合法地址，则使用dnspod接口填充IP
- ipv6 本机获取难度太大，且错误率高，改为直接从外部接口获取地址

2021/11/25

- 优先选择剩余时间最长的ipv6地址 [@kaedeair](https://github.com/kaedeair/dnspod-shell)

2021/3/3

- 强化获取IP结果检测
- 优化部分判断逻辑
- 优化消息输出

2021/2/8

- 添加 IPv6 支持
- 优化流程，减少 API 调用次数
- 完善出错提示

2020/8/5

- 修复 `get the wrong recordID` @C-Y-X

2020/1/1

- 适配新版 API（2019-11-26）
- 当`wget`不存在时，尝试使用`curl`提交
- 由于`readlink`不可靠，更改为手动设置路径
- 当无法从本地网卡获得外网 ip 时，尝试从外部 api 获取

2015/2/24

- 增加 token 鉴权方式 (by wbchn)

2015/7/7

- 使用 D+服务获取域名解析

2016/2/25

- 增加配置文件，分离脚本与配置，适配内网。
- 加入 Mac 支持
- sed 脚本 POSIX 化，可跨平台

2016/3/23

- 进一步 POSIX 化，支持 Mac 和大部分 Linux 发行版
- 更改配置文件格式

2015/7/23

- 代码托管到 github

2013/03/28

- 稳定版发布，同时被收录到官方插件列表

2011/07/03

- 小范围测试版发布

# 共同维护者

请参阅 <https://github.com/rehiy/dnspod-shell/graphs/contributors>
