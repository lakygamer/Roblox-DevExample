local promt: ProximityPrompt = script.Parent
local gui: ScreenGui = script.PDCarSpawner
promt.Triggered:Connect(function(player: Player)
	local Cargui: ScreenGui = gui:Clone()
	Cargui.Parent = player.PlayerGui
	Cargui.Enabled = true
end)