-- Services

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables

local Services = script.Parent:WaitForChild("Services")

local DataService = require(Services:WaitForChild("DataService"))
local DailyService = require(Services:WaitForChild("DailyService"))
local PointsService = require(Services:WaitForChild("PointsService"))
local RedeemService = require(Services:WaitForChild("RedeemService"))
local GroupService = require(Services:WaitForChild("GroupService"))
local PassService = require(Services:WaitForChild("PassService"))
local GiftService = require(Services:WaitForChild("GiftService"))
local ReceiptService = require(Services:WaitForChild("ReceiptService"))

local CheckDaily = ReplicatedStorage:WaitForChild("Points"):WaitForChild("CheckDaily")
local CheckDay = ReplicatedStorage:WaitForChild("Points"):WaitForChild("CheckDay")
local CheckGroup = ReplicatedStorage:WaitForChild("Points"):WaitForChild("CheckGroup")
local CheckData = ReplicatedStorage:WaitForChild("Points"):WaitForChild("CheckData")
local RedeemCode = ReplicatedStorage:WaitForChild("RedeemCode")
local SendGift = ReplicatedStorage:WaitForChild("SendGift")

local dailyCooldown = {}

-- Functions

local function setupStats(player, profile)
	local Stats = Instance.new("Folder")
	Stats.Name = "Stats"
	Stats.Parent = player

	local Points = Instance.new("IntValue")
	Points.Name = "Points"
	Points.Value = profile.Points or 0
	Points.Parent = Stats

	local Rate = Instance.new("IntValue")
	Rate.Name = "Rate"
	Rate.Value = profile.Rate or 1
	Rate.Parent = Stats
end

-- Player

Players.PlayerAdded:Connect(function(player)
	local profile = DataService:Load(player)
	setupStats(player, profile)

	PassService:ApplyRate(player, profile)

	local ok, status, allowedDay, progress = DailyService:CanClaim(profile)
	CheckDay:FireClient(player, ok, status, allowedDay, progress)

	local ok2, status2 = GroupService:CanClaim(player, profile)
	CheckGroup:FireClient(player, ok2, status2)

	if PassService:owns(player.UserId, PassService.Gamepasses.X2) then
		CheckData:FireClient(player, "Has_2x")
	end

	if PassService:owns(player.UserId, PassService.Gamepasses.X4) then
		CheckData:FireClient(player, "Has_4x")
	end

end)

Players.PlayerRemoving:Connect(function(player)
	print("Saving data for player " .. player.Name)
	DataService:Save(player, DataService:Load(player))
	print("Data saved for player " .. player.Name)
	DataService:Remove(player)

	dailyCooldown[player.UserId] = nil
end)

-- Events

CheckDay.OnServerEvent:Connect(function(player)
	local profile = DataService:Get(player)
	if not profile then return end

	local ok, status, allowedDay, progress = DailyService:CanClaim(profile)
	CheckDay:FireClient(player, ok, status, allowedDay, progress)
end)

CheckDaily.OnServerEvent:Connect(function(player)
	local userId = player.UserId
	local now = os.clock()
	if dailyCooldown[userId] and (now - dailyCooldown[userId] < 1.0) then
		return
	end
	dailyCooldown[userId] = now

	local profile = DataService:Get(player)
	if not profile then return end

	local ok, status, dayIndex, reward, claimedAll = DailyService:Claim(profile)
	if ok and reward and reward > 0 then
		PointsService:Add(player, profile, reward)
	end

	CheckDaily:FireClient(player, ok, status, dayIndex, reward, claimedAll)
end)

CheckGroup.OnServerEvent:Connect(function(player)
	local profile = DataService:Get(player)
	if not profile then return end

	local ok, status, reward = GroupService:Claim(player, profile)
	if ok and reward and reward > 0 then
		PointsService:Add(player, profile, reward)
	end

	CheckGroup:FireClient(player, ok, status)
end)

RedeemCode.OnServerInvoke = function(player, code)
    local profile = DataService:Get(player)
    if not profile then
        return false, "data_not_ready"
    end

    local ok, res = RedeemService:Redeem(player, profile, code)
    if not ok then
        return false, res
    end

    PointsService:Sync(player, profile)
    DataService:Save(player)

    return true, res
end

SendGift.OnServerEvent:Connect(function(player, targetUserId, perkName)
	if player.UserId == targetUserId then
		SendGift:FireClient(player, "cannot_gift_self")
		return
	end

	local productId = GiftService:GetProductId(perkName)
	if not productId then return end

	local Inventory = DataService:Load(player).Inventory or {}
	local Gifts = GiftService.GiftIds

	for _, item in ipairs(Inventory) do
		if item == productId then
			SendGift:FireClient(player, "already_owned")
			return
		end
	end

	for _, id in ipairs(Gifts) do
		if id == productId then
			if PassService:owns(player.UserId, id) then
				SendGift:FireClient(player, "already_owned")
				return
			end
		end
	end

	GiftService:PendingGiftsAdd(player, targetUserId, perkName, productId, os.clock())

	MarketplaceService:PromptProductPurchase(player, productId)
end)


-- Loop

task.spawn(function()
	while true do
		task.wait(1)
		for _, player in ipairs(Players:GetPlayers()) do
			local profile = DataService:Get(player)
			if profile then
				PointsService:AddPerSecond(player, profile)
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(60)
		for _, player in ipairs(Players:GetPlayers()) do
			DataService:Save(player)
		end
	end
end)


-- Marketplace

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
	if not wasPurchased then return end

	local profile = DataService:Load(player)
	if not profile then return end

	PassService:ApplyRate(player, profile)
	PassService:ApplyInventory(profile, gamePassId)
	DataService:Save(player)
end)

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local profile = DataService:Load(player)
	if not profile then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	return ReceiptService:Process(receiptInfo, player, profile)
end