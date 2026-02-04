-- Services

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables

local Stats = Players.LocalPlayer:WaitForChild("Stats")
local Points = Stats:WaitForChild("Points")
local GameLoaded = ReplicatedStorage:WaitForChild("GameLoaded")

-- UI

local MainFrame = script.Parent.Parent

local PointsUI = MainFrame:WaitForChild("FramesBtn"):WaitForChild("Points"):WaitForChild("TextLabel")

-- Functions

local function FormatNumber(number)
	if number >= 1_000_000 then
		return string.format("%.1fM", number / 1_000_000)
	elseif number >= 100_000 then
		return string.format("%.0fk", number / 1_000)
	else
		return tostring(number):reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")
	end
end


RunService.Heartbeat:Connect(function()
	PointsUI.Text = FormatNumber(Points.Value)
end)

task.wait(2)
GameLoaded:FireServer("PointsPerSecondTab")