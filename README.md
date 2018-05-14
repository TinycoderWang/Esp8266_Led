# Esp8266_Led
基于ESP8266芯片使用 [EasyLinker](https://github.com/wwhai/EasyLinker "EasyLinker") 和 [EasyLinkerApp](https://github.com/TinycoderWang/EasyLinkerApp) 实现的物联网入门Demo  

**ESP8266（NodeMCU）代码基本来源于[https://gitee.com/ilt/nodemcuesp8266mqtt_connection](https://gitee.com/ilt/nodemcuesp8266mqtt_connection)**  

## 一、刷入NodeMCU固件  
可直接下载[固件nodemcu-master-10-modules-2018-05-05-01-39-00-float.bin](https://github.com/TinycoderWang/Esp8266_Led/blob/master/nodemcu-master-10-modules-2018-05-05-01-39-00-float.bin)后进行刷入，也可以根据自己的需求去[这里](https://www.nodemcu-build.com/)定制（注：qq邮箱收不到创建固件的邮件）。  
下载好固件后使用[nodemcu-flasher](https://github.com/nodemcu/nodemcu-flasher)刷入。  

1. 配置参数，根据自己的ESP8266芯片进行相应的参数配置，具体查手册。  
![](http://octklz398.bkt.clouddn.com/nodemcu01.png)  

2. 选择要刷入的固件。  
![](http://octklz398.bkt.clouddn.com/nodemcu02.png)  

3. 将ESP8266设置为升级模式，点击FLASH进行刷入。[刷入后遇到问难题参考这里](http://bbs.eeworld.com.cn/thread-497588-1-1.html)    
![](http://octklz398.bkt.clouddn.com/nodemcu03.png)  

## 二、上传NodeMCU控制代码（[代码注释参考这里](https://gitee.com/ilt/nodemcuesp8266mqtt_connection)）

1. 根据自己在[EasyLinker](https://github.com/wwhai/EasyLinker "EasyLinker") 中的用户和设备修改[config.config](https://github.com/TinycoderWang/Esp8266_Led/blob/master/config.config)配置文件，如下：  
    <pre><code>
	{
	    "pwd":"你的wifi密码",
	    "ssid":"你的wifi名称",
	    "host":"服务器ip",
	    "port":"emq监听端口，默认1883",
	    "userId":"Easyliker里的用户ID",
	    "groupId":"Easyliker里的设备所在群组的ID",
	    "deviceId":"Easyliker里的设备的ID"
	}
	</code></pre>  

2. 将[init.lua](https://github.com/TinycoderWang/Esp8266_Led/blob/master/init.lua)、[config.lua](https://github.com/TinycoderWang/Esp8266_Led/blob/master/config.lua)、[修改过后的config.config](https://github.com/TinycoderWang/Esp8266_Led/blob/master/config.config)、[mqttd.lua](https://github.com/TinycoderWang/Esp8266_Led/blob/master/mqttd.lua)四个文件通过[ESPlorer](https://github.com/4refr0nt/ESPlorer)上传到NodeMCU。  
![](http://octklz398.bkt.clouddn.com/upload_nodemcu_code1.png)  

3. 重启NodeMCU（重启后NodeMCU会自动加载init.lua文件） 

4. 使用[EasyLinkerApp](https://github.com/TinycoderWang/EasyLinkerApp)手机端向[config.config](https://github.com/TinycoderWang/Esp8266_Led/blob/master/config.config)文件中配置的设备发送控制指令，本例控制了GPIO2(Esp8266自带LED和开发板上的第三个LED)  
GPIO对应关系：  
![](http://octklz398.bkt.clouddn.com/nodemcu_gpio2.png)  
指令发送：
![](http://octklz398.bkt.clouddn.com/nodeMCU_send_msg.gif)  

效果如下图：  
<img width="40%" src="http://octklz398.bkt.clouddn.com/nodemcun_cmd0.jpg"/>  <img width="40%" src="http://octklz398.bkt.clouddn.com/nodemcun_cmd1.jpg"/>




