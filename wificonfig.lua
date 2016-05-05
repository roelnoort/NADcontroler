require("debug")

local wificonfig = {}

function configWifi()
    debugmsg("configWifi called")

    cfg = {}
    cfg.ssid = "NAD"
    cfg.pwd = "12345678"
    wifi.ap.config(cfg)
    wifi.setmode(wifi.STATIONAP)
    --wifi.setmode(wifi.SOFTAP)

    connectionWebsite()
end

function connectionWebsite()
    srv = net.createServer(net.TCP)
    srv:listen(80, function(conn) 
        conn:on("receive", function(client, req) 
            client:send("website to config NadControler")
            wifi.sta.getap(function(networks)
                print("are we getting here?")
                for k, v in pairs(networks) do
                    debugmsg(k)
                    print(k..":"..v)
                end
            end)
            client:close()
        end)
        --conn:on("sent", function(conn)
        --    conn:close()
        --end)
    end)
end

function setupWifiMode(action)
    local json = require "cjson"
    file.open("wifi_settings.json","r")
    local theSettings = file.read()
    local settings = json.decode(theSettings)
    file.close()

    debugmsg("set up wifi mode")
    wifi.setmode(wifi.STATION)
    --wifi.sta.config("burton2Gd","customflyingv")
    wifi.sta.config(settings.sid,settings.pwd)

    wifi.sta.connect()
    attempts = 5

    -- wifi.sta.status
    -- 0 : station idle
    -- 1 : station connecting
    -- 2 : station wrong pwd
    -- 3 : station no ap found
    -- 4 : station connect fail
    -- 5 : station got ip
    tmr.alarm(1, 1000, 1, function()
        attempts = attempts - 1
        debugmsg("hello")
        debugmsg("wifi status : "..wifi.sta.status())
        if wifi.sta.getip()== nil then
            if attempts == 0 then
                debugmsg("IP unavailable, going to config screen")
                --tmr.stop(1)
                --wifi.sta.disconnect()
                --configWifi()
            else
                debugmsg("IP unavailable, Waiting...")
            end
        else
            tmr.stop(1)
            debugmsg("Config done, IP is "..wifi.sta.getip())
            action()
        end
    end)
    debugmsg("done with status : " .. wifi.sta.status())
end

return wificonfig
