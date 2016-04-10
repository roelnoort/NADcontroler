--debug.lua
--
-- log to a debug file

function debugmsg(s)
    file.open("debug.log", "a")
    file.writeline(s)
    file.close(file)
end
