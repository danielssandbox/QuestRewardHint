HelperFunc = HelperFunc or {}

local HFLog = PrintHelper:New("QRH", {255, 255, 0})
HFLog:EnableTag(true)

function HelperFunc.isInList(list, value)
    for _, v in ipairs(list) do
        if v == value then
            return true
        end
    end

    return false
end

