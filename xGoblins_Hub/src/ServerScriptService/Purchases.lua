local M = {}

-- services

local MarketplaceService = game:GetService("MarketplaceService")
local BadgeService = game:GetService("BadgeService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DatastoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")

-- references

local DSPurchases = DatastoreService:GetDataStore("Purchases")
local StockUGC = DatastoreService:GetDataStore("UGCStock")

local Extra = ReplicatedStorage:WaitForChild("Extra")
local MainPurchases = ReplicatedStorage:WaitForChild("MainPurchases")
local Purchases2 = ReplicatedStorage:WaitForChild("Purchases2")
local Purchases3 = ReplicatedStorage:WaitForChild("Purchases3")
local Purchases4 = ReplicatedStorage:WaitForChild("Purchases4")

local Bought = MainPurchases:WaitForChild("Bought")
local Bought2 = Purchases2:WaitForChild("Bought2")
local Bought3 = Purchases3:WaitForChild("Bought3")
local Bought4 = Purchases4:WaitForChild("Bought4")

local Sold = Extra:WaitForChild("StockSold")
local Sold2 = Extra:WaitForChild("StockSold2")
local Sold3 = Extra:WaitForChild("StockSold3")
local Sold4 = Extra:WaitForChild("StockSold4")

local UGCStock1 = MainPurchases:WaitForChild("UGCStock")
local UGCStock2 = Purchases2:WaitForChild("UGCStock2")
local UGCStock3 = Purchases3:WaitForChild("UGCStock3")
local UGCStock4 = Purchases4:WaitForChild("UGCStock4")

local PRODUCT = 3477394692
local PRODUCT2 = 3507730709
local PRODUCT3 = 3518194086
local PRODUCT4 = 3518194370

local BADGE = 3626954700982783
local BADGE2 = 2659208154397700
local BADGE3 = 3578501279348639
local BADGE4 = 3207073313864707

local KEY1 = ReplicatedStorage:WaitForChild("Keys"):WaitForChild("KEY1").Value
local KEY2 = ReplicatedStorage:WaitForChild("Keys"):WaitForChild("KEY2").Value
local KEY3 = ReplicatedStorage:WaitForChild("Keys"):WaitForChild("KEY3").Value
local KEY4 = ReplicatedStorage:WaitForChild("Keys"):WaitForChild("KEY4").Value

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

local SentWebhooks = {}

local WEBHOOK1 = "webhook"
local WEBHOOK2 = "webhook"

-- functions

local function grantBadge(player)
	local has = false
	pcall(function()
		has = BadgeService:UserHasBadgeAsync(player.UserId, BADGE)
	end)
	if not has then
		pcall(function()
			BadgeService:AwardBadge(player.UserId, BADGE)
		end)
	end
end

local function grantBadge2(player)
	local has = false
	pcall(function()
		has = BadgeService:UserHasBadgeAsync(player.UserId, BADGE2)
	end)
	if not has then
		pcall(function()
			BadgeService:AwardBadge(player.UserId, BADGE2)
		end)
	end
end

local function grantBadge3(player)
	local has = false
	pcall(function()
		has = BadgeService:UserHasBadgeAsync(player.UserId, BADGE3)
	end)
	if not has then
		pcall(function()
			BadgeService:AwardBadge(player.UserId, BADGE3)
		end)
	end
end

local function grantBadge4(player)
	local has = false
	pcall(function()
		has = BadgeService:UserHasBadgeAsync(player.UserId, BADGE4)
	end)
	if not has then
		pcall(function()
			BadgeService:AwardBadge(player.UserId, BADGE4)
		end)
	end
end

local function SafePostWebhook(url, payload, eventId)
	if SentWebhooks[eventId] then
		warn("Webhook already sent:", eventId)
		return false
	end

	SentWebhooks[eventId] = true

	local encoded = HttpService:JSONEncode(payload)

	local ok, res = pcall(function()
		return HttpService:PostAsync(
			url,
			encoded,
			Enum.HttpContentType.ApplicationJson,
			false
		)
	end)

	if not ok then
		warn("Webhook failed:", res)
		SentWebhooks[eventId] = nil
		return false
	end

	print("Webhook sent:", eventId)
	return true
end


