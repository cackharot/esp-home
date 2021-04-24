local server = "59.88.248.13"

function sendToServer(data, clbk)
    local payload =
        '{"number":"' .. data.number .. '","received":"' .. data.received .. '","message":"' .. data.message .. '"}'
    http.post(
        "https://" .. server .. ":443/api/sms",
        "Content-Type: application/json\r\n",
        payload,
        function(code, resp)
            print(code, data)
            clbk(code)
        end
    )
end
