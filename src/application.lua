dofile("sensors.lua")
dofile("com.lua")

DHT11_PIN = 4
CT_SENSOR_RESOLUTION = 66
-- 1 waveform period in micro seconds
period = 1000000 / 60
-- use 185 for 5A, 100 for 20A Module and 66 for 30A Module
sensitivity = 0.66
resolution = 3.3 / 1023.0
Q = 0.0147

function createServer()
    srv = net.createServer(net.TCP)
    srv:listen(80, function(conn)
        conn:on("receive", function(sck, payload)
            -- print(payload)
            th = readTempAndHumidity(DHT11_PIN)
            adcVal = readAdcVal()
            v = adcValToVolt(adcVal)
            amps = readCurrent()
            sck:send(
                "HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU.</h1><p>" ..
                th .. "</p><hr/>" ..
                "<p>Chip id: " .. node.chipid() .."</p>" ..
                "<p>Heap: " .. node.heap() .."</p>" ..
                "<hr/>" ..
                "<p>Amps:" .. amps .. "</p>" ..
                "<p>ADC pin val: " .. adcVal .." </p>" ..
                "<p>Volt:" .. v .. "</p>")
        end)
        conn:on("sent", function(sck) sck:close() end)
    end)
end

function map(x, in_min, in_max, out_min, out_max)
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
end

function readCurrent()
    local tstart = tmr.now()
    local acDiff = 0
    local acSum = 0.0
    local cnt = 0
    local min = 1023
    local max = 0
    while (tmr.now() - tstart) < period do
        r = adc.read(0)
        if (r > max) then max = r end
        if r < min then min = r end
    end
    avgVpp = (max - min)-2
    vout = avgVpp * resolution
    Vrms = (vout / 2) * 0.707
    Irms = Vrms / 0.066
    watts = 220 * Irms *0.97
    print("Adc=" .. avgVpp .. " V=" .. vout*1000)
    print("Vrms=" .. Vrms .. " Irms=" .. Irms.." Watts"..watts)
    return Irms
end

if adc.force_init_mode(adc.INIT_ADC) then
    node.restart()
    return -- don't bother continuing, the restart is scheduled
end

m = init_mqtt(node.chipid() .. "-dev", 120)
mqtt_connect()

function publishSensorsVals()
    readTempAndHumidity(DHT11_PIN, function(temp, humi)
            data = '{"temparature": '.. temp .. ', "humidity": '.. humi ..'}'
            m:publish("homeassistant/office/tmp_and_hum/set", data, 0, 0)
            print("Sent " .. data)
    end)
    adcVal = readAdcVal()
    v = adcValToVolt(adcVal)
    data = '{"raw": '.. adcVal .. ', "volts": '.. v ..'}'
    m:publish("homeassistant/office/voltage/set", data, 0, 0)
    print("Sent " .. data)
end

-- tmr.create():alarm(2000, tmr.ALARM_AUTO, function() readCurrent() end)
tmr.create():alarm(5000, tmr.ALARM_AUTO, publishSensorsVals)

print("Device MAC: " .. wifi.sta.getmac())
print("Creating HTTP server at http://" .. wifi.sta.getip() .. ":80")
createServer()
