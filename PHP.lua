local socket = require "socket"

ll.registerPlugin("PHP", "PHP-Server", { 0, 0, 1 })
fastLog("PHP heng heng heng aaaaaaaaaaa")

local n_t = os.time()


setInterval(function()
    for k, v in pairs(mc.getOnlinePlayers()) do
        if ping then
            ping:setScore(v, v:getDevice().avgPing)
        end
        --fastLog(v.name,v:getDevice().avgPing)
    end
end, 1000)


mc.listen("onServerStarted", function()
    ping = mc.getScoreObjective("ping")
    ping:setDisplay("list", 0)
    return true
end)

mc.listen("onLeft", function(player)
    if player then
        ping:deleteScore(player)
    end
    return true
end)


setTimeout(function()
    local host = "127.0.0.1"
    local server = assert(socket.bind(host, 56803, 1024))
    print("开始监听 56803")
    server:settimeout(100)
    while true do
        local connect = server:accept()
        if connect then
            connect:settimeout(0)
            local receive, status, partia = connect:receive()
            local receive= receive or partia
            local message= ""

            if receive:find("chafu") then
                local pls = { "    在线玩家:" }
                for k, v in pairs(mc.getOnlinePlayers()) do
                    pls[#pls + 1] = v.name
                end
                local upt = os.time() - n_t
                local upt = table.concat { upt // 3600, "h ", upt % 3600 // 60, "min ", upt % 60, "s\n" }
                message=table.concat {
                    "    BDS运行时间: ", upt,
                    os.date("    最后一次更新状态: %m-%d|%H:%M:%S\n"),
                    table.concat(pls, "\n        ")

                }
            end

            connect:send(message.."\n")
        end
    end
end, 100)

