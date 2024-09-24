ST = {} 
ST.Name="SurgicalTrauma"
ST.Version = "0.0.1"
ST.Path = table.pack(...)[1]

dofile(ST.Path.."/Lua/Autorun/Helperfunctions.lua")
dofile(ST.Path.."/Lua/Autorun/items.lua")
dofile(ST.Path.."/Lua/Autorun/blood.lua")
dofile(ST.Path.."/Lua/Autorun/update.lua")
dofile(ST.Path.."/Lua/Autorun/gui.lua")
if (Game.IsMultiplayer and SERVER) or not Game.IsMultiplayer then
    Timer.Wait(function() Timer.Wait(function()
        local runstring = "\n/// ____Running SurgicalTrauma____  "..ST.Version.." ///  \n Loading surgical trauma.... Subject \n 正在加载外科创伤....主体  \n"

        -- add dashes
        local linelength = string.len(runstring)+4
        local i = 0
        while i < linelength do runstring=runstring.."-" i=i+1 end


        -- No expansions
        runstring=runstring.."\n"
        if not hasAddons then
            runstring = runstring.."- Not running any expansions\n 目前未运行任何附件\n  "
        end
        print(package.path)
        print(runstring)
    end,1) end,3)
end