local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local rotateflag = ReplicatedStorage:WaitForChild("UGCRotate")

local UGCS = {
	workspace:WaitForChild("UGC1"),
	workspace:WaitForChild("UGC2"),
	workspace:WaitForChild("UGC3"),
	workspace:WaitForChild("UGC4"),
	workspace:WaitForChild("UGC5"),
	workspace:WaitForChild("UGC6"),
	workspace:WaitForChild("UGC7"),
	workspace:WaitForChild("UGC8"),
}

local rotating = rotateflag.Value

rotateflag.Changed:Connect(function()
	rotating = rotateflag.Value
end)

RunService.Heartbeat:Connect(function(dt)
	if not rotating then return end
	for _, ugc in ipairs(UGCS) do
		ugc:PivotTo(ugc:GetPivot() * CFrame.Angles(0, 3 * dt, 0))
	end
end)