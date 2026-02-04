local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = game.Players.LocalPlayer

local Purchases = ReplicatedStorage:WaitForChild("MainPurchases")
local Purchases2 = ReplicatedStorage:WaitForChild("Purchases2")
local Purchases3 = ReplicatedStorage:WaitForChild("Purchases3")
local Purchases4 = ReplicatedStorage:WaitForChild("Purchases4")

local CheckPurchases = ReplicatedStorage:WaitForChild("GUI"):WaitForChild("CheckPurchases")
local CheckGifts = ReplicatedStorage:WaitForChild("Gift"):WaitForChild("CheckGifts")

local Bought = Purchases:WaitForChild("Bought")
local Bought2 = Purchases2:WaitForChild("Bought2")
local Bought3 = Purchases3:WaitForChild("Bought3")
local Bought4 = Purchases4:WaitForChild("Bought4")

local BuyUGC = player.PlayerGui:WaitForChild("ugc"):WaitForChild("MainFrame"):WaitForChild("BuyUGC")

local buyUGC1 = BuyUGC:WaitForChild("buy_ugc")
local buyUGC2 = BuyUGC:WaitForChild("buy_ugc2")
local buyUGC3 = BuyUGC:WaitForChild("buy_ugc3")
local buyUGC4 = BuyUGC:WaitForChild("buy_ugc4")


local btn1 = buyUGC1:WaitForChild("main"):WaitForChild("4Frame"):WaitForChild("4BUY UGC")
local btn2 = buyUGC2:WaitForChild("main"):WaitForChild("4Frame"):WaitForChild("4BUY UGC")
local btn3 = buyUGC3:WaitForChild("main"):WaitForChild("4Frame"):WaitForChild("4BUY UGC")
local btn4 = buyUGC4:WaitForChild("main"):WaitForChild("4Frame"):WaitForChild("4BUY UGC")


local btntxt11 = btn1:WaitForChild("buy1")
local btntxt21 = btn2:WaitForChild("buy1")
local btntxt31 = btn3:WaitForChild("buy1")
local btntxt41 = btn4:WaitForChild("buy1")

local btntxt12 = btn1:WaitForChild("buy2")
local btntxt22 = btn2:WaitForChild("buy2")
local btntxt32 = btn3:WaitForChild("buy2")
local btntxt42 = btn4:WaitForChild("buy2")

Bought.OnClientEvent:Connect(function()
	btn1.Interactable = false
	btntxt11.Text = "Bought"
	btntxt12.Text = "Bought"
end)

Bought2.OnClientEvent:Connect(function()
	btn2.Interactable = false
	btntxt21.Text = "Bought"
	btntxt22.Text = "Bought"
end)

Bought3.OnClientEvent:Connect(function()
	btn3.Interactable = false
	btntxt31.Text = "Bought"
	btntxt32.Text = "Bought"
end)

Bought4.OnClientEvent:Connect(function()
	btn4.Interactable = false
	btntxt41.Text = "Bought"
	btntxt42.Text = "Bought"
end)

CheckPurchases:FireServer()
CheckGifts:FireServer()