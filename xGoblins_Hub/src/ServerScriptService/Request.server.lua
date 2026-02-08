local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DatastoreService = game:GetService("DataStoreService")
local DSPurchases = DatastoreService:GetDataStore("Purchases")

local StockUGC = DatastoreService:GetDataStore("UGCStock")

local CheckPurchases = ReplicatedStorage:WaitForChild("GUI"):WaitForChild("CheckPurchases")
local CheckGifts = ReplicatedStorage:WaitForChild("Gift"):WaitForChild("CheckGifts")

local Purchases = ReplicatedStorage.MainPurchases
local Purchases2 = ReplicatedStorage.Purchases2
local Purchases3 = ReplicatedStorage.Purchases3
local Purchases4 = ReplicatedStorage.Purchases4

local Request1 = Purchases.RequestDev
local Bought1 = Purchases.Bought
local Request2 = Purchases2.RequestDev2
local Bought2 = Purchases2.Bought2
local Request3 = Purchases3.RequestDev3
local Bought3 = Purchases3.Bought3
local Request4 = Purchases4.RequestDev4
local Bought4 = Purchases4.Bought4

local PRODUCT1 = 3477394692
local PRODUCT2 = 3507730709
local PRODUCT3 = 3518194086
local PRODUCT4 = 3518194370

local GIFT1 = 3524008417
local GIFT2 = 3524008735
local GIFT3 = 3524008560
local GIFT4 = 3524009018

local function dsGet(key)
	local ok, val = pcall(function()
		return StockUGC:GetAsync(key)
	end)
	if ok then return val or 0 end
	return 0
end

local KEY1 = ReplicatedStorage:WaitForChild("Keys"):WaitForChild("KEY1").Value
local KEY2 = ReplicatedStorage:WaitForChild("Keys"):WaitForChild("KEY2").Value
local KEY3 = ReplicatedStorage:WaitForChild("Keys"):WaitForChild("KEY3").Value
local KEY4 = ReplicatedStorage:WaitForChild("Keys"):WaitForChild("KEY4").Value

Request1.OnServerEvent:Connect(function(player)
	if dsGet("stock") == 0 then
		return
	end
	MarketplaceService:PromptProductPurchase(player, PRODUCT1)
end)

Request2.OnServerEvent:Connect(function(player)
	if dsGet("stock2") == 0 then
		return
	end
	MarketplaceService:PromptProductPurchase(player, PRODUCT2)
end)

Request3.OnServerEvent:Connect(function(player)
	if dsGet("stock3") == 0 then
		return
	end
	MarketplaceService:PromptProductPurchase(player, PRODUCT3)
end)

Request4.OnServerEvent:Connect(function(player)
	if dsGet("stock4") == 0 then
		return
	end
	MarketplaceService:PromptProductPurchase(player, PRODUCT4)
end)

CheckPurchases.OnServerEvent:Connect(function(player)
	local success, StartBought = pcall(function()
		return DSPurchases:GetAsync(KEY1..player.UserId.."_"..PRODUCT1)
	end)

	if success and StartBought then
		Bought1:FireClient(player)
	end

	local success2, StartBought2 = pcall(function()
		return DSPurchases:GetAsync(KEY2..player.UserId.."_"..PRODUCT2)
	end)

	if success2 and StartBought2 then
		Bought2:FireClient(player)
	end

	local success3, StartBought3 = pcall(function()
		return DSPurchases:GetAsync(KEY3..player.UserId.."_"..PRODUCT3)
	end)

	if success3 and StartBought3 then
		Bought3:FireClient(player)
	end

	local success4, StartBought4 = pcall(function()
		return DSPurchases:GetAsync(KEY4..player.UserId.."_"..PRODUCT4)
	end)

	if success4 and StartBought4 then
		Bought4:FireClient(player)
	end
end)

CheckGifts.OnServerEvent:Connect(function(player)
	local success, StartBought = pcall(function()
		return DSPurchases:GetAsync(KEY1..player.UserId.."_"..GIFT1)
	end)

	if success and StartBought then
		Bought1:FireClient(player)
	end

	local success2, StartBought2 = pcall(function()
		return DSPurchases:GetAsync(KEY2..player.UserId.."_"..GIFT2)
	end)

	if success2 and StartBought2 then
		Bought2:FireClient(player)
	end

	local success3, StartBought3 = pcall(function()
		return DSPurchases:GetAsync(KEY3..player.UserId.."_"..GIFT3)
	end)

	if success3 and StartBought3 then
		Bought3:FireClient(player)
	end

	local success4, StartBought4 = pcall(function()
		return DSPurchases:GetAsync(KEY4..player.UserId.."_"..GIFT4)
	end)

	if success4 and StartBought4 then
		Bought4:FireClient(player)
	end
end)