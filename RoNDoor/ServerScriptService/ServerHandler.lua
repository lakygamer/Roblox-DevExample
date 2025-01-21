--GLOBAL VAR
local Remotefunctions = game:GetService("ReplicatedStorage"):WaitForChild("Remote")
--DOOR HANDLER BEGIN
local Doors = game.Workspace:FindFirstChild("Doors")
Door = require(script.Parent.Door)


--door object (model=door,maxradius,locked,kickable,Hinge,intrestpoints,id)

local function promptinteraction(newDoor)
	for i,v:Part in pairs(newDoor.intrestpoints:GetChildren()) do
		if v:IsA("Part") then
			v.ProximityPrompt.Triggered:Connect(function(player)
				if v.Name == "open" then
					if newDoor.openstate then
						newDoor:close(player)
					else
						newDoor:open(player)
					end
				elseif v.Name == "kick" then
					newDoor:kick(player)
				elseif v.Name == "peek" then
					newDoor:peek(player)
				elseif v.Name == "video" then
					newDoor:video(player)
				end
			end)
		end
	end
end





local function Doorsetup(doormodel:Model,index)
	local newDoor = Door.new(doormodel,index)
	newDoor:setActive()
	promptinteraction(newDoor)
end




for i,v in pairs(Doors:GetChildren()) do  -- Loop through Doors in Door Folder
	if v:IsA("Model") then
		Doorsetup(v,i)
	end
end

--DOOR HANDLER END

--ACCESSORY HANDLER BEGIN
local Accessoryadd = Remotefunctions.Accessorys["Add-Accessory"]
local Accessoryremove = Remotefunctions.Accessorys["Remove-Accessory"]
local accessoryscript = require(script.Parent.Accessory)

Accessoryadd.OnServerEvent:Connect(function(player,accessoryname,attachmentpoint)
	if game.ServerStorage.Accessorys:FindFirstChild(accessoryname) then
		accessoryscript.add(game.ServerStorage.Accessorys[accessoryname],player,attachmentpoint)
	else
		warn("Accessory: "..accessoryname.." not found!")
	end
end)

Accessoryremove.OnServerEvent:Connect(function(player,accessoryname)
	accessoryscript.remove(accessoryname,player)
end)
