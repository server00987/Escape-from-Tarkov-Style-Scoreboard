local playerConnectionTime = playerConnectionTime or {}

util.AddNetworkString("EFT_Scoreboard_PlayerConnectionTime")

local function EFT_Scoreboard_RecordConnectionTime(ply)
    local steamID = ply:SteamID()

    playerConnectionTime[steamID] = os.time()

    net.Start("EFT_Scoreboard_PlayerConnectionTime")
    net.WriteTable(playerConnectionTime)
    net.Broadcast()
end
hook.Add("PlayerInitialSpawn", "EFT_Scoreboard_RecordConnectionTime", EFT_Scoreboard_RecordConnectionTime)

local function EFT_Scoreboard_ClearConnectionTime(ply)
    if (ply and ply.SteamID) then
        playerConnectionTime[ply:SteamID()] = nil
    end
end
hook.Add("PlayerDisconnected", "EFT_Scoreboard_ClearConnectionTime", EFT_Scoreboard_ClearConnectionTime)