-- Services

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Variables

local player = Players.LocalPlayer

local CheckData = ReplicatedStorage:WaitForChild("Points"):WaitForChild("CheckData")
local GameLoaded = game:GetService("ReplicatedStorage"):WaitForChild("GameLoaded")

local MainFrame = script.Parent.Parent

local PerksTab = MainFrame:WaitForChild("Tabs"):WaitForChild("PerksTab")
local GiftTab = MainFrame:WaitForChild("Tabs"):WaitForChild("GiftTabFindPlayer")

local PerksScroll = PerksTab:WaitForChild("MainScroll")

local Points10k = PerksScroll:WaitForChild("10kPoints")
local Points50k = PerksScroll:WaitForChild("50kPoints")

local Points2x = PerksScroll:WaitForChild("2xPoints")
local Points4x = PerksScroll:WaitForChild("4xPoints")

-- Dev Product

local Points10kBuy = Points10k:WaitForChild("BuyButton")
local Points50kBuy = Points50k:WaitForChild("BuyButton")

-- Gamepasses

local Points2xBuy = Points2x:WaitForChild("BuyButton")
local Points4xBuy = Points4x:WaitForChild("BuyButton")

-- Gift

local Points2xGift = Points2x:WaitForChild("GiftButton")
local Points4xGift = Points4x:WaitForChild("GiftButton")

local Points10kGift = Points10k:WaitForChild("GiftButton")
local Points50kGift = Points50k:WaitForChild("GiftButton")

-- TextLabels

local Points2xText = Points2xBuy:WaitForChild("TextLabel")
local Points4xText = Points4xBuy:WaitForChild("TextLabel")

local Points10kText = Points10kBuy:WaitForChild("TextLabel")
local Points50kText = Points50kBuy:WaitForChild("TextLabel")

local GiftTabText = GiftTab:WaitForChild("giftname")

-- Events

Points2xBuy.MouseButton1Click:Connect(function()
	MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, 1700418953)
end)

Points4xBuy.MouseButton1Click:Connect(function()
	MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, 1700928825)
end)

Points10kBuy.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(Players.LocalPlayer, 3530681192)
end)

Points50kBuy.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(Players.LocalPlayer, 3530681330)
end)

Points2xGift.MouseButton1Click:Connect(function()
	GiftTabText.Text = "2x Points"
	GiftTab.Visible = true
end)

Points4xGift.MouseButton1Click:Connect(function()
	GiftTabText.Text = "4x Points"
	GiftTab.Visible = true
end)

Points10kGift.MouseButton1Click:Connect(function()
	GiftTabText.Text = "10k Points"
	GiftTab.Visible = true
end)

Points50kGift.MouseButton1Click:Connect(function()
	GiftTabText.Text = "50k Points"
	GiftTab.Visible = true
end)

-- Marketplace

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p, gamePassId, wasPurchased)
	if p ~= player then return end
	if not wasPurchased then return end

	if gamePassId == 1700418953 then
		Points2xText.Text = "Bought"
		Points2xBuy.Interactable = false
	elseif gamePassId == 1700928825 then
		Points4xText.Text = "Bought"
		Points4xBuy.Interactable = false
	end
end)

-- Start

CheckData.OnClientEvent:Connect(function(pass)
	if pass == "Has_2x" then
		Points2xText.Text = "Bought"
		Points2xBuy.Interactable = false
	elseif pass == "Has_4x" then
		Points4xText.Text = "Bought"
		Points4xBuy.Interactable = false
	end
end)

task.wait(2.1)
GameLoaded:FireServer("PerksStoreTab")