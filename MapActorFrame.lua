local args = ...
local g = args[1]
local map_data = args[2]

local Update = function(self, delta)
	g.map.af:playcommand("UpdateAMV", {delta})
end

local map_af = Def.ActorFrame{
	Name="Map ActorFrame",

	InitCommand=function(self)
		g.map.af = self

		self:GetChild("Map"..g.CurrentMap):playcommand("MoveMap")
	end,
	OnCommand=function(self)
		self:GetChild("Map1"):visible(true)
		self:queuecommand("AllowInput")
	end,
	AllowInputCommand=function(self)
		local screen = SCREENMAN:GetTopScreen()
		screen:SetUpdateFunction( Update )
		screen:AddInputCallback( LoadActor("InputHandler.lua", {map_data, g}) )
	end,
	TweenMapCommand=function(self)
		self:stoptweening():linear(g.SleepDuration):GetChild("Map"..g.CurrentMap):playcommand("MoveMap")
	end,
}

-- add maps to the map_af
for map_index,map in ipairs(map_data) do
	map_af[#map_af+1] = LoadActor("AMV-Map.lua" ,{g, map, map_index})..{ Name="Map"..map_index }
end


return map_af