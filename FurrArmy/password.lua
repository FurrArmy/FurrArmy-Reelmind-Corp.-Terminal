local monitor = peripheral.find("monitor")
monitor.setTextScale(1)

local password = "1234"
local input = ""

-- Draw keypad
local function draw()
    monitor.clear()
    monitor.setCursorPos(1,1)
    monitor.write("Enter Password:")
    
    monitor.setCursorPos(1,3)
    monitor.write(input)

    local keys = {
        {"1","2","3"},
        {"4","5","6"},
        {"7","8","9"},
        {"C","0","OK"}
    }

    for y=1,4 do
        for x=1,3 do
            local label = keys[y][x]
            local posX = (x-1)*6 + 1
            local posY = y*2 + 2

            monitor.setCursorPos(posX, posY)
            monitor.write("["..label.."]")
        end
    end
end

-- Detect button click
local function getButton(x,y)
    local col = math.floor((x-1)/6)+1
    local row = math.floor((y-3)/2)

    local keys = {
        {"1","2","3"},
        {"4","5","6"},
        {"7","8","9"},
        {"C","0","OK"}
    }

    if keys[row] and keys[row][col] then
        return keys[row][col]
    end
end

-- Main loop
while true do
    draw()
    local event, side, x, y = os.pullEvent("monitor_touch")

    local button = getButton(x,y)

    if button then
        if button == "C" then
            input = ""
        elseif button == "OK" then
            monitor.clear()
            monitor.setCursorPos(1,1)

            if input == password then
                monitor.write("Access Granted")
                redstone.setOutput("back", true) -- open door
            else
                monitor.write("Access Denied")
                redstone.setOutput("back", false)
            end

            sleep(2)
            input = ""
        else
            input = input .. button
        end
    end
end
