-- services

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DatastoreService = game:GetService("DataStoreService")
local MessagingService = game:GetService("MessagingService")
local ServerScriptService = game:GetService("ServerScriptService")
local BadgeService = game:GetService("BadgeService")

-- references

local Normal = require(ServerScriptService:WaitForChild("Purchases"))
local Gift = require(ServerScriptService:WaitForChild("GiftScript"))

local StockUGC = DatastoreService:GetDataStore("UGCStock")

local Extra = ReplicatedStorage:WaitForChild("Extra")
local MainPurchases = ReplicatedStorage:WaitForChild("MainPurchases")
local Purchases2 = ReplicatedStorage:WaitForChild("Purchases2")
local Purchases3 = ReplicatedStorage:WaitForChild("Purchases3")
local Purchases4 = ReplicatedStorage:WaitForChild("Purchases4")

local Request = Extra:WaitForChild("RequestStock")

local Sold = Extra:WaitForChild("StockSold")
local Sold2 = Extra:WaitForChild("StockSold2")
local Sold3 = Extra:WaitForChild("StockSold3")
local Sold4 = Extra:WaitForChild("StockSold4")

local UGCStock1 = MainPurchases:WaitForChild("UGCStock")
local UGCStock2 = Purchases2:WaitForChild("UGCStock2")
local UGCStock3 = Purchases3:WaitForChild("UGCStock3")
local UGCStock4 = Purchases4:WaitForChild("UGCStock4")

local function dsGet(key)
	local ok, val = pcall(function()
		return StockUGC:GetAsync(key)
	end)
	if ok then return val or 0 end
	return 0
end

local stock  = dsGet("stock")
local stock2 = dsGet("stock2")
local stock3 = dsGet("stock3")
local stock4 = dsGet("stock4")

local Stock = ReplicatedStorage:WaitForChild("Gift"):WaitForChild("RequestStock")
local Value = ReplicatedStorage:WaitForChild("Gift"):WaitForChild("RequestValue")
local Badge = ReplicatedStorage:WaitForChild("Gift"):WaitForChild("RequestBadge")

local StockValue
local GiftValue
local BadgeValue
local KeyValue

-- functions

game.Players.PlayerAdded:Connect(function(player)
	if stock == 0 then
		Sold:FireClient(player)
	end

	if stock2 == 0 then
		Sold2:FireClient(player)
	end

	if stock3 == 0 then
		Sold3:FireClient(player)
	end

	if stock4 == 0 then
		Sold4:FireClient(player)
	end
	
	UGCStock1:FireClient(player, stock)
	UGCStock2:FireClient(player, stock2)
	UGCStock3:FireClient(player, stock3)
	UGCStock4:FireClient(player, stock4)
end)

Request.OnServerEvent:Connect(function(player)
	UGCStock1:FireClient(player, stock)
	UGCStock2:FireClient(player, stock2)
	UGCStock3:FireClient(player, stock3)
	UGCStock4:FireClient(player, stock4)
end)

Stock.OnServerInvoke = function(player, UGCValue)
    if UGCValue == 90091273181108 then
		StockValue = dsGet("stock")
	elseif UGCValue == 117584543697306 then
		StockValue = dsGet("stock2")
	elseif UGCValue == 140447046551233 then
		StockValue = dsGet("stock3")
	elseif UGCValue == 131417644121042 then
		StockValue = dsGet("stock4")
	end
	return StockValue
end

Value.OnServerInvoke = function(player, UGCValue)
	if UGCValue == 90091273181108 then
		BadgeValue = 3626954700982783
		GiftValue = 3524008417
		KeyValue = "z98xAixZFaVPsXY_"
		StockValue = 1
	elseif UGCValue == 117584543697306 then
		BadgeValue = 2659208154397700
		GiftValue = 3524008735
		KeyValue = "2dWveP_"
		StockValue = 2
	elseif UGCValue == 140447046551233 then
		BadgeValue = 3578501279348639
		GiftValue = 3524008560
		KeyValue = "9ndEmS_"
		StockValue = 3
	elseif UGCValue == 131417644121042 then
		BadgeValue = 3207073313864707
		GiftValue = 3524009018
		KeyValue = "1EvfjC_"
		StockValue = 4
	end
	return BadgeValue, GiftValue, KeyValue, StockValue
end

Badge.OnServerInvoke = function(player, userId: number, badgeId: number)
	local ok, hasOrErr = pcall(function()
		return BadgeService:UserHasBadgeAsync(userId, badgeId)
	end)
	
	if not ok then
		return "ERROR", tostring(hasOrErr)
	end
	
	return hasOrErr and "HAS" or "NO"
end

pcall(function()
    MessagingService:SubscribeAsync("stock", function(message)
        stock = message.Data
        UGCStock1:FireAllClients(stock)
    end)
end)

pcall(function()
    MessagingService:SubscribeAsync("stock2", function(message)
        stock2 = message.Data
        UGCStock2:FireAllClients(stock2)
    end)
end)

pcall(function()
    MessagingService:SubscribeAsync("stock3", function(message)
        stock3 = message.Data
        UGCStock3:FireAllClients(stock3)
    end)
end)

pcall(function()
    MessagingService:SubscribeAsync("stock4", function(message)
        stock4 = message.Data
        UGCStock4:FireAllClients(stock4)
    end)
end)

local function processReceipt(receiptInfo)
	local result = Normal.TryHandle(receiptInfo)
    if result then
        return result
    end

    result = Gift.TryHandle(receiptInfo)
    if result then
        return result
    end

	return Enum.ProductPurchaseDecision.NotProcessedYet
end

MarketplaceService.ProcessReceipt = processReceipt