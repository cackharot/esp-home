dofile("credentials.lua")

function createServer()
    srv = net.createServer(net.TCP)
    srv:listen(80, function(conn)
        conn:on("receive", function(sck, payload)
            print(payload)
            sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU.</h1>")
        end)
        conn:on("sent", function(sck) sck:close() end)
    end)
end

mytimer = tmr.create()
mytimer:register(10000, tmr.ALARM_SINGLE, function()
    print("Connecting to wifi " .. SSID) 
    createServer()
    -- connect to WiFi access point
    wifi.setmode(wifi.STATION)
    wifi.sta.config{ssid=SSID, pwd=PASSWORD}

end)
mytimer:start()