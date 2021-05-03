function readAdcVal()
    val = adc.read(0)
    print("ADC Val=" .. val)
    return val
end

function adcValToVolt(val)
    return (3.3/1023)*val
end

function readTempAndHumidity(pin, cb)
    status, temp, humi, temp_dec, humi_dec = dht.read(pin)
    if status == dht.OK then
        if cb ~= nil then
            cb(temp, humi)
        end
        return string.format("Temp: "..temp.." Humidity: "..humi)
    elseif status == dht.ERROR_CHECKSUM then
        print( "DHT Checksum error." )
        return "ERROR: CHECKSUM"
    elseif status == dht.ERROR_TIMEOUT then
        print( "DHT timed out." )
        return "ERROR: TIMEOUT"
    end
end
