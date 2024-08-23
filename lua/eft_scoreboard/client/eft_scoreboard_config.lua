-- The scoreboard's title, defaults to the server's name. 
-- You can also change it to a specified text (e.g. "The best Garry's Mod server").
EFT_Scoreboard_Config.Title = GetHostName()

-- The scoreboard's subtitle.
EFT_Scoreboard_Config.subTitle = {
    "It's just a scav run, it doesn't matter.",
    "Friendly scav!",
    "What's in your backpack?",
    "Just a quick raid!",
    "Did you bring your gamma case?",
    "Where are we?",
    "PMC or Scav?",
    "I'm not lost, I'm just exploring.",
    "Voip check?",
    "Is that you?",
    "Leg meta!",
    "I'm dead. Where?",
    "I heard something...",
    "Check your corners.",
    "Full auto to semi-auto in one second.",
    "Did you insure that?",
    "Can you hold my gear?",
    "Alt + F4 for a better extraction point.",
    "Blyat!",
    "Loot goblin mode activated."
}

-- The name displayed for the server user permission groups.
-- This will be useful if you're using an admin mod (e.g. ULX, SAM, xAdmin, sAdmin).
EFT_Scoreboard_Config.UserGroupName = {
    ["user"] = "User",
    ["operator"] = "Operator",
    ["admin"] = "Admin",
    ["superadmin"] = "Superadmin"
}

-- Same as above, but assigns based on Steam ID.
EFT_Scoreboard_Config.UserGroupNameSteamID = {
    ["STEAM_0:0:163616126"] = "Scoreboard Author"
}

-- You can customize the colors for some parts of the scoreboard.
EFT_Scoreboard_Config.ColorCustomization = {
    Title = Color(250, 250, 235),
    Background = Color(0, 0, 0, 200),
    Text = Color(180, 180, 180),
    highlightText = Color(220, 220, 220),
    sessionTime = Color(140, 140, 140),
    splitLine = Color(160, 160, 160),
    scrollBar = Color(210, 210, 210)
}