local PassService = {}
PassService.__index = PassService

-- Services

local MarketplaceService = game:GetService("MarketplaceService")
local DataService = require(script.Parent:WaitForChild("DataService"))

-- Variables

PassService.Gamepasses = {
	X2 = 1700418953,
	X4 = 1700928825,
}

PassService.Products = {
	[3530681192] = { points = 10000 },
	[3530681330] = { points = 50000 },
}

-- Functions

function PassService:owns(userId: number, passId: number): boolean
	local ok, res = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(userId, passId)
	end)
	return ok and res == true
end

function PassService:ownsGift(userId: number): boolean
	local data = DataService:Load(game:GetService("Players"):GetPlayerByUserId(userId))
	local inventory = data.Inventory or {}
	if table.find(inventory, "2x Points") then
		return true, "2x Points"
	elseif table.find(inventory, "4x Points") then
		return true, "4x Points"
	end
end


function PassService:ComputeMultiplier(player: Player): number
	local userId = player.UserId
	local mult = 0

	local hasGift, giftName = self:ownsGift(userId)
	if hasGift then
		if giftName == "2x Points" then
			mult += 2
		elseif giftName == "4x Points" then
			mult += 4
		end
	else
		if self:owns(userId, self.Gamepasses.X2) then
			mult += 2
		end

		if self:owns(userId, self.Gamepasses.X4) then
			mult += 4
		end
	end


	if mult == 0 then mult = 1 end
	return mult
end

function PassService:ApplyRate(player: Player, profile)
	local mult = self:ComputeMultiplier(player)

	profile.Rate = mult

	local stats = player:FindFirstChild("Stats")
	local rate = stats and stats:FindFirstChild("Rate")
	if rate then
		rate.Value = mult
	end

	return mult
end

function PassService:ApplyInventory(profile, item)
	local Inventory = profile.Inventory or {}
	table.insert(Inventory, item)
end

function PassService:HandleDevProduct(productId: number, profile)
	local cfg = self.Products[productId]
	if not cfg then
		return false
	end

	profile.Points = (profile.Points or 0) + cfg.points
	return true, cfg.points
end

return setmetatable({}, PassService)
