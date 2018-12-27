# 由于windows10 1703 后版本的bug， 重启会导致网络共享失效， 所以开机时执行此脚本，修复网络共享。
# 
# ref: https://answers.microsoft.com/en-us/windows/forum/windows_10-networking/ics-internet-connection-sharing-dosent-work-in/a203c90f-1214-4e5e-ae90-9832ae5ceb55
# ref: https://superuser.com/questions/470319/how-to-enable-internet-connection-sharing-using-command-line

$m = New-Object -ComObject HNetCfg.HNetShare
$m.EnumEveryConnection |% { $m.NetConnectionProps.Invoke($_) }

# the public network to share. 被分享的网络，网络名称按需修改
$c1 = $m.EnumEveryConnection |? { $m.NetConnectionProps.Invoke($_).Name -eq "以太网" }
# the private network. 分享到的网络，网络名称按需修改
$c2 = $m.EnumEveryConnection |? { $m.NetConnectionProps.Invoke($_).Name -eq "以太网 2" }
$config1 = $m.INetSharingConfigurationForINetConnection.Invoke($c1)
$config2 = $m.INetSharingConfigurationForINetConnection.Invoke($c2)
$config1.DisableSharing()
$config2.DisableSharing()
$config1.EnableSharing(0)
$config2.EnableSharing(1)
