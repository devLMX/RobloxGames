-- Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game.Players

-- Variables

local CheckDay = ReplicatedStorage:WaitForChild("Points"):WaitForChild("CheckDay")
local CheckDaily = ReplicatedStorage:WaitForChild("Points"):WaitForChild("CheckDaily")
local GameLoaded = ReplicatedStorage:WaitForChild("GameLoaded")

local MainFrame = script.Parent.Parent

local ErrorTab = MainFrame:WaitForChild("Tabs"):WaitForChild("ErrorTab")
local ErrorLabel = ErrorTab:WaitForChild("ErrorLabel")
local ErrorStroke = ErrorTab:WaitForChild("UIStroke")

local DailyRewardsTab = MainFrame:WaitForChild("Tabs"):WaitForChild("DailyRewardsTab")
local ScrollFrame = DailyRewardsTab:WaitForChild("ScrollingFrame")

local Day1 = ScrollFrame:WaitForChild("Day1")
local Day2 = ScrollFrame:WaitForChild("Day2")
local Day3 = ScrollFrame:WaitForChild("Day3")
local Day4 = ScrollFrame:WaitForChild("Day4")
local Day5 = ScrollFrame:WaitForChild("Day5")
local Day6 = ScrollFrame:WaitForChild("Day6")
local Day7 = ScrollFrame:WaitForChild("Day7")

local ClaimedDays = {
	Day1:WaitForChild("Claimed"),
	Day2:WaitForChild("Claimed"),
	Day3:WaitForChild("Claimed"),
	Day4:WaitForChild("Claimed"),
	Day5:WaitForChild("Claimed"),
	Day6:WaitForChild("Claimed"),
	Day7:WaitForChild("Claimed")
}

local NotClaimedDays = {
	Day1:WaitForChild("NotClaimed"),
	Day2:WaitForChild("NotClaimed"),
	Day3:WaitForChild("NotClaimed"),
	Day4:WaitForChild("NotClaimed"),
	Day5:WaitForChild("NotClaimed"),
	Day6:WaitForChild("NotClaimed"),
	Day7:WaitForChild("NotClaimed")
}

local ClaimButtonDay = {
	Day1:WaitForChild("ClaimButton"),
	Day2:WaitForChild("ClaimButton"),
	Day3:WaitForChild("ClaimButton"),
	Day4:WaitForChild("ClaimButton"),
	Day5:WaitForChild("ClaimButton"),
	Day6:WaitForChild("ClaimButton"),
	Day7:WaitForChild("ClaimButton")
}

local tweeninfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

-- function

local function DayVisibility(allowedDay, progress, status)
	for i = 1, 7 do
		ClaimButtonDay[i].Active = false
		if ClaimButtonDay[i].Interactable ~= nil then
			ClaimButtonDay[i].Interactable = false
		end
	end

	for i = 1, 7 do
		ClaimedDays[i].Visible = false
		NotClaimedDays[i].Visible = false
	end

	if status == "claimed_all" then
		for i = 1, 7 do
			ClaimedDays[i].Visible = true
		end
		return
	end

	progress = progress or 0
	for i = 1, math.clamp(progress, 0, 7) do
		ClaimedDays[i].Visible = true
	end

	for i = progress + 1, 7 do
		NotClaimedDays[i].Visible = true
	end

	if allowedDay and allowedDay >= 1 and allowedDay <= 7 then
		ClaimedDays[allowedDay].Visible = false
		NotClaimedDays[allowedDay].Visible = false

		if ClaimButtonDay[allowedDay].Interactable ~= nil then
			ClaimButtonDay[allowedDay].Interactable = true
		end
	end
end



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

-- Start

CheckDay:FireServer()

CheckDay.OnClientEvent:Connect(function(ok, status, allowedDay, progress)
	if not ok and status == "datastore_error" then
		ErrorLabel.Text = tostring(status)
		WarningVisibilityOn()
		task.wait(1.5)
		WarningVisibilityOff()
		return
	end

	if status == "ok" then
		DayVisibility(allowedDay, progress, status)
	elseif status == "claimed_today" then
		DayVisibility(allowedDay, progress, status)
	elseif status == "claimed_all" then
		for i = 1, 7 do
			ClaimedDays[i].Visible = true
			NotClaimedDays[i].Visible = false
		end
	else
		DayVisibility(allowedDay, progress, status)
	end
end)

-- Events

for i = 1, 7 do
	ClaimButtonDay[i].MouseButton1Click:Connect(function()
		ClaimButtonDay[i].Active = false
		if ClaimButtonDay[i].Interactable ~= nil then
			ClaimButtonDay[i].Interactable = false
		end

		CheckDaily:FireServer()
	end)
end

CheckDaily.OnClientEvent:Connect(function(ok, status, dayIndex, reward, claimedAll)
	if not ok then
		ErrorLabel.Text = tostring(status)
		WarningVisibilityOn()
		task.wait(1.5)
		WarningVisibilityOff()

		CheckDay:FireServer()
		return
	end

	CheckDay:FireServer()
end)

task.wait(4)
GameLoaded:FireServer("DailyRewardsTab")