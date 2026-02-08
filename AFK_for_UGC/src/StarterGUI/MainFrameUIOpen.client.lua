-- Services

local SocialService = game:GetService("SocialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Variables

local Player = Players.LocalPlayer
local GameLoaded = ReplicatedStorage:WaitForChild("GameLoaded")

-- MainFrames

local MainFrame = script.Parent.Parent

-- Tabs

local Tabs = MainFrame:WaitForChild("Tabs")

local DailyRewardsTab = Tabs:WaitForChild("DailyRewardsTab")
local RedeemCodesTab = Tabs:WaitForChild("RedeemCodesTab")
local FreePointsTab = Tabs:WaitForChild("FreePointsTab")
local PerksTab = Tabs:WaitForChild("PerksTab")
local CreditsTab = Tabs:WaitForChild("CreditsTab")
local UGCStoreTab = Tabs:WaitForChild("UGCStoreTab")
local GiftTab = Tabs:WaitForChild("GiftTabFindPlayer")

-- Buttons

local Buttons = MainFrame:WaitForChild("Buttons")

local DailyRewardsBtn = Buttons:WaitForChild("DailyRewards")
local RedeemCodesBtn = Buttons:WaitForChild("RedeemCodes")
local CreditsBtn = Buttons:WaitForChild("Credits")
local FreePointsBtn = Buttons:WaitForChild("FreePoints")
local PerksBtn = Buttons:WaitForChild("Perks")
local UGCStoreBtn = Buttons:WaitForChild("UGCStore")
local InviteBtn = Buttons:WaitForChild("Invite")

-- Exit Buttons

local DailyRewardsExitBtn = DailyRewardsTab:WaitForChild("ExitButton")
local RedeemCodesExitBtn = RedeemCodesTab:WaitForChild("ExitButton")
local FreePointsExitBtn = FreePointsTab:WaitForChild("ExitButton")
local PerksExitBtn = PerksTab:WaitForChild("ExitButton")
local CreditsExitBtn = CreditsTab:WaitForChild("ExitButton")
local UGCStoreExitBtn = UGCStoreTab:WaitForChild("ExitButton")
local GiftExitBtn = GiftTab:WaitForChild("ExitButton")

-- Functions

local function OpenTab(Tab)
	DailyRewardsTab.Visible = false
	RedeemCodesTab.Visible = false
	FreePointsTab.Visible = false
	PerksTab.Visible = false
	CreditsTab.Visible = false
	UGCStoreTab.Visible = false
	GiftTab.Visible = false
	Tab.Visible = true
end

local function CloseTab(Tab)
	DailyRewardsTab.Visible = false
	RedeemCodesTab.Visible = false
	FreePointsTab.Visible = false
	PerksTab.Visible = false
	CreditsTab.Visible = false
	UGCStoreTab.Visible = false
	GiftTab.Visible = false
	Tab.Visible = false
end

-- Connections

-- Open Tabs

CreditsBtn.MouseButton1Click:Connect(function()
	if CreditsTab.Visible == false then
		OpenTab(CreditsTab)
	else
		CloseTab(CreditsTab)
	end
end)

DailyRewardsBtn.MouseButton1Click:Connect(function()
	if DailyRewardsTab.Visible == false then
		OpenTab(DailyRewardsTab)
	else
		CloseTab(DailyRewardsTab)
	end
end)

FreePointsBtn.MouseButton1Click:Connect(function()
	if FreePointsTab.Visible == false then
		OpenTab(FreePointsTab)
	else
		CloseTab(FreePointsTab)
	end
end)

PerksBtn.MouseButton1Click:Connect(function()
	if PerksTab.Visible == false then
		OpenTab(PerksTab)
	else
		CloseTab(PerksTab)
	end
end)

RedeemCodesBtn.MouseButton1Click:Connect(function()
	if RedeemCodesTab.Visible == false then
		OpenTab(RedeemCodesTab)
	else
		CloseTab(RedeemCodesTab)
	end
end)

UGCStoreBtn.MouseButton1Click:Connect(function()
	if UGCStoreTab.Visible == false then
		OpenTab(UGCStoreTab)
	else
		CloseTab(UGCStoreTab)
	end
end)

-- Close Tabs

DailyRewardsExitBtn.MouseButton1Click:Connect(function()
	CloseTab(DailyRewardsTab)
end)

RedeemCodesExitBtn.MouseButton1Click:Connect(function()
	CloseTab(RedeemCodesTab)
end)

FreePointsExitBtn.MouseButton1Click:Connect(function()
	CloseTab(FreePointsTab)
end)

PerksExitBtn.MouseButton1Click:Connect(function()
	CloseTab(PerksTab)
end)

CreditsExitBtn.MouseButton1Click:Connect(function()
	CloseTab(CreditsTab)
end)

UGCStoreExitBtn.MouseButton1Click:Connect(function()
	CloseTab(UGCStoreTab)
end)

GiftExitBtn.MouseButton1Click:Connect(function()
	CloseTab(GiftTab)
end)

-- Roblox Buttons

InviteBtn.MouseButton1Click:Connect(function()
	local function canSendGameInvite(sendingPlayer)
		local success, canSend = pcall(function()
			return SocialService:CanSendGameInviteAsync(sendingPlayer)
		end)
		return success and canSend
	end

	local canInvite = canSendGameInvite(Player)
	if canInvite then
		SocialService:PromptGameInvite(Player)
	end
end)

-- UGC Store tab Free/Paid

-- Buttons

local UGCStoreFreeBtn = UGCStoreTab:WaitForChild("FreeUGC")
local UGCStorePaidBtn = UGCStoreTab:WaitForChild("PaidUGC")

-- Scroll Frames

local UGCStoreFreeScroll = UGCStoreTab:WaitForChild("FreeScrollFrame")
local UGCStorePaidScroll = UGCStoreTab:WaitForChild("PaidScrollFrame")

-- Connection

UGCStoreFreeBtn.MouseButton1Click:Connect(function()
	UGCStorePaidScroll.Visible = false
	UGCStoreFreeScroll.Visible = true
end)

UGCStorePaidBtn.MouseButton1Click:Connect(function()
	UGCStoreFreeScroll.Visible = false
	UGCStorePaidScroll.Visible = true
end)

task.wait(3)
GameLoaded:FireServer("MainFrameTab")