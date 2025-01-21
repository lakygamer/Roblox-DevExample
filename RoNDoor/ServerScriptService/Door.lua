local door = {}
door.__index=door


function door.new(doormodel:model,id)
	local newdoor = {}
	setmetatable(newdoor,door)
	
	newdoor.model = doormodel
	newdoor.maxradius = newdoor.model:GetAttribute("maxradius") or false
	newdoor.locked = newdoor.model:GetAttribute("locked") or false
	newdoor.kickable = newdoor.model:GetAttribute("kickable") or false
	newdoor.openstate = newdoor.model:GetAttribute("open") or false
	newdoor.hinge = newdoor.model.Door:FindFirstChild("HingeConstraint") or warn("No Door Found! Exiting function for "..newdoor.model.Name)
	newdoor.intrestpoints = newdoor.model:FindFirstChild("intrestpoints") or error("No intrestpoints. Exiting function for"..newdoor.model.Name)
	newdoor.openspeed = newdoor.model:GetAttribute("openspeed") or 5
	newdoor.peekspeed = newdoor.model:GetAttribute("peekspeed") or 10
	newdoor.broken = newdoor.model:GetAttribute("broken") or false
	newdoor.id = id	
	
	return newdoor
end

function door:peek(player)
	if self.broken then return end
	print(" Peeking "..self.model.name.." by "..player.Name)
	self.hinge.AngularSpeed = self.peekspeed
	-- Calculate the side to open
	local playerpos = player.Character.HumanoidRootPart.Position
	local doorlookvector = self.model.Door.CFrame.LookVector
	local dotvector = doorlookvector:Dot(player.Character.HumanoidRootPart.CFrame.LookVector)
	if dotvector < 0 then 
		self.hinge.TargetAngle += 15
	else 
		self.hinge.TargetAngle += -15
	end
	self.hinge.LowerAngle = -(self.maxradius)
	self.hinge.UpperAngle = self.maxradius
	self.model:SetAttribute("open",true)
	self.openstate = true
end

function door:open(player)
	if self.broken then return end
	print(" Open "..self.model.name.." by "..player.Name)
	self.hinge.AngularSpeed = self.openspeed
	self.hinge.LowerAngle = -(self.maxradius)
	self.hinge.UpperAngle = self.maxradius
	local playerpos = player.Character.HumanoidRootPart.Position
	local doorlookvector = self.model.Door.CFrame.LookVector
	local dotvector = doorlookvector:Dot(player.Character.HumanoidRootPart.CFrame.LookVector)
	if dotvector < 0 then 
		self.hinge.TargetAngle = self.maxradius
		task.delay(2.5,function() self.hinge.UpperAngle = (self.maxradius) self.hinge.LowerAngle = (self.maxradius)end)
	else 
		self.hinge.TargetAngle = -(self.maxradius)
		task.delay(2.5,function() self.hinge.UpperAngle = -(self.maxradius) self.hinge.LowerAngle = -(self.maxradius)end)
	end
	self.model:SetAttribute("open",true)
	self.openstate = true
end

