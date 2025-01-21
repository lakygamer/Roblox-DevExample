local TrafficControl = require(game:GetService("ServerScriptService"):WaitForChild("Traffic-Control"))
local Bridge = script.Parent
local Side1 = Bridge.Side1
local Side2 = Bridge.Side2
local Bridge1 = Side1.Bridge1
local Bridge2 = Side2.Bridge2
local Hinge1 = Bridge1.RoadPart.HingeConstraint
local Hinge2 = Bridge2.RoadPart.HingeConstraint
local Gatesmodel = {}
local TrafficLights = {}
local Gate = {}

local function setup()
    warn("Initializing Bridge Setup")
    -- Add GateModel to Table
    table.insert(Gatesmodel,Side1.GateL)
    table.insert(Gatesmodel,Side1.GateR)
    table.insert(Gatesmodel,Side2.GateL)
    table.insert(Gatesmodel,Side2.GateR)
    for i,v in pairs(Gatesmodel) do
        if v:FindFirstChild("Lights") then -- Add All Traffic Lights Found into Table
            table.insert(TrafficLights,v:FindFirstChild("Lights"))
        end
        if v:FindFirstChild("Door") then -- Add All Closing Opening Parts( Gate) into Table
            table.insert(Gate,v.Door)
        end
    end
end

local function reset() -- Set Bridge Conifg to reset position.
    warn("Bridge..reseting")
    Hinge1.TargetAngle = 0
    Hinge2.TargetAngle = 0
    wait()
    Bridge1.RoadPart.BridgeWeld.Enabled = true
    for i,v in pairs(TrafficLights) do -- Set Lights for all TrafficLights
        v.Green.GLight.Transparency = 0
        v.Green.GLight.SpotLight.Enabled = true
        v.Yellow.YLight.Transparency = 0.8
        v.Yellow.YLight.SpotLight.Enabled = false
        v.Red.RLight.Transparency = 0.8
        v.Red.RLight.SpotLight.Enabled = false
    end
    for i,v in pairs(Gate) do
        v.Parts.Pivot:WaitForChild("HingeConstraint").TargetAngle = 60 --Opend Angle
    end
end

local function changeactivity(up)
    if up then
        TrafficControl.Drawbridge(TrafficLights,Gate,Bridge1,Bridge2,true) -- Lower Bridge
    else
        TrafficControl.Drawbridge(TrafficLights,Gate,Bridge1,Bridge2,false) -- Raise Bridge
    end
end


setup()
reset()

task.spawn( function () --Loop
    while true do
        wait(10)
        changeactivity(true)
        wait(30) --Time to stay opend
        changeactivity(false)
        wait(20)
    end
end) 

