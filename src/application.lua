dofile("sensors.lua")

DHT11_PIN=4

function createServer()
    srv = net.createServer(net.TCP)
    srv:listen(80, function(conn)
        conn:on("receive", function(sck, payload)
            -- print(payload)
            th = readTempAndHumidity(DHT11_PIN)
            sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU.</h1><p>"..th.."</p>")
        end)
        conn:on("sent", function(sck) sck:close() end)
    end)
end

print("Creating HTTP server at http://"..wifi.sta.getip()..":80")
createServer()
