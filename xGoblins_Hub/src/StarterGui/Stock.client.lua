local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StockRemote = ReplicatedStorage:WaitForChild("MainPurchases"):WaitForChild("UGCStock")
local StockRemote2 = ReplicatedStorage:WaitForChild("Purchases2"):WaitForChild("UGCStock2")
local StockRemote3 = ReplicatedStorage:WaitForChild("Purchases3"):WaitForChild("UGCStock3")
local StockRemote4 = ReplicatedStorage:WaitForChild("Purchases4"):WaitForChild("UGCStock4")

local BuyUGC = script.Parent:WaitForChild("MainFrame"):WaitForChild("BuyUGC")

local label = BuyUGC:WaitForChild("buy_ugc"):WaitForChild("Remaining_Uses")
local label2 = BuyUGC:WaitForChild("buy_ugc2"):WaitForChild("Remaining_Uses")
local label3 = BuyUGC:WaitForChild("buy_ugc3"):WaitForChild("Remaining_Uses")
local label4 = BuyUGC:WaitForChild("buy_ugc4"):WaitForChild("Remaining_Uses")

local maxStock = 10
local maxStock2 = 10
local maxStock3 = 20
local maxStock4 = 20

StockRemote.OnClientEvent:Connect(function(stock)
	label.Text = "REMAINING USES: " .. stock .. " / " .. maxStock
end)

StockRemote2.OnClientEvent:Connect(function(stock2)
	label2.Text = "REMAINING USES: " .. stock2 .. " / " .. maxStock2
end)

StockRemote3.OnClientEvent:Connect(function(stock3)
	label3.Text = "REMAINING USES: " .. stock3 .. " / " .. maxStock3
end)

StockRemote4.OnClientEvent:Connect(function(stock4)
	label4.Text = "REMAINING USES: " .. stock4 .. " / " .. maxStock4
end)

local Request = ReplicatedStorage.Extra.RequestStock

Request:FireServer()