-- Services

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

-- Variables

local player = Players.LocalPlayer

local MainFrame = script.Parent.Parent
local PerksTab = MainFrame:WaitForChild("Tabs"):WaitForChild("PerksTab")
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

-- TextLabels

local Points2xText = Points2xBuy:WaitForChild("TextLabel")
local Points4xText = Points4xBuy:WaitForChild("TextLabel")

local Points10kText = Points10kBuy:WaitForChild("TextLabel")
local Points50kText = Points50kBuy:WaitForChild("TextLabel")

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

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p, gamePassId, wasPurchased)
	if p ~= player then return end
	if not wasPurchased then return end

	if gamePassId == 1700418953 then
		Points2xText.Text = "Bought"
	elseif gamePassId == 1700928825 then
		Points4xText.Text = "Bought"
	end
end)