function door:kick(player)
	if self.broken then return end
	if self.kickable then
		--animation
		local animator:Animator = player.Character:FindFirstChild("Humanoid"):WaitForChild("Animator")
		local kickanimation = game.ServerStorage.Animations.Kick
		local animation = animator:LoadAnimation(kickanimation)
		self.hinge.AngularSpeed = 300
		
		--sound
		--animation
		
		self.hinge.LowerAngle = -(self.maxradius)
		self.hinge.UpperAngle = self.maxradius
		local playerpos = player.Character.HumanoidRootPart.Position
		local doorlookvector = self.model.Door.CFrame.LookVector
		local dotvector = doorlookvector:Dot(player.Character.HumanoidRootPart.CFrame.LookVector)
		if dotvector < 0 then 
			player.Character:MoveTo(self.model.animationpoint.frontKick.Position)
			player.Character:PivotTo(CFrame.lookAt(player.Character.PrimaryPart.Position, self.model.Door.Position))
			player.Character.HumanoidRootPart.Anchored = true
			animation:Play()
			wait(0.4)
			task.delay(0.55,function()player.Character.HumanoidRootPart.Anchored = false end)
			self.hinge.TargetAngle = self.maxradius
			task.delay(2.5,function() self.hinge.UpperAngle = (self.maxradius) self.hinge.LowerAngle = (self.maxradius)end)
		else 
			player.Character:MoveTo(self.model.animationpoint.backKick.Position)
			player.Character:PivotTo(CFrame.lookAt(player.Character.PrimaryPart.Position, self.model.Door.Position))
			player.Character.HumanoidRootPart.Anchored = true
			animation:Play()
			wait(0.4)
			task.delay(0.55,function()player.Character.HumanoidRootPart.Anchored = false end)
			self.hinge.TargetAngle = -(self.maxradius)
			task.delay(2.5,function() self.hinge.UpperAngle = -(self.maxradius) self.hinge.LowerAngle = -(self.maxradius)end)
		end
		self.hinge.ServoMaxTorque = 20000
		task.delay(1.5,function() self.hinge.ServoMaxTorque=150 end)
		self.model:SetAttribute("broken",true)
		self.broken = true
		self.openstate = true
	end
end
function door:picklock(player)
	if self.broken then return end
	print(" lockpicking "..self.model.name.." by "..player.Name)
end
function door:close(player)
	if self.broken then return end
	print(" Closing "..self.model.name.." by "..player.Name)
	--Cancollide false to mitigate getting pushed
	self.model.Door.CanCollide = false
	self.hinge.AngularSpeed = self.openspeed
	self.hinge.TargetAngle = 0
	task.delay(2,function()self.hinge.LowerAngle = 0  self.hinge.UpperAngle = 0 end)
	self.model:SetAttribute("open",false)
	self.openstate = false
	self.model.Door.CanCollide = true	
end

function door:video(player)
	if self.broken or self.openstate then return end
	print("Videoscope "..self.model.name.." by "..player.Name)
	-- Changes need to made. First not working secondly might be having trouble with viewport view from tool system.
	--[[local playerpos = player.Character.HumanoidRootPart.Position
	local doorlookvector = self.model.Door.CFrame.LookVector
	local dotvector = doorlookvector:Dot(player.Character.HumanoidRootPart.CFrame.LookVector)
	local camera = workspace.CurrentCamera
	player.Character.HumanoidRootPart.Anchored = true
	if dotvector < 0 then
		--backview
		local view = self.model.viewpoints.backview
		print("Doing")
		while camera.CameraType == not Enum.CameraType.Scriptable do
			camera.CameraType = Enum.CameraType.Scriptable
		end
		camera.CFrame = view.CFrame
		camera.CameraSubject = view
		wait(5)
	else
		--frontview
		print("Front Doing")
		local view = self.model.viewpoints.frontview
		while camera.CameraType == not Enum.CameraType.Scriptable do
			camera.CameraType = Enum.CameraType.Scriptable
		end
		camera.CFrame = view.CFrame
		camera.CameraSubject = view
		wait(5)
	end
	camera.CameraType = Enum.CameraType.Custom
	player.Character.HumanoidRootPart.Anchored = false]]--
end

function door:setActive()
	for i,v:Part in pairs(self.intrestpoints:GetChildren()) do
		if v:IsA("Part") and ((v.Name == "kick" and self.kickable == true)  or v.Name ~= "kick") then
			local funcscript = script.handler:Clone()
			funcscript.Parent = v
			funcscript.Enabled = true
		end
	end
end

function door:setInactive()
	for i,v:Part in pairs(self.intrestpoints:GetChildren()) do
		if v:IsA("Part") and v:FindFirstChild("handler") then
			v.handler:Destroy()
		end
	end 
end
return door
