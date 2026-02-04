-- services

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local BadgeService = game:GetService("BadgeService")

local GiftRequest = ReplicatedStorage:WaitForChild("Gift"):WaitForChild("RequestPurchase")
local BadgeRequest = ReplicatedStorage:WaitForChild("Gift"):WaitForChild("RequestBadge")

local Player = Players.LocalPlayer

-- References

local Gui = Player:WaitForChild("PlayerGui"):WaitForChild("ugc")
local MainFrame = Gui:WaitForChild("MainFrame")
local GiftTab = MainFrame:WaitForChild("GiftTab")

local PlayersTab = GiftTab:WaitForChild("PlayersTab")
local UGCsTab = GiftTab:WaitForChild("UGCsTab")

local ScrollFrame = UGCsTab:WaitForChild("ScrollingFrame")

local Giftbtn = MainFrame:WaitForChild("gift")
local SendGiftbtn = GiftTab:WaitForChild("SendGift")

local WarningGiftTab = MainFrame:WaitForChild("WarningGift")
local WarningStroke = WarningGiftTab:WaitForChild("UIStroke")
local WarningLabel = WarningGiftTab:WaitForChild("TextLabel")

local Stock = ReplicatedStorage:WaitForChild("Gift"):WaitForChild("RequestStock")
local Value = ReplicatedStorage:WaitForChild("Gift"):WaitForChild("RequestValue")
local Request = ReplicatedStorage:WaitForChild("Extra"):WaitForChild("RequestStock")

local UGCValue = ReplicatedStorage:WaitForChild("Values"):WaitForChild("UGCValue")
local PlayerValue = ReplicatedStorage:WaitForChild("Values"):WaitForChild("PlayerValue")
local GiftValue = ReplicatedStorage:WaitForChild("Values"):WaitForChild("GiftValue")
local BadgeValue = ReplicatedStorage:WaitForChild("Values"):WaitForChild("BadgeValue")
local KeyValue = ReplicatedStorage:WaitForChild("Values"):WaitForChild("KeyValue")
local StockValue = ReplicatedStorage:WaitForChild("Values"):WaitForChild("StockValue")

local tweeninfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

-- dictionary

local UGCs = {
	ScrollFrame:WaitForChild("UGC1"),
	ScrollFrame:WaitForChild("UGC2"),
	ScrollFrame:WaitForChild("UGC3"),
	ScrollFrame:WaitForChild("UGC4")
}

local UGCPlayers = {
	PlayersTab:WaitForChild("Player1"),
	PlayersTab:WaitForChild("Player2"),
	PlayersTab:WaitForChild("Player3"),
	PlayersTab:WaitForChild("Player4")
}

-- functions

for _, ugc in ipairs(UGCs) do
	ugc.MouseButton1Click:Connect(function()
		for _, other in ipairs(UGCs) do
			local ColorFrame = other:FindFirstChild("ColorFrame")
			ColorFrame:FindFirstChild("BlueGradient").Enabled = true
			ColorFrame:FindFirstChild("BlueStroke").Enabled = true
			ColorFrame:FindFirstChild("GreenGradient").Enabled = false
			ColorFrame:FindFirstChild("GreenStroke").Enabled = false
		end

		local ColorFrame = ugc:FindFirstChild("ColorFrame")
		ColorFrame:FindFirstChild("GreenGradient").Enabled = true
		ColorFrame:FindFirstChild("GreenStroke").Enabled = true
		ColorFrame:FindFirstChild("BlueGradient").Enabled = false
		ColorFrame:FindFirstChild("BlueStroke").Enabled = false

		UGCValue.Value = ugc:WaitForChild("UGCId").Value

		local badge, gift, key, stock = Value:InvokeServer(UGCValue.Value)
		BadgeValue.Value = badge
		GiftValue.Value = gift
		KeyValue.Value = key
		StockValue.Value = stock
	end)
end

for _, UGCPlayer in ipairs(UGCPlayers) do
	UGCPlayer.MouseButton1Click:Connect(function()
		for _, other in ipairs(UGCPlayers) do
			local ColorFrame = other:FindFirstChild("ColorFrame")
			ColorFrame:FindFirstChild("BlueGradient").Enabled = true
			ColorFrame:FindFirstChild("BlueStroke").Enabled = true
			ColorFrame:FindFirstChild("GreenGradient").Enabled = false
			ColorFrame:FindFirstChild("GreenStroke").Enabled = false
		end

		local ColorFrame = UGCPlayer:FindFirstChild("ColorFrame")
		ColorFrame:FindFirstChild("GreenGradient").Enabled = true
		ColorFrame:FindFirstChild("GreenStroke").Enabled = true
		ColorFrame:FindFirstChild("BlueGradient").Enabled = false
		ColorFrame:FindFirstChild("BlueStroke").Enabled = false

		PlayerValue.Value = UGCPlayer.userID.Value
	end)
end

local function WarningVisibilityOn()
	WarningGiftTab.Visible = true
	local Tween = TweenService:Create(WarningGiftTab, tweeninfo, {BackgroundTransparency = 0})
	local Tween2 = TweenService:Create(WarningStroke, tweeninfo, {Transparency = 0})
	local Tween3 = TweenService:Create(WarningLabel, tweeninfo, {TextTransparency = 0})

	task.spawn(function()
		Tween:Play()
		Tween2:Play()
		Tween3:Play()
	end)
end

