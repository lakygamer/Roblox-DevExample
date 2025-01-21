local click = script.Parent.ClickDetector
click.MouseHoverEnter:Connect(function() script.Parent.ProximityPrompt.Enabled = true end)
click.MouseHoverLeave:Connect(function() script.Parent.ProximityPrompt.Enabled = false end)
script.Parent.Parent.Parent.AttributeChanged:Connect(function(atr)
	if script.Parent.Name == "open" and atr == "open" then
		if script.Parent.Parent.Parent:GetAttribute(atr) == true then
			script.Parent.ProximityPrompt.ActionText = "Close"
		else
			script.Parent.ProximityPrompt.ActionText = "Open"
		end
	elseif atr == "broken" then
		script.Parent.ClickDetector.MaxActivationDistance = 0
	end
end)