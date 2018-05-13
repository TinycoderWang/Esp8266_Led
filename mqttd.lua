IO_BLINK = 4

function init()
    print("init mqttd")
    mqtt_inited = 1
    m = mqtt.Client(getConfig("deviceId"), 30, getConfig("deviceId"), getConfig("deviceId"))

    m:connect(getConfig("host"), getConfig("port"), 0)


    m:on("connect", function(con)
        print ("connected!") 
        stopReconnect()
        m:subscribe("OUT/DEVICE/"..getConfig("userId").."/"..getConfig("groupId").."/"..getConfig("deviceId"),2, function(conn) print("subscribe success") end)
        end)
        
    m:on("offline", function(con) 
        reconnect()
    end)
    
    m:on("message", function(conn, topic, data) 
      print("receive mag:"..data) 
      json = sjson.decode(data)
      if json ~= nil then
        if json.cmd == "0" then
            gpio.mode(IO_BLINK, gpio.OUTPUT)
            gpio.write(IO_BLINK, gpio.HIGH)
        end
        if json.cmd == "1" then
            gpio.mode(IO_BLINK, gpio.OUTPUT)
            gpio.write(IO_BLINK, gpio.LOW)
        end
      end
      
    end)

end


if mqtt_inited == 0 then
    init()
else
    reconnect()
end


function reconnect()
    if mqtt_connecting == 0 then
        tmr.alarm(3, 2000, 1, function()
            print("start reconnect!")
            m:close()
            m:connect(getConfig("host"), getConfig("port"), 0)
        end)
        mqtt_connecting = 1
    end
end

function stopReconnect()
    mqtt_connecting = 0
    tmr.stop(3)
end
