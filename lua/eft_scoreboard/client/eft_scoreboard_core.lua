EFT_Scoreboard.Title = EFT_Scoreboard.Title or {}
EFT_Scoreboard.Frame = EFT_Scoreboard.Frame or {}
EFT_Scoreboard.Main = EFT_Scoreboard.Main or {}
EFT_Scoreboard.InfoBar = EFT_Scoreboard.InfoBar or {}
EFT_Scoreboard.Player = EFT_Scoreboard.Player or {}
EFT_Scoreboard.playerConnectionTime = EFT_Scoreboard.playerConnectionTime or {}

local blurIntensity = 3

local scrw, scrh = ScrW(), ScrH()
local base_w, base_h = 1920, 1080

local scaleX = scrw / base_w
local scaleY = scrh / base_h

local mat_blur = Material("pp/blurscreen")
local mat_split = Material("eft_scoreboard/split_line.png")

local draw_SimpleText = draw.SimpleText
local draw_RoundedBox = draw.RoundedBox

local surface_DrawRect = surface.DrawRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor  = surface.SetDrawColor

net.Receive("EFT_Scoreboard_PlayerConnectionTime", function()
    EFT_Scoreboard.playerConnectionTime = net.ReadTable()
end)

surface.CreateFont("EFTSB_Title", {
    font = "Bender",
    extended = true,
    size = ScreenScale(16),
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

surface.CreateFont("EFTSB_subTitle", {
    font = "Bender",
    extended = true,
    size = ScreenScale(7),
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

surface.CreateFont("EFTSB_labelText", {
    font = "Bender Bold",
    extended = true,
    size = ScreenScale(6),
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

surface.CreateFont("EFTSB_ilabelText", {
    font = "Bender Italic",
    extended = true,
    size = ScreenScale(6),
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

surface.CreateFont("EFTSB_serialNumber", {
    font = "Bender Italic",
    extended = true,
    size = ScreenScale(10),
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

surface.CreateFont("EFTSB_Number", {
    font = "Bender Italic",
    extended = true,
    size = ScreenScale(11),
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

surface.CreateFont("EFTSB_Text", {
    font = "Bender Bold",
    extended = true,
    size = ScreenScale(7),
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

function EFT_Scoreboard.MathRound(num, decimal)
    local mult = 10 ^ (decimal or 0)
    return math.floor(num * mult + 0.5) / mult
end

function EFT_Scoreboard.CalculateKD(k, d)
    if (d == 0) then
        if (k > 0) then
            return k
        else
            return 0
        end
    end

    return EFT_Scoreboard.MathRound(k / d, 2)
end

function EFT_Scoreboard.Title:Init()
    self:SetSize(scrw, scrh * 0.1)
    self:SetPos(0, 0)

    local randomIndex = math.random(1, #EFT_Scoreboard_Config.subTitle)
    self.randomSubTitle = EFT_Scoreboard_Config.subTitle[randomIndex]
end

function EFT_Scoreboard.Title:Paint(w, h)
    draw_SimpleText(string.upper(EFT_Scoreboard_Config.Title), "EFTSB_Title", w * 0.5, h * 0.4, EFT_Scoreboard_Config.ColorCustomization.Title, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw_SimpleText(self.randomSubTitle, "EFTSB_subTitle", w * 0.5, h * 0.7, EFT_Scoreboard_Config.ColorCustomization.Title, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("EFT_Scoreboard.Title", EFT_Scoreboard.Title, "DPanel")

function EFT_Scoreboard.Frame:Init()
    self:SetTitle("")
    self:SetSize(scrw * 0.5, scrh * 0.6)
    self:Center()
    self:MakePopup()
    self:ShowCloseButton(false)
    self:SetDraggable(false)
    self:DockPadding(0, 0, 0, 0)
end

function EFT_Scoreboard.Frame:Paint(w, h)
    local x, y = self:LocalToScreen(0, 0)
    
    surface_SetDrawColor(color_white)
    surface_SetMaterial(mat_blur)

    mat_blur:SetFloat("$blur", blurIntensity)
    mat_blur:Recompute()

    render.UpdateScreenEffectTexture()

    for i = 1, 5 do
        surface_DrawTexturedRect(-x, -y, scrw, scrh)
    end

    surface_SetDrawColor(EFT_Scoreboard_Config.ColorCustomization.Background)
    surface_DrawRect(0, 0, w, h)
end

vgui.Register("EFT_Scoreboard.Frame", EFT_Scoreboard.Frame, "DFrame")

function EFT_Scoreboard.Main:Init()
    self.infoBar = self:Add("EFT_Scoreboard.InfoBar")
    self.infoBar:Dock(TOP)
    self.infoBar:AddLabel("#", 75)
    self.infoBar:AddLabel("TIME", 130)
    self.infoBar:AddLabel("PLAYER", 325)
    self.infoBar:AddLabel("K/D", 105)
    self.infoBar:AddLabel("KILLS", 105)
    self.infoBar:AddLabel("DEATHS", 105)
    self.infoBar:AddLabel("PING", nil)

    self.scrollBar = self:Add("DScrollPanel")
    self.scrollBar:Dock(FILL)

    local scrollBar = self.scrollBar:GetVBar()
    scrollBar:SetWide(8 * scaleX)

    function scrollBar:Paint(w, h) end

    function scrollBar.btnUp:Paint(w, h) end

    function scrollBar.btnDown:Paint(w, h) end

    function scrollBar.btnGrip:Paint(w, h)
        draw_RoundedBox(0, 0, 0, w, h, EFT_Scoreboard_Config.ColorCustomization.scrollBar)
    end

    self.serial = 1
    self.playerPanels = {}
    for _, ply in pairs(player.GetAll()) do
        local pp = self.scrollBar:Add("EFT_Scoreboard.Player")
        pp:Dock(TOP)
        pp:SetPlayer(ply, self.serial)
        self.playerPanels[pp] = true
        self.serial = self.serial + 1
    end
end

function EFT_Scoreboard.Main:PerformLayout(w, h)
    self.infoBar:SetTall(60 * scaleY)

    if (self.playerPanels) then
        for k, _ in pairs(self.playerPanels) do
            if (not IsValid(k)) then
                self.playerPanels[k] = nil
            end
            k:SetTall(80 * scaleY)
        end
    end
end

vgui.Register("EFT_Scoreboard.Main", EFT_Scoreboard.Main, "EFT_Scoreboard.Frame")

function EFT_Scoreboard.InfoBar:Init()
    self.labels = {}
end

function EFT_Scoreboard.InfoBar:AddLabel(text, wide, alignX, alignY)
    local label = self:Add("DPanel")
    self.labels[#self.labels + 1] = label

    if (wide) then
        label:Dock(LEFT)
        label:SetWide(wide * scaleX)
    else
        label:Dock(FILL)
    end

    local font = "EFTSB_labelText"
    if (text == "#") then
        font = "EFTSB_ilabelText"
    end

    label.Paint = function(self, w, h)
        if (text == "TIME" or text == "PLAYER") then
            draw_SimpleText(text, font, 0, h / 2, EFT_Scoreboard_Config.ColorCustomization.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw_SimpleText(text, font, w / 2, h / 2, EFT_Scoreboard_Config.ColorCustomization.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

vgui.Register("EFT_Scoreboard.InfoBar", EFT_Scoreboard.InfoBar, "Panel")

function EFT_Scoreboard.Player:SetPlayer(ply, num)
    self.ply = ply

    self.serialNum = self:Add("DPanel")
    self.serialNum:Dock(LEFT)
    self.serialNum:SetWide(75 * scaleX)
    self.serialNum.Paint = function(self, w, h)
        draw_SimpleText(tostring(num), "EFTSB_serialNumber", w / 2, h / 2, EFT_Scoreboard_Config.ColorCustomization.highlightText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.playerConnectionTime = self:Add("DPanel")
    self.playerConnectionTime:Dock(LEFT)
    self.playerConnectionTime:SetWide(130 * scaleX)
    self.playerConnectionTime.Paint = function(self, w, h)
        local connectionTime = EFT_Scoreboard.playerConnectionTime[ply:SteamID()]
        local sessionTime = connectionTime and os.date("!%X", os.time() - connectionTime) or "00:00:00"

        draw_SimpleText(sessionTime, "EFTSB_Number", 0, h / 2, EFT_Scoreboard_Config.ColorCustomization.sessionTime, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

	self.playerAvatar = self:Add("AvatarImage")
	self.playerAvatar:Dock(LEFT)
	self.playerAvatar:SetPlayer(ply, 64)
    self.playerAvatar:SetWide(64 * scaleX)
    self.playerAvatar:DockMargin(0, 8 * scaleY, 0, 8 * scaleY)

    self.playerInfo = self:Add("DPanel")
    self.playerInfo:Dock(LEFT)
    self.playerInfo:SetWide(241 * scaleX)
    self.playerInfo:DockMargin(20 * scaleX, 15 * scaleY, 0, 15 * scaleY)
    self.playerInfo.Paint = function(self, w, h)
        draw_SimpleText(ply:GetName(), "EFTSB_Text", 0, 0, EFT_Scoreboard_Config.ColorCustomization.highlightText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw_SimpleText(EFT_Scoreboard_Config.UserGroupNameSteamID[ply:SteamID()] or EFT_Scoreboard_Config.UserGroupName[ply:GetUserGroup()], "EFTSB_Text", 0, h, EFT_Scoreboard_Config.ColorCustomization.highlightText, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end

    self.playerKDRatio = self:Add("DPanel")
    self.playerKDRatio:Dock(LEFT)
    self.playerKDRatio:SetWide(105 * scaleX)
    self.playerKDRatio.Paint = function(self, w, h)
        draw_SimpleText(EFT_Scoreboard.CalculateKD(ply:Frags(), ply:Deaths()), "EFTSB_Number", w / 2, h / 2, EFT_Scoreboard_Config.ColorCustomization.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.playerKillsAmount = self:Add("DPanel")
    self.playerKillsAmount:Dock(LEFT)
    self.playerKillsAmount:SetWide(105 * scaleX)
    self.playerKillsAmount.Paint = function(self, w, h)
        draw_SimpleText(ply:Frags(), "EFTSB_Number", w / 2, h / 2, EFT_Scoreboard_Config.ColorCustomization.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.playerDeathsAmount = self:Add("DPanel")
    self.playerDeathsAmount:Dock(LEFT)
    self.playerDeathsAmount:SetWide(105 * scaleX)
    self.playerDeathsAmount.Paint = function(self, w, h)
        draw_SimpleText(ply:Deaths(), "EFTSB_Number", w / 2, h / 2, EFT_Scoreboard_Config.ColorCustomization.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.playerPing = self:Add("DPanel")
    self.playerPing:Dock(FILL)
    self.playerPing.Paint = function(self, w, h)
        draw_SimpleText(ply:Ping(), "EFTSB_Number", w / 2, h / 2, EFT_Scoreboard_Config.ColorCustomization.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function EFT_Scoreboard.Player:Paint(w, h)
    if (player.GetCount() < 2) then return end
    if (self.ply and IsValid(self.ply)) then
        surface_SetDrawColor(EFT_Scoreboard_Config.ColorCustomization.splitLine)
        surface_SetMaterial(mat_split)
        surface_DrawTexturedRect(0, 0, w, h)
    end
end

vgui.Register("EFT_Scoreboard.Player", EFT_Scoreboard.Player, "DPanel")

local function EFT_Scoreboard_Open()
    if (IsValid(EFT_Scoreboard_Main)) then
        EFT_Scoreboard_Main:Remove()
    end

    EFT_Scoreboard_Main = vgui.Create("EFT_Scoreboard.Main")

    if (IsValid(EFT_Scoreboard_Title)) then
        EFT_Scoreboard_Title:Remove()
    end

    EFT_Scoreboard_Title = vgui.Create("EFT_Scoreboard.Title")

    return true
end
hook.Add("ScoreboardShow", "EFT_Scoreboard_Open", EFT_Scoreboard_Open)

local function EFT_Scoreboard_Close()
    if (IsValid(EFT_Scoreboard_Main)) then
        EFT_Scoreboard_Main:Remove()
    end

    if (IsValid(EFT_Scoreboard_Title)) then
        EFT_Scoreboard_Title:Remove()
    end
end
hook.Add("ScoreboardHide", "EFT_Scoreboard_Close",EFT_Scoreboard_Close)