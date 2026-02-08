local GiftService = {}
GiftService.__index = GiftService

-- Services

local DataService = require(script.Parent:WaitForChild("DataService"))
local PointsService = require(script.Parent:WaitForChild("PointsService"))

-- Variables

GiftService.GiftProducts = {
	["2x Points"] = 3532129030,
	["4x Points"] = 3532129204,
	["10k Points"] = 3532129374,
	["50k Points"] = 3532129896
}

GiftService.GiftIds = {
	[1700418953] = 3532129030,
	[1700928825] = 3532129204
}

function GiftService:PendingGiftsAdd(player, targetUserId, perkName, productId, createdAt)
	self.pending[player.UserId] = {
		targetUserId = targetUserId,
		perkName = perkName,
		productId = productId,
		createdAt = createdAt
	}
	return
end

function GiftService:PendingGiftsRemove(player)
	self.pending[player.UserId] = nil
	return
end

function GiftService:GetPeding(player)
	return self.pending[player.UserId]
end

function GiftService:GetProductId(perkName: string)
	return self.GiftProducts[perkName]
end

local function applyGift(perkName, targetProfile, targetUserId)
	local targetPlayer = game.Players:GetPlayerByUserId(targetUserId)
	if perkName == "2x Points" then
		table.insert(targetProfile.Inventory, "2x Points")
		local r = targetProfile.Rate or 1
		if r == 1 then targetProfile.Rate = 2
		elseif r == 4 then targetProfile.Rate = 6
		elseif r == 2 then targetProfile.Rate = 2
		elseif r == 6 then targetProfile.Rate = 6
		end
		return true

	elseif perkName == "4x Points" then
		local r = targetProfile.Rate or 1
		table.insert(targetProfile.Inventory, "4x Points")
		if r == 1 then targetProfile.Rate = 4
		elseif r == 2 then targetProfile.Rate = 6
		elseif r == 4 then targetProfile.Rate = 4
		elseif r == 6 then targetProfile.Rate = 6
		end
		return true

	elseif perkName == "10k Points" then
		if targetPlayer then
			local targetProfile = DataService:Load(targetPlayer)
			if not targetProfile then return false end

			targetProfile.Points = (targetProfile.Points or 0) + 10000
			PointsService:Sync(targetPlayer, targetProfile)
			DataService:Save(targetPlayer, targetProfile)

		else
			local targetProfile = DataService:LoadByUserId(targetUserId)
			if not targetProfile then return false end

			targetProfile.Points = (targetProfile.Points or 0) + 10000
			DataService:SaveByUserId(targetUserId, targetProfile)
		end
		return true

	elseif perkName == "50k Points" then
		if targetPlayer then
			local targetProfile = DataService:Load(targetPlayer)
			if not targetProfile then return false end

			targetProfile.Points = (targetProfile.Points or 0) + 50000
			PointsService:Sync(targetPlayer, targetProfile)
			DataService:Save(targetPlayer, targetProfile)

		else
			local targetProfile = DataService:LoadByUserId(targetUserId)
			if not targetProfile then return false end

			targetProfile.Points = (targetProfile.Points or 0) + 50000
			DataService:SaveByUserId(targetUserId, targetProfile)
		end
		return true
	end

	return false
end

function GiftService:HandleReceipt(productId, player, buyerProfile, pending)
	if not pending then return false end
	if productId ~= pending.productId then return false end
	if not buyerProfile then return false end

	local ok = applyGift(pending.perkName, buyerProfile, pending.targetUserId)
	if not ok then return false end

	local targetPlayer = game.Players:GetPlayerByUserId(pending.targetUserId)
	if targetPlayer then
		DataService:Save(targetPlayer)
	else
		DataService:SaveByUserId(pending.targetUserId)
	end

	self.pending[player.UserId] = nil
	return true
end

return setmetatable({}, GiftService)
