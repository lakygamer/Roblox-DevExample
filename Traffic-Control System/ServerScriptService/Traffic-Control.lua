local traffic = {}

function traffic.pedestrian  (Trafficlights,Walkboxes,on,activetime) -- Set Function mode for Pedestrian Walkes
    if on then
        for i,v in pairs(Trafficlights) do
            v.GreenLight.Transparency = 0.8
            v.GreenLight.SpotLight.Enabled = false
            v.YellowLight.Transparency = 0
            v.YellowLight.SpotLight.Enabled = true
            local thread = task.delay(2, function()
                v.RedLight.Transparency = 0
                v.RedLight.SpotLight.Enabled = true
                v.YellowLight.Transparency = 0.8
                v.YellowLight.SpotLight.Enabled = false
            end)
            --thread.cancel(thread)
        end
        -- Activate Walk Sign
        for i,v in pairs(Walkboxes) do
            local thread = task.delay(2, function()
                v.DontWalk.R.Lamp.Enabled = false
                v.Walk.G.Lamp.Enabled = true
                v.Walk.Number.Lamp.Enabled = true
            end)
            --thread.cancel(thread)
        end
        --Text Change countdown( Will stop the script in the Trafficlight)
        local i = 0
        wait(2) --Wait on the delayed tasks
        repeat --Text Changing
            for t,v in pairs(Walkboxes) do
                v.Walk.Number.Lamp.Number.Text = activetime-i-2
                if activetime-i == 2 then
                    v.Walk.Number.Lamp.Enabled = false
                    v.Walk.G.Lamp.Enabled = false
                    v.DontWalk.R.Lamp.Enabled = true
                end
            end
            wait(1)
            i = i+1
        until i == activetime
    else
        -- Reset traffic Lights
        for i,v in pairs(Trafficlights) do
            v.GreenLight.Transparency = 0
            v.GreenLight.SpotLight.Enabled = true
            v.YellowLight.Transparency = 0.8
            v.YellowLight.SpotLight.Enabled = false
            v.RedLight.Transparency = 0.8
            v.RedLight.SpotLight.Enabled = false
        end
        for i,v in pairs(Walkboxes) do
            v.DontWalk.R.Lamp.Enabled = true
            v.Walk.G.Lamp.Enabled = false
            v.Walk.Number.Lamp.Enabled = false
        end
    end
end

function traffic.Drawbridge (TrafficLight,Gate,Bridge1,Bridge2,on) -- Set Function mode for Drawbridge
    if on then
        --Set Lights red Activate Alarm
        for i,v in pairs(TrafficLight) do
            v.Green.GLight.Transparency = 0.8
            v.Green.GLight.SpotLight.Enabled = false
            v.Yellow.YLight.Transparency = 0
            v.Yellow.YLight.SpotLight.Enabled = true
            task.delay(2, function()
                v.Yellow.YLight.Transparency = 0.8
                v.Yellow.YLight.SpotLight.Enabled = false
                v.Red.RLight.Transparency = 0
                v.Red.RLight.SpotLight.Enabled = true
            end)
        end
        Bridge1.Parent.Sound.Alarm:Play()
        wait(4)
        -- Close Gates
        for i,v in pairs(Gate) do
            if v.Parent.Name == "GateR" then
                v.Parts.Pivot:WaitForChild("HingeConstraint").TargetAngle = 0
                Bridge1.Parent.Sound.Barrier:Play()
                task.delay(3.3,function()Bridge1.Parent.Sound.Barrier:Stop()end)
            else
                task.delay(10, function()
                    v.Parts.Pivot:WaitForChild("HingeConstraint").TargetAngle = 0
                    Bridge1.Parent.Sound.Barrier:Play()
                    task.delay(3.3,function()Bridge1.Parent.Sound.Barrier:Stop()end)
                end)
            end
        end
        --Open Bridge
        wait(20)
        Bridge1.RoadPart.BridgeWeld.Enabled = false
        Bridge1.Parent.Sound.Move:Play()
        Bridge1.RoadPart.HingeConstraint.TargetAngle = -60
        Bridge2.RoadPart.HingeConstraint.TargetAngle = -60
        wait(21.5) --Time to open
        Bridge1.Parent.Sound.Move:Stop()
        Bridge1.Parent.Sound.Stop:Play()
        wait(2)
        Bridge1.Parent.Sound.Alarm:Stop()
    else
        -- Reset to Closed State
        Bridge1.Parent.Sound.Alarm:Play()
        Bridge1.Parent.Sound.Move:Play()
        Bridge1.RoadPart.HingeConstraint.TargetAngle = 0
        Bridge2.RoadPart.HingeConstraint.TargetAngle = 0
        wait(21.5)
        Bridge1.Parent.Sound.Stop:Play()
        Bridge1.Parent.Sound.Move:Stop()
        Bridge1.Parent.Sound.Alarm:Stop()
        Bridge1.RoadPart.BridgeWeld.Enabled = true
        -- Reopen gates
        for i,v in pairs(TrafficLight) do
            task.delay(2, function()
                v.Red.RLight.Transparency = 0.8
                v.Red.RLight.SpotLight.Enabled = false
                v.Green.GLight.Transparency = 0
                v.Green.GLight.SpotLight.Enabled = true
            end)
        end
        for i,v in pairs(Gate) do
            v.Parts.Pivot:WaitForChild("HingeConstraint").TargetAngle = 60
            Bridge1.Parent.Sound.Barrier:Play()
            task.delay(3.3,function()Bridge1.Parent.Sound.Barrier:Stop()end)
        end
    end
end

function traffic.Tollstation (Trafficlights,Gate,open) -- Set Function Mode for Toll Stations
    if open then
        Gate.Parts.Pivot:WaitForChild("HingeConstraint").TargetAngle = 60
        wait(2.2)
        for i,v in pairs(Trafficlights) do
            if v:FindFirstChild("Red") then
                v.Red.RLight.Transparency = 0.8
                v.Red.RLight.SpotLight.Enabled = false
            end
            if v:FindFirstChild("Yellow") then
                v.Yellow.YLight.Transparency = 0.8
                v.Yellow.YLight.SpotLight.Enabled = false
            end
            if v:FindFirstChild("Green") then
                v.Green.GLight.Transparency = 0
                v.Green.GLight.SpotLight.Enabled = true
            end
        end
    else
        Gate.Parts.Pivot:WaitForChild("HingeConstraint").TargetAngle = 0
        for i,v in pairs(Trafficlights) do
            if v:FindFirstChild("Red") then
                v.Red.RLight.Transparency = 0
                v.Red.RLight.SpotLight.Enabled = true
            end
            if v:FindFirstChild("Yellow") then
                v.Yellow.YLight.Transparency = 0.8
                v.Yellow.YLight.SpotLight.Enabled = false
            end
            if v:FindFirstChild("Green") then
                v.Green.GLight.Transparency = 0.8
                v.Green.GLight.SpotLight.Enabled = false
            end
        end
        wait(2.7)
    end
end


return traffic
