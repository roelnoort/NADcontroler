uart.setup(0,115200,8,0,1)
--print("Starting NADcontroler")

--print("Setting up WIFI...")

local wifi = require("wificonfig")

setupWifiMode( function()
  dofile("server.lua")
end)
