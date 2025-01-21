local UserInputService = game:GetService("UserInputService")
local ButtonsHeld = {} -- Tracks buttons being held. Used to know when dragging
local LastMousePos = nil  -- Used to calculate how far mouse has moved
local mouse = game.Players.LocalPlayer:GetMouse()

local viewportRotation = {}
viewportRotation.__index = viewportRotation

function viewportRotation:Enable(viewportFrame)
	
	local viewportModel = viewportFrame:FindFirstChildWhichIsA("Model")
	-- Create and Bind Viewport
	local viewport = {
		inputChanged = nil;
		inputBegan = nil;
		inputEnded = nil;
	}
	setmetatable(viewport, viewportRotation)
	-- Rotate Model based on Mouse
	viewport.inputChanged = UserInputService.InputChanged:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement then -- runs every time mouse is moved
			if ButtonsHeld["MouseButton1"] then -- makes sure player is holding down right click

				local CurrentMousePos = Vector2.new(mouse.Y)
				local change = (CurrentMousePos - LastMousePos)/5 -- calculates distance mouse traveled (/5 to lower sensitivity)

				-- The angles part is weird here because of how the cube happens to be oriented. The angles may differ for other sections
				viewportModel:SetPrimaryPartCFrame(
					viewportModel:GetPrimaryPartCFrame() * CFrame.Angles(0,math.rad(change.X),0)
				)

				LastMousePos = CurrentMousePos
				-- This line makes everything possible. The PrimaryPart's orientation DOES NOT move the rest of the model with it. 
				viewportModel.PrimaryPart.Orientation = Vector3.new(0, 0, 0)
			end
		end
	end)
	-- Drag Detection
	viewport.inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then -- player starts dragging
			LastMousePos = Vector2.new( mouse.Y)
			ButtonsHeld["MouseButton1"] = true
		end
	end)
	-- Drag detection ended.
	viewport.inputEnded = UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then -- player stops dragging
			ButtonsHeld["MouseButton1"] = nil
			LastMousePos = nil
		end
	end)
	
	
	return viewport
end
-- Disconnect all Events
function viewportRotation:Disable(viewportFrame)
	
	self.inputChanged:Disconnect()
	self.inputBegan:Disconnect()
	self.inputEnded:Disconnect()
	
	
	
end

return viewportRotation
