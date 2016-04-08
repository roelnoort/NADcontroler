print("Starting NADcontroler")

print("Setting up WIFI...")

local wifi = require("wificonfig")

setupWifiMode( function()
  dofile("server.lua")
end)
