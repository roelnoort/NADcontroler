
srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)

    conn:on("receive",function(conn,payload)
        print("Got something...["..payload.."]")
        -- POST /switchnad/1 HTTP/1.1
        -- GET / HTTP/1.1
        -- GET /favicon.ico HTTP/1.1

        restmethod = string.sub(payload,1, payload:find(" ")-1)
        print("Method")
        if restmethod == "GET" then
            print("serve our simple website")
            conn:send("<h1>NAD T758 controler</h1>")
            conn:send("<p>This is the RS232 controler for the NAD T758.</p>")
            conn:send("<p>Use HTTP POST via </p>")
            conn:send("<p>http://&lt;hostname&gt;:&lt;port&gt;/switchnad/&lt;source number&gt;</p>")
            conn:send("<p>http://&lt;hostname&gt;:&lt;port&gt;/poweroff</p>")
        elseif restmethod == "POST" then
            print("control the NAD")
        end

        --conn:close()
        --local request = createRequest(payload)

        --print("Method: " .. request.method .. " Location: " .. request.path)
        --request = nil
        --collectgarbage()
    end)

    conn:on("sent", function(conn)
        conn:close()
    end)
end)
