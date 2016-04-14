cfg = {}
cfg.ssid = "Nad"
cfg.pwd = "12345678"
wifi.ap.config(cfg)
wifi.setmode(wifi.STATIONAP)

wifi.sta.getap(function(networks)
                for k, v in pairs(networks) do
                    debugmsg(k)
                    print(k..":"..v)
                end
            end)