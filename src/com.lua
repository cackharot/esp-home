function handle_mqtt_connect(c)
    print("MQTT connected to ".. MQTT_HOST .. ":" .. MQTT_PORT)
end

function handle_mqtt_error(client, reason)
    print("MQTT error: " .. reason)
    tmr.create():alarm(10 * 1000, tmr.ALARM_SINGLE, mqtt_connect)
end

function mqtt_connect()
    m:connect(MQTT_HOST, MQTT_PORT, false, handle_mqtt_connect, handle_mqtt_error)
end

function init_mqtt(clientId, reconSeconds)
    m = mqtt.Client(clientId, reconSeconds)
    m:lwt("/lwt", "offline", 0, 0)
    m:on("offline", function(client) print ("offline") end)
    m:on("message", function(client, topic, msg) print("Rcv: " .. topic .. " :: ".. msg) end)
    m:on("connect", handle_mqtt_connect)
    return m
end
