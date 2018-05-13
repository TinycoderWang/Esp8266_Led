dofile("config.lua")
print("set up wifi mode")
print(wifi.getmode())

wifi.setmode(wifi.STATIONAP)
cfg={}
cfg.ssid=getConfig("ssid")
cfg.pwd=getConfig("pwd")


wifi.ap.config({ ssid = 'mymcu', auth = AUTH_OPEN })

function connectWifi()
    wifi.sta.config(cfg)
    wifi.sta.connect()
    wifi.sta.autoconnect(1)
end


if cfg.ssid ~= nil then
    connectWifi()
end


wifi_connetion1=0


m = nil

mqtt_inited = 0

mqtt_connecting = 0


tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip()== nil then
        if wifi_connetion1 == 1 then
            print("IP unavaiable, Waiting...")
            wifi_connetion1 = 0
        end
    else
        if wifi_connetion1 == 0 then
            print("Config done, IP is "..wifi.sta.getip())
            wifi_connetion1 = 1
            dofile("mqttd.lua")
        end
    end
end)
print("print(wifi_connection1)")
print(wifi_connetion1)


srv=net.createServer(net.TCP)  
srv:listen(80,function(conn)  
    conn:on("receive",function(conn,req)
        local _, _, method, path, vars = string.find(req, "([A-Z]+) (.+)?(.+) HTTP") 
        if(method == nil)then
            _, _, method, path = string.find(req, "([A-Z]+) (.+) HTTP")
        end
        local _GET = {}

        if(vars ~= nil)then
            for k, v in string.gmatch(vars, "([^&]+)=([^&]*)&*") do
                _GET[k] = v
            end
        end

        local deviceId = getConfig("deviceId")
        local ssid = getConfig("ssid")
        local pwd = getConfig("pwd")
    
        if deviceId == nil then
            deviceId = ""
        end
        if ssid == nil then
            ssid = ""
        end
        if pwd == nil then
            pwd = ""
        end
        
        if _GET.deviceId ~= nil and _GET.deviceId ~= ""  then
            deviceId = _GET.deviceId
            setConfig("deviceId",_GET.deviceId)
        end
        if _GET.ssid ~= nil and _GET.ssid ~= ""  then
            print(_GET.ssid)
            ssid = _GET.ssid
            setConfig("ssid",_GET.ssid)
            node.restart()
        end
        if _GET.pwd ~= nil and _GET.pwd ~= ""  then
            pwd = _GET.pwd
            setConfig("pwd",_GET.pwd)
        end
        
        local buf = '<html>'
        buf = buf..'<head>'
        buf = buf..'<title>config</title>'
        buf = buf..'</head>'
        buf = buf..'<body>'
        buf = buf..'<form>'
        buf = buf..'deviceId:<input type="text" value="'..deviceId..'" name="deviceId">'
        buf = buf.."<br>"
        buf = buf..'SSID:<input type="text" name="ssid" value="'..ssid..'">'
        buf = buf.."<br>"
        buf = buf..'PWD:<input type="text" name="pwd" value="'..pwd..'">'
        buf = buf..'<br>'
        buf = buf..'<input type="submit" value="submit">'
        buf = buf..'</form>'
        buf = buf..'</body>'
        buf = buf..'</html>'
        local html = string.format('HTTP/1.0 200 OK\r\n'
        ..'Content-Type: text/html\r\n'
        ..'Connection: Close\r\n\r\n'
        ..buf)
        conn:send(html)
    end)
    conn:on("sent",function(conn) conn:close() end)
end)
