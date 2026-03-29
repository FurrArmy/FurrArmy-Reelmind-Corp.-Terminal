-- FurrArmy Terminal v1.0

local monitor = peripheral.find("monitor") or term
monitor.setTextScale(0.5)

-- ======================
-- DATABASES
-- ======================

local users = {
    ["Guest"] = {password="1234", division="Guest", rank="Visitor", clearance=0},
    ["Mike"] = {password="1505", division="Federal Government", rank="FGC-1", clearance=5},
    ["FoxUnit"] = {password="abcd", division="Recon", rank="Scout", clearance=2},
    ["IronPaw"] = {password="pass", division="Engineering", rank="Technician", clearance=3}
}

local documents = {
    {
        title="Project Night Fang",
        clearance=5,
        content="Top secret bio-weapon project.\nStatus: ACTIVE"
    },
    {
        title="Guest Info",
        clearance=0,
        content="As a guest, you must follow these rules: ........."
    },
    {
        title="Recon Report #17",
        clearance=2,
        content="Enemy movement detected.\nCoordinates logged."
    },
    {
        title="Engine Core Manual",
        clearance=3,
        content="Core maintenance instructions.\nDo not overload."
    }
}

-- ======================
-- UTIL FUNCTIONS
-- ======================

local function slowPrint(text, speed)
    speed = speed or 0.02
    for i = 1, #text do
        monitor.write(text:sub(i,i))
        sleep(speed)
    end
    print()
end

local function centerText(y, text)
    local w, h = monitor.getSize()
    monitor.setCursorPos(math.floor((w - #text)/2), y)
    monitor.write(text)
end

local function clear()
    monitor.clear()
    monitor.setCursorPos(1,1)
end

-- ======================
-- BOOT ANIMATION
-- ======================

clear()
centerText(3, "Initializing FurrArmy Systems...")
sleep(1)

for i = 1, 20 do
    monitor.write("#")
    sleep(0.05)
end

sleep(0.5)
clear()

centerText(2, "FURRARMY TERMINAL")
centerText(4, "Secure Access System")
sleep(1.5)

-- ======================
-- LOGIN SYSTEM
-- ======================

local currentUser = nil

while true do
    clear()
    centerText(2, "LOGIN REQUIRED")

    monitor.setCursorPos(2,5)
    write("Username: ")
    local username = read()

    monitor.setCursorPos(2,7)
    write("Password: ")
    local password = read("*")

    if users[username] and users[username].password == password then
        currentUser = users[username]
        currentUser.name = username
        break
    else
        centerText(9, "ACCESS DENIED")
        sleep(2)
    end
end

-- ======================
-- USER INFO DISPLAY
-- ======================

clear()
slowPrint("Access Granted...\n", 0.03)
sleep(0.5)

slowPrint("Welcome " .. currentUser.name)
slowPrint("Division: " .. currentUser.division)
slowPrint("Rank: " .. currentUser.rank)

sleep(2)

-- ======================
-- MAIN MENU
-- ======================

while true do
    clear()
    centerText(2, "MAIN MENU")

    monitor.setCursorPos(2,5)
    print("1. View Documents")
    print("2. Logout")

    write("> ")
    local choice = read()

    if choice == "1" then
        -- DOCUMENT LIST
        while true do
            clear()
            centerText(2, "DOCUMENT DATABASE")

            local availableDocs = {}

            local y = 4
            for i, doc in ipairs(documents) do
                if currentUser.clearance >= doc.clearance then
                    monitor.setCursorPos(2,y)
                    print(i .. ". " .. doc.title)
                    table.insert(availableDocs, i)
                    y = y + 1
                end
            end

            monitor.setCursorPos(2,y+1)
            print("0. Back")

            write("> ")
            local docChoice = tonumber(read())

            if docChoice == 0 then break end

            local doc = documents[docChoice]

            if doc and currentUser.clearance >= doc.clearance then
                clear()
                centerText(2, doc.title)
                monitor.setCursorPos(2,4)

                slowPrint(doc.content, 0.01)

                print("\nPress Enter...")
                read()
            else
                print("ACCESS DENIED")
                sleep(1)
            end
        end

    elseif choice == "2" then
        currentUser = nil
        break
    end
end

-- Restart system after logout
os.reboot()
