-- Services

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables

local LoadingFrame = script.Parent
local UI = LoadingFrame.UI
local JoinButton = UI.JoinGame

local TweenScript = script.Parent.TweenBackground

local GameLoaded = ReplicatedStorage:WaitForChild("GameLoaded")

local TweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

-- Functions

local function TweenUI()
	local Tween = TweenService:Create(LoadingFrame, TweenInfo, {Position = UDim2.new(0, 0, 1, 0)})
	Tween:Play()
	
	Tween.Completed:Connect(function()
		TweenScript.Enabled = false
	end)
end

-- Start

JoinButton.MouseButton1Click:Connect(function()
	TweenUI()
end)