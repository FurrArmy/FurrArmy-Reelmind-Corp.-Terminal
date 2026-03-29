local mon = peripheral.find("monitor")
local users = require("users")
local docs = require("docs")
local utils = require("utils")

mon.setTextScale(1)
utils.clear(mon)

-- Boot animation
for i=1,3 do
    utils.centerText(mon, 5, "FURRARMY SYSTEM BOOTING" .. string.rep(".", i))
    sleep(0.4)
    utils.clear(mon)
end

-- LOGIN SYSTEM
local function login()
    while true do
        utils.clear(mon)
        utils.centerText(mon, 2, "== FURRARMY TERMINAL ==")

        mon.setCursorPos(2,5)
        mon.write("Username: ")
        local _, _, x, y = os.pullEvent("monitor_touch")
        mon.setCursorPos(2,6)
        local username = read()

        mon.setCursorPos(2,8)
        mon.write("Password: ")
        local password = read("*")

        for _, user in ipairs(users) do
            if user.username == username and user.password == password then
                return user
            end
        end

        utils.centerText(mon, 10, "ACCESS DENIED")
        sleep(1.5)
    end
end

-- MENU
local function menu(user)
    while true do
        utils.clear(mon)

        utils.centerText(mon, 2, "WELCOME " .. user.username)
        utils.centerText(mon, 3, user.division .. " | " .. user.rank)

        mon.setCursorPos(2,6)
        mon.write("[1] Open Documents")
        mon.setCursorPos(2,7)
        mon.write("[2] Logout")

        local event, _, x, y = os.pullEvent("monitor_touch")

        if y == 6 then
            openDocs(user)
        elseif y == 7 then
            return
        end
    end
end

-- DOCUMENT VIEW
function openDocs(user)
    while true do
        utils.clear(mon)
        utils.centerText(mon, 2, "DOCUMENT DATABASE")

        local visibleDocs = {}
        local line = 4

        for i, doc in ipairs(docs) do
            if user.clearance >= doc.clearance then
                mon.setCursorPos(2, line)
                mon.write("["..i.."] "..doc.title)
                visibleDocs[line] = doc
                line = line + 1
            end
        end

        local event, _, x, y = os.pullEvent("monitor_touch")

        if visibleDocs[y] then
            utils.clear(mon)
            utils.centerText(mon, 2, visibleDocs[y].title)

            mon.setCursorPos(2,4)
            utils.slowPrint(visibleDocs[y].content, 0.02)

            sleep(3)
        else
            return
        end
    end
end

-- RUN
while true do
    local user = login()
    menu(user)
end
