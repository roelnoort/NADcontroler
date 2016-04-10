require("debug")

local wificonfig = {}

function setupWifiMode(action)
    --local json = require "cjson"
    --file.open("wifi_settings.json","r")
    --local theSettings = file.read()
    --local settings = json.decode(theSettings)
    --file.close()

    debugmsg("set up wifi mode")
    wifi.setmode(wifi.STATION)
    wifi.sta.config("burton2G","customflyingv")
    --wifi.sta.config(settings.sid,settings.password)

    wifi.sta.connect()
    tmr.alarm(1, 1000, 1, function()
        if wifi.sta.getip()== nil then
            debugmsg("IP unavaiable, Waiting...")
        else
            tmr.stop(1)
            debugmsg("Config done, IP is "..wifi.sta.getip())
            action()
        end
    end)
end

return wificonfig
