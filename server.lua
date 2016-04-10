require("rs232")
require("debug")

srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)

    conn:on("receive",function(conn,payload)
        debugmsg("Got something...["..payload.."]")
        -- POST /switchnad/1 HTTP/1.1
        -- GET / HTTP/1.1
        -- GET /favicon.ico HTTP/1.1

        restmethod = string.sub(payload,1, payload:find(" ")-1)
        debugmsg("Method ["..restmethod.."]")

        if restmethod == "GET" then
            --serve a simple website to the user
            debugmsg("serve our simple website")
            conn:send("HTTP/1.1 200 OK\n\n")
            conn:send("<!DOCTYPE HTML>\n")
            conn:send("<html><body>\n")
            conn:send("<h1>NAD T758 controler</h1>")
            conn:send("<p>This is the RS232 controler for the NAD T758.</p>")
            conn:send("<p>Use HTTP POST via </p>")
            conn:send("<p>http://&lt;hostname&gt;:&lt;port&gt;/switchnad/&lt;source number&gt;</p>")
            conn:send("<p>http://&lt;hostname&gt;:&lt;port&gt;/poweroff</p>")
            conn:send("</body></html>\n")
        elseif restmethod == "POST" then
            --check if the command is proper and execute it
            --print("control the NAD ["..payload:sub(6, 18).."]")
            if payload:sub(6, 18) == "/switchinput/" then
                debugmsg("switch to another input")
                NADswitchInput(1, function(result)
                    if result then
                        conn:send("HTTP/1.1 200 OK\n\n")
                    else
                        -- send server error 500 - internal server error
                        conn:send("HTTP/1.1 500 OK\n\n")
                    end
                end)
            elseif payload:sub(6, 15) == "/poweroff/" then
                debugmsg("power off the amp")
                NADpowerOff(function(result)
                    if result then
                        conn:send("HTTP/1.1 200 OK\n\n")
                    else
                        -- send server error 500 - internal server error
                        conn:send("HTTP/1.1 500 OK\n\n")
                    end
                end)
            else
                -- command not recognized
                -- send client error 400 - bad request
                conn:send("HTTP/1.1 400 OK\n\n")
            end
        end
    end)

    conn:on("sent", function(conn)
        conn:close()
    end)
end)
