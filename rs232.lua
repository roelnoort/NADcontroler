--rs232 for NAD T758
--
--baud rate 115.200 with 8 data bits, 1 stop bit and no parity bits
--no flow control
--the baud rate should be set in init.lua as the very first statement
--
--send <CR> before and after each command
--Hex code for <CR> is 0x0D

require("debug")

function callbackfordone(result)
    if result then
        debugmsg("NODEMCU debug: callbackfordone - success")
    else
        debugmsg("NODEMCU debug: callbackfordone - error")
    end
end


function NADsend(command, donecb)
  -- sending <CR> before and after each command, as recommended by the manual
  uart.write(0, "\r"..command.."\r")

  -- start the timeout timer
  tmr.alarm(0,5000,0, function()
    debugmsg("NODEMCU debug: response takes too much time, aborting")
    uart.on("data")
    donecb(false)
  end)

  -- receive the response
  -- the NAD gives results in the same format
  --  ie Main.Volume? --> response is Main.Volume=-30
  --     Main.Source=3 --> response is Main.Source=3
  uart.on("data", "\r", function(data)
      -- release timer and handler. important to do that before
      -- calling the callback
      tmr.stop(0)       -- release the timer
      uart.on("data")   -- release the handler
      debugmsg("NODEMCU debug: received from uart:" .. data)
      donecb(true)
    end,0)
end

function Test()
    --NADpowerOff(callbackfordone)
    NADswitchInput(4, callbackfordone)
end

function NADpowerOff(doneCb)
    NADsend("Main.Power=Off", doneCb)
end

function NADswitchInput(inputSource, doneCb)
    NADsend("Main.Power=On", function(result)
        if result then
            NADsend("Main.Source="..inputSource, doneCb) -- this callback does not get executed
        else
            doneCb(false) -- this callback does not get executed
        end
    end)
end
