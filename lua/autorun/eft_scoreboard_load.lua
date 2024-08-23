EFT_Scoreboard = EFT_Scoreboard or {}
EFT_Scoreboard_Config = EFT_Scoreboard_Config or {}

if (SERVER) then
    resource.AddSingleFile("resource/fonts/bender.ttf")
    resource.AddSingleFile("resource/fonts/bender-bold.ttf")
    resource.AddSingleFile("resource/fonts/bender-italic.ttf")
    resource.AddFile("materials/eft_scoreboard/split_line.png")
end

local function Load_EFT_Scoreboard_CL(path)
    if (not path:EndsWith("/")) then
        path = path.."/"
    end

    for _, file in pairs(file.Find(path.."*.lua", "LUA")) do
        local filePath = path .. file

        if (SERVER) then
            AddCSLuaFile(filePath)
        end

        if (CLIENT) then
            include(filePath)
        end
    end
end

local function Load_EFT_Scoreboard_SV(path)
    if (not path:EndsWith("/")) then
        path = path.."/"
    end

    for _, file in pairs(file.Find(path.."*.lua", "LUA")) do
        local filePath = path .. file

        if (SERVER) then
            include(filePath)
            AddCSLuaFile(filePath)
        end
    end
end

local dir = "eft_scoreboard"
Load_EFT_Scoreboard_CL(dir.."/client")
Load_EFT_Scoreboard_SV(dir.."/server")