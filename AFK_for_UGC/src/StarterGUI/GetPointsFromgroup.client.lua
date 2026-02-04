-- Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GroupService = game:GetService("GroupService")
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

-- Variables

local CheckGroup = ReplicatedStorage:WaitForChild("Points"):WaitForChild("CheckGroup")
local GameLoaded = ReplicatedStorage:WaitForChild("GameLoaded")

local MainFrame = script.Parent.Parent

local CheckButton = MainFrame:WaitForChild("Tabs"):WaitForChild("FreePointsTab"):WaitForChild("RedeemButton")
local JoinButton = MainFrame:WaitForChild("Tabs"):WaitForChild("FreePointsTab"):WaitForChild("JoinButton")

local ErrorTab = MainFrame:WaitForChild("Tabs"):WaitForChild("ErrorTab")
local ErrorStroke = ErrorTab:WaitForChild("UIStroke")
local ErrorLabel = ErrorTab:WaitForChild("ErrorLabel")

local tweeninfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

-- functions

local function WarningVisibilityOn()
	ErrorTab.Visible = true
	local Tween = TweenService:Create(ErrorTab, tweeninfo, {BackgroundTransparency = 0})
	local Tween2 = TweenService:Create(ErrorStroke, tweeninfo, {Transparency = 0})
	local Tween3 = TweenService:Create(ErrorLabel, tweeninfo, {TextTransparency = 0})

	task.spawn(function()
		Tween:Play()
		Tween2:Play()
		Tween3:Play()
	end)
end

local function WarningVisibilityOff()
	local Tween = TweenService:Create(ErrorTab, tweeninfo, {BackgroundTransparency = 1})
	local Tween2 = TweenService:Create(ErrorStroke, tweeninfo, {Transparency = 1})
	local Tween3 = TweenService:Create(ErrorLabel, tweeninfo, {TextTransparency = 1})

	task.spawn(function()
		Tween:Play()
		Tween2:Play()
		Tween3:Play()
	end)
	Tween3.Completed:Connect(function()
		ErrorTab.Visible = false
	end)
end

-- Connections

JoinButton.MouseButton1Click:Connect(function()
	GroupService:PromptJoinAsync(35856053)
end)

CheckButton.MouseButton1Click:Connect(function()
	CheckGroup:FireServer()
end)

CheckGroup.OnClientEvent:Connect(function(ok, status)
	if not ok then
		CheckButton.Text = "REDEEMED"
		CheckButton.Interactable = false

		ErrorLabel.Text = tostring(status)
		WarningVisibilityOn()
		task.wait(1.5)
		WarningVisibilityOff()
	else
		if status == "not_in_group" then
			CheckButton.Text = "JOIN GROUP FIRST"
			task.wait(5)
			CheckButton.Text = "REDEEM"
		elseif status == "already_claimed" then
			CheckButton.Text = "ALREADY REDEEMED"
			CheckButton.Interactable = false
		elseif status == "claimed" then
			CheckButton.Interactable = false
			CheckButton.Text = "REDEEMED"
		end
	end
end)

task.wait(5)
GameLoaded:FireServer("PointsTab")