local function WarningVisibilityOff()
	local Tween = TweenService:Create(WarningGiftTab, tweeninfo, {BackgroundTransparency = 1})
	local Tween2 = TweenService:Create(WarningStroke, tweeninfo, {Transparency = 1})
	local Tween3 = TweenService:Create(WarningLabel, tweeninfo, {TextTransparency = 1})

	task.spawn(function()
		Tween:Play()
		Tween2:Play()
		Tween3:Play()
	end)
	Tween3.Completed:Connect(function()
		WarningGiftTab.Visible = false
	end)
end

local function SetAvatar(imageLabel: ImageLabel, userId: number)
	for _ = 1, 20 do
		local content, isReady = Players:GetUserThumbnailAsync(
			userId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size180x180
		)

		if isReady and content and content ~= "" then
			imageLabel.Image = content
			return
		end

		task.wait(0.1)
	end
end

local function SetNames(UGCPlayer, player)
	local DisplayName = UGCPlayer:FindFirstChild("Frame"):FindFirstChild("DisplayName")
	local Username = UGCPlayer:FindFirstChild("Frame"):FindFirstChild("UserName")
	local Avatar = UGCPlayer:FindFirstChild("Frame"):FindFirstChild("Frame"):FindFirstChild("ImageLabel")

	local userIDValue = UGCPlayer:FindFirstChild("userID")

	DisplayName.Text = player.DisplayName
	Username.Text = "@" .. player.Name

	userIDValue.Value = player.UserId

	SetAvatar(Avatar, userIDValue.Value)
end

local function RefreshPlayers()
	local others = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= Player then
			table.insert(others, p)
		end
	end

	for i, UGCPlayer in ipairs(UGCPlayers) do
		local player = others[i]
		if player then
			local ColorFrame = UGCPlayer:FindFirstChild("ColorFrame")
			ColorFrame:FindFirstChild("BlueGradient").Enabled = true
			ColorFrame:FindFirstChild("BlueStroke").Enabled = true
			ColorFrame:FindFirstChild("GreenGradient").Enabled = false
			ColorFrame:FindFirstChild("GreenStroke").Enabled = false
			UGCPlayer.Visible = true
			SetNames(UGCPlayer, player)
		else
			UGCPlayer.Visible = false
			local userIDValue = UGCPlayer:FindFirstChild("userID")
			if PlayerValue.Value == userIDValue.Value then
				PlayerValue.Value = 0
				userIDValue.Value = 0
			end
			local ColorFrame = UGCPlayer:FindFirstChild("ColorFrame")
			ColorFrame:FindFirstChild("BlueGradient").Enabled = true
			ColorFrame:FindFirstChild("BlueStroke").Enabled = true
			ColorFrame:FindFirstChild("GreenGradient").Enabled = false
			ColorFrame:FindFirstChild("GreenStroke").Enabled = false
		end
	end
end

-- buttons


Giftbtn.MouseButton1Click:Connect(function()
	for _, ugc in ipairs(UGCs) do
		local ColorFrame = ugc:FindFirstChild("ColorFrame")
		ColorFrame:FindFirstChild("BlueGradient").Enabled = true
		ColorFrame:FindFirstChild("BlueStroke").Enabled = true
		ColorFrame:FindFirstChild("GreenGradient").Enabled = false
		ColorFrame:FindFirstChild("GreenStroke").Enabled = false
	end

	for _, UGCPlayer in ipairs(UGCPlayers) do
		local ColorFrame = UGCPlayer:FindFirstChild("ColorFrame")
		ColorFrame:FindFirstChild("BlueGradient").Enabled = true
		ColorFrame:FindFirstChild("BlueStroke").Enabled = true
		ColorFrame:FindFirstChild("GreenGradient").Enabled = false
		ColorFrame:FindFirstChild("GreenStroke").Enabled = false
	end

	UGCValue.Value = 0
	PlayerValue.Value = 0
	GiftValue.Value = 0
	BadgeValue.Value = 0
	KeyValue.Value = ""
end)

SendGiftbtn.MouseButton1Click:Connect(function()
	if GiftValue.Value == 0 and PlayerValue.Value == 0 then
		WarningLabel.Text = "Select a Player and UGC first"
		WarningVisibilityOn()
		task.wait(1.5)
		WarningVisibilityOff()
		return
	elseif GiftValue.Value == 0 then
		WarningLabel.Text = "Select a UGC first"
		WarningVisibilityOn()
		task.wait(1.5)
		WarningVisibilityOff()
		return
	elseif PlayerValue.Value == 0 then
		WarningLabel.Text = "Select a player first"
		WarningVisibilityOn()
		task.wait(1.5)
		WarningVisibilityOff()
		return
	end
	
	local status, errMsg = BadgeRequest:InvokeServer(PlayerValue.Value, BadgeValue.Value)

	if status == "HAS" then
		WarningLabel.Text = "Player already has this UGC"
		WarningVisibilityOn()
		task.wait(1.5)
		WarningVisibilityOff()
		return
	elseif status == "ERROR" then
		WarningLabel.Text = "Error checking Player"
		WarningVisibilityOn()
		task.wait(1.5)
		WarningVisibilityOff()
		warn(errMsg)
		return
	end

	local stock = Stock:InvokeServer(UGCValue.Value)
	
	StockValue.Value = stock
		
	if StockValue.Value == 0 then
		WarningLabel.Text = "UGC is out of stock"
		WarningVisibilityOn()
		task.wait(1.5)
		WarningVisibilityOff()
		return
	elseif StockValue.Value > 0 then
		GiftRequest:FireServer(GiftValue.Value, PlayerValue.Value, UGCValue.Value, BadgeValue.Value, StockValue.Value, KeyValue.Value)
	end
end)

-- start

RefreshPlayers()

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)