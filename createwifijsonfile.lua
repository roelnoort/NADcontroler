--create wifi settings file

local json = require "cjson"
file.open("wifi_settings.json","w")
local wifi = {}
wifi.sid = "burton2G"
wifi.pwd = "customflyingv"

jsonsettings = json.encode(wifi)

file.write(jsonsettings)
--local theSettings = file.read()
--local settings = json.decode(theSettings)
file.close()
