# 此脚本仅支持ipv6动态解析
优点：
- 每个设备有单独的公网ipv6
- 一个子域名对应一个设备
- 配置简单

### openwrt终端输入下面命令，一键安装
```sh
wget https://cdn.jsdelivr.net/gh/Howardnm/dnspod-shell@master/install.sh && chmod +x install.sh && ./install.sh
```
### 修改myddns.sh配置文件
```sh
# dnspod的API密钥 申请地址：https://console.dnspod.cn/account/token/token
DNSpod_ID="243177"
DNSpod_Token="357e3a1280d6dfcaf7ea30c3e4e701dd"

# 域名解析ddns1
mac="45:52:82:9e:73:86" # 设备mac地址
domainU="abc.com" # 主域名
subdomainU="www" # 子域(主机记录)
run_dnspod # 运行程序

# 域名解析ddns2
mac="45:52:82:9e:73:13" # 设备mac地址
domainU="abc.com" # 主域名
subdomainU="live" # 子域(主机记录)
# run_dnspod # 运行程序 (启动ddns2，请删除最前面的#号)

# 域名解析ddns3
...
...
```
### 运行程序
- 请在腾讯云的子域名【记录类型】设置为AAAA，再运行
```sh
sh /root/myddns/myddns.sh
```
### 开启openwrt ipv6防火墙
- [网络]>[通信规则]
- 添加规则
- 仅设置：[高级设置]>[限制地址类型]>[仅ipv6]
- 保存即可

### 加入openwrt计划任务
- 每10分钟刷新一次动态域名
```sh
*/10 * * * * sh /root/myddns/myddns.sh
```
![image](https://user-images.githubusercontent.com/55622355/177611100-17d8417d-6f72-46c0-b107-4ac536ed070b.png)
