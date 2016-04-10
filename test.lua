uart.setup(0,115200,8,0,1)

require("debug")

debugmsg("Starting NADcontroler")

debugmsg("Setting up WIFI...")

local wifi = require("wificonfig")

setupWifiMode( function()
  dofile("server.lua")
end)
