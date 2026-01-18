local QRH = {}
local Logger = PrintHelper:New("QRH", {255, 255, 0})
Logger:EnableTag(true)
local IS_DEBUG = false

function QRH:InitializeAddon()

    self.addonName = "QuestRewardHint"
    self.addonFrame = CreateFrame("Frame", self.addonName .. "Frame", UIParent)

    -- Register events for "screen with selection" and "after selection done""
    self.addonFrame:RegisterEvent("QUEST_DETAIL")
    self.addonFrame:RegisterEvent("QUEST_COMPLETE")
    self.addonFrame:RegisterEvent("QUEST_FINISHED")
    -- TODO: Possibly also hook to quest view in quest log

    -- Things to keep in mind and implement
    -- 1. When QUEST_COMPLETE is fired, the quest rewards are displayed on the screen.
    -- 2. We need to compare the rewards to currently equipped player kit
    -- (we can get player kit using GetInventoryItemID("player", slotID))
    -- but we need to cache it beforehand (likely in events previous to quest being ready to be compelted, and periodically - in case player equips something else in the meantime)
    -- could be possibly smarter by checking only when player equips something new
    -- 3. Way for player to indicate preference (to decide what is upgrade vs gold -> which stats to prio)

    self.addonFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "QUEST_COMPLETE" then
            QRH:OnQuestComplete()
        elseif event == "QUEST_FINISHED" then
            QRH:OnQuestFinished()
        elseif event == "QUEST_DETAIL" then
            print(Logger:ColorText("QUEST_DETAIL event fired.", "yellow"))
        end
    end)


    print(Logger:ColorText("QuestRewardHint initialized.", "green"))
end

QRH:InitializeAddon()

function QRH:OnQuestComplete()
    -- (1) Test with quest that has no choices (all rewards are given)
    -- (2) Test with quest that has multiple choices
    -- (3) Test with quest that has single choice
    -- (4) Test with quest that has choices and also gives some non-choice rewards

    -- Get number of choices available before quest completes.
    local numChoices = GetNumQuestChoices()
    if numChoices == 0 then
        print(Logger:ColorText("No quest choices available.", "orange"))
        return
    end

    print(Logger:ColorText("QUEST_COMPLETE event fired.", "yellow"))
end

function QRH:OnQuestFinished()
    print(Logger:ColorText("QUEST_FINISHED event fired.", "yellow"))
end

function QRH:CreateOverlayForButton(button)
    -- Ensure we don't create multiple overlays
    if button.MyOverlay then return end

    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints(button)
    overlay:SetFrameLevel(button:GetFrameLevel() + 5)

    local tex = overlay:CreateTexture(nil, "OVERLAY")
    tex:SetAllPoints(overlay)
    tex:SetColorTexture(0, 1, 0, 0.35)  -- Semi-transparent green

    overlay.texture = tex
    button.MyOverlay = overlay

end