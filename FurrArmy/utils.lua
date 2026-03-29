local utils = {}

function utils.slowPrint(text, delay)
    delay = delay or 0.03
    for i = 1, #text do
        write(text:sub(i,i))
        sleep(delay)
    end
    print()
end

function utils.centerText(mon, y, text)
    local w, _ = mon.getSize()
    mon.setCursorPos(math.floor((w - #text)/2), y)
    mon.write(text)
end

function utils.clear(mon)
    mon.setBackgroundColor(colors.black)
    mon.clear()
end

return utils