function M.TryHandle(receiptInfo)
	print("Processing normal receipt...")
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local id = receiptInfo.ProductId
	if id ~= PRODUCT and id ~= PRODUCT2 and id ~= PRODUCT3 and id ~= PRODUCT4 then
		return nil
	end

	local msg1 = {
		["content"] = "<@607307380954234910>",
		["embeds"] = {{
			["title"] = "DEV PRODUCT BOUGHT",
			["color"] = 0x00ff9d,
			["fields"] = {
				{["name"] = "User", ["value"] = player.Name, ["inline"] = true},
				{["name"] = "UserId", ["value"] = tostring(player.UserId), ["inline"] = true},
				{["name"] = "Product", ["value"] = tostring(receiptInfo.ProductId), ["inline"] = true},
				{["name"] = "TransactionId", ["value"] = receiptInfo.PurchaseId, ["inline"] = false},
				{["name"] = "Time", ["value"] = os.date("%m/%d/%Y %H:%M:%S"), ["inline"] = false},
			}
		}}
	}

	local productInfo
	pcall(function()
		productInfo = MarketplaceService:GetProductInfo(receiptInfo.ProductId, Enum.InfoType.Product)
	end)

	local productName = productInfo and productInfo.Name or "Unknown Product"


	local thumbnailUrl = "https://tr.rbxcdn.com/180DAY-bb82ef27524369ca152774db00e68da4/150/150/Image/Png/noFilter"
	local imageurl = "https://cdn.discordapp.com/attachments/1423739025361080427/1457216126403612889/tree_git_crop.gif?ex=695b31c6&is=6959e046&hm=76e43f3de7b51b54feb9761be61440075783c7bb2f73e5926c2c6ad515b5d059&"

	local msg2 = {
		["embeds"] = {{
			["title"] = "SOMEONE JUST BOUGHT AN UGC!!!",
			["description"] = "Thanks for buying my UGC!!",
			["color"] = 0xffffff,
			["image"] = {
				["url"] = imageurl
			},
			["thumbnail"] = {
				["url"] = thumbnailUrl
			},
			["fields"] = {
				{["name"] = "User", ["value"] = player.Name, ["inline"] = true},
				{["name"] = "UGC", ["value"] = productName, ["inline"] = true},
				{["name"] = "Time", ["value"] = os.date("%m/%d/%Y %H:%M:%S"), ["inline"] = false},
			}
		}}
	}

	if PRODUCT == receiptInfo.ProductId then

		if stock == 0 then return Enum.ProductPurchaseDecision.PurchaseGranted end

		grantBadge(player)
		Bought:FireClient(player)
		DSPurchases:SetAsync(KEY1..player.UserId.."_"..PRODUCT, true)
		stock = stock - 1
		UGCStock1:FireClient(player, stock)
		StockUGC:SetAsync("stock", stock)
		MessagingService:PublishAsync("stock", stock)
		
		if stock <= 0 then
			stock = 0
			Sold:FireAllClients()
		end

	elseif PRODUCT2 == receiptInfo.ProductId then

		if stock2 == 0 then return Enum.ProductPurchaseDecision.PurchaseGranted end

		grantBadge2(player)
		Bought2:FireClient(player)
		DSPurchases:SetAsync(KEY2..player.UserId.."_"..PRODUCT2, true)
		stock2 = stock2 - 1
		UGCStock2:FireClient(player, stock2)
		StockUGC:SetAsync("stock2", stock2)
		MessagingService:PublishAsync("stock2", stock2)

		if stock2 <= 0 then
			stock2 = 0
			Sold2:FireAllClients()
		end

	elseif PRODUCT3 == receiptInfo.ProductId then

		if stock3 == 0 then return Enum.ProductPurchaseDecision.PurchaseGranted end

		grantBadge3(player)
		Bought3:FireClient(player)
		DSPurchases:SetAsync(KEY3..player.UserId.."_"..PRODUCT3, true)
		stock3 = stock3 - 1
		UGCStock3:FireClient(player, stock3)
		StockUGC:SetAsync("stock3", stock3)
		MessagingService:PublishAsync("stock3", stock3)

		if stock3 <= 0 then
			stock3 = 0
			Sold3:FireAllClients()
		end

	elseif PRODUCT4 == receiptInfo.ProductId then

		if stock4 == 0 then return Enum.ProductPurchaseDecision.PurchaseGranted end

		grantBadge4(player)
		Bought4:FireClient(player)
		DSPurchases:SetAsync(KEY4..player.UserId.."_"..PRODUCT4, true)
		stock4 = stock4 - 1
		UGCStock4:FireClient(player, stock4)
		StockUGC:SetAsync("stock4", stock4)
		MessagingService:PublishAsync("stock4", stock4)

		if stock4 <= 0 then
			stock4 = 0
			Sold4:FireAllClients()
		end

	end

	local eventId = "gift_" .. player.UserId .. "_" .. os.time()

	SafePostWebhook(WEBHOOK1, msg1, eventId)
	SafePostWebhook(WEBHOOK2, msg2, eventId)
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

return M