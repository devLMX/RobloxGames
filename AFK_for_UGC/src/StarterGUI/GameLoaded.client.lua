-- Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Variables

local GameLoaded = ReplicatedStorage:WaitForChild("GameLoaded")

local totalSteps = 5
local done = {}
local completed = 0

local LoadGUI = script.Parent.Parent
local JoinGame = LoadGUI:WaitForChild("LoadingFrame"):WaitForChild("UI"):WaitForChild("JoinGame")
local Bar = LoadGUI:WaitForChild("LoadingFrame"):WaitForChild("UI"):WaitForChild("Bar"):WaitForChild("Bar")

local tweeninfo1 = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local tweeninfo2 = TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

-- Functions

local function update()
	local progress = completed / totalSteps
	TweenService:Create(Bar, tweeninfo1, { Size = UDim2.new(progress, 0, 1, 0) }):Play()
end

GameLoaded.OnClientEvent:Connect(function(stepId)
	if done[stepId] then return end
	done[stepId] = true
	completed += 1
	update()
	if completed == totalSteps then
		task.wait(0.8)
		JoinGame.Visible = true
		TweenService:Create(JoinGame, tweeninfo2, { Position = UDim2.new(0.43, 0,0.537, 0) }):Play()
	end
end)

update()