local M = {}

-- services

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local BadgeService = game:GetService("BadgeService")
local HttpService = game:GetService("HttpService")
local DatastoreService = game:GetService("DataStoreService")
local MessagingService = game:GetService("MessagingService")

-- References

local DSPurchases = DatastoreService:GetDataStore("Purchases")
local StockUGC = DatastoreService:GetDataStore("UGCStock")
local PendingStore = DatastoreService:GetDataStore("PendingGifts")

local WEBHOOK1 = "webhook"
local WEBHOOK2 = "webhook"

local Bought
local UGCStock
local Sold

local GiftRequest = ReplicatedStorage:WaitForChild("Gift"):WaitForChild("RequestPurchase")

local PendingGifts = {}
local SentWebhooks = {}

-- functions

-- GiftValue = productId
-- BadgeValue = BadgeId
-- UGCValue = ugcId
-- KeyValue = KeyId
-- StockValue = current stock
-- PlayerValue = PlayerId

GiftRequest.OnServerEvent:Connect(function(player, giftId, playerId, ugcId, badgeId, stockId, keyId)
	if not giftId or not playerId or not ugcId or not badgeId or not stockId or not keyId then
		print("Invalid GIFT or PlayerValue or UGCValue or Badgevalue")
		return
	end

	local giftData = {
		giftId = giftId,
		playerId = playerId,
		ugcId = ugcId,
		badgeId = badgeId,
		stockId = stockId,
		keyId = keyId
	}

	PendingGifts[player.UserId] = giftData

	PendingStore:SetAsync("gift_"..player.UserId.."_"..playerId, giftData)

	MarketplaceService:PromptProductPurchase(player, giftId)
end)

local function grantBadge(player, badge)
	local GiftedUser = Players:GetPlayerByUserId(player)
	if not GiftedUser then
		return
	end
	print("Awarding badge to player:"..GiftedUser.Name)
	BadgeService:AwardBadge(player, badge)
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


-- module function

function M.TryHandle(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

	local buyerId = receiptInfo.PlayerId

	local pending = PendingGifts[buyerId]

	if not pending then
		local ok, data = pcall(function()
			return PendingStore:GetAsync("gift_"..buyerId.."_"..pending.playerId)
		end)
		if ok and data then
			pending = data
			PendingGifts[buyerId] = data
		end
	end

	if not pending then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	if pending.giftId ~= receiptInfo.ProductId then return nil end

	local ok, giftedName = pcall(function()
		return Players:GetNameFromUserIdAsync(pending.playerId)
	end)
	if not ok then giftedName = "Unknown" end

	local giftedPlayer = Players:GetPlayerByUserId(pending.playerId)

    local msg1 = {
		["content"] = "<@607307380954234910>",
		["embeds"] = {{
			["title"] = "GIFT DEV PRODUCT BOUGHT",
			["color"] = 0x00ff9d,
			["fields"] = {
				{["name"] = "User", ["value"] = player.Name, ["inline"] = true},
				{["name"] = "Gifted User", ["value"] = giftedName, ["inline"] = true},
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
			["title"] = "SOMEONE JUST BOUGHT A GIFT!!!",
			["description"] = "Thanks for buying a gift!!",
			["color"] = 0xffffff,
			["image"] = {
				["url"] = imageurl
			},
			["thumbnail"] = {
				["url"] = thumbnailUrl
			},
			["fields"] = {
				{["name"] = "User", ["value"] = player.Name, ["inline"] = true},
				{["name"] = "Gifted User", ["value"] = giftedName, ["inline"] = true},
				{["name"] = "UGC", ["value"] = productName, ["inline"] = true},
				{["name"] = "Time", ["value"] = os.date("%m/%d/%Y %H:%M:%S"), ["inline"] = false},
			}
		}}
	}

	if pending.giftId == receiptInfo.ProductId then
		if pending.keyId == "z98xAixZFaVPsXY_" then
			Bought = ReplicatedStorage:WaitForChild("MainPurchases"):WaitForChild("Bought")
			UGCStock = ReplicatedStorage:WaitForChild("MainPurchases"):WaitForChild("UGCStock")
			Sold = ReplicatedStorage:WaitForChild("Extra"):WaitForChild("StockSold")
		elseif pending.keyId == "2dWveP_" then
			Bought = ReplicatedStorage:WaitForChild("Purchases2"):WaitForChild("Bought2")
			UGCStock = ReplicatedStorage:WaitForChild("Purchases2"):WaitForChild("UGCStock2")
			Sold = ReplicatedStorage:WaitForChild("Extra"):WaitForChild("StockSold2")
		elseif pending.keyId == "9ndEmS_" then
			Bought = ReplicatedStorage:WaitForChild("Purchases3"):WaitForChild("Bought3")
			UGCStock = ReplicatedStorage:WaitForChild("Purchases3"):WaitForChild("UGCStock3")
			Sold = ReplicatedStorage:WaitForChild("Extra"):WaitForChild("StockSold3")
		elseif pending.keyId == "1EvfjC_" then
			Bought = ReplicatedStorage:WaitForChild("Purchases4"):WaitForChild("Bought4")
			UGCStock = ReplicatedStorage:WaitForChild("Purchases4"):WaitForChild("UGCStock4")
			Sold = ReplicatedStorage:WaitForChild("Extra"):WaitForChild("StockSold4")
		end

		Bought:FireClient(giftedPlayer)
		DSPurchases:SetAsync(pending.keyId..pending.playerId.."_"..pending.giftId, true)
		pending.stockId = pending.stockId - 1
		UGCStock:FireClient(giftedPlayer, pending.stockId)
		StockUGC:SetAsync("stock", pending.stockId)
		MessagingService:PublishAsync("stock", pending.stockId)
		grantBadge(pending.playerId, pending.badgeId)
		if pending.stockId <= 0 then
			pending.StockId = 0
			Sold:FireAllClients()
		end
	end
	pcall(function()
		PendingStore:RemoveAsync("gift_" .. buyerId.."_"..pending.playerId)
	end)
	PendingGifts[buyerId] = nil

	local eventId = "gift_" .. player.UserId .. "_" .. os.time()

	SafePostWebhook(WEBHOOK1, msg1, eventId)
	SafePostWebhook(WEBHOOK2, msg2, eventId)
    return Enum.ProductPurchaseDecision.PurchaseGranted
end

return M