local Players = game:GetService("Players")
local PointsService = {}

-- Services

local DataService = require(script.Parent:WaitForChild("DataService"))

-- Functions

function PointsService:Add(player, profile, amount)
	profile.Points = (profile.Points or 0) + amount

	local stats = player:FindFirstChild("Stats")
	if not stats then return end

	local points = stats:FindFirstChild("Points")
	if points then
		points.Value = profile.Points
	end

	DataService:Save(player, profile)
	PointsService:Sync(player, profile)
end

function PointsService:Remove(player, profile, amount)
	profile.Points = (profile.Points or 0) - amount

	local stats = player:FindFirstChild("Stats")
	if not stats then return false end

	local points = stats:FindFirstChild("Points")
	if not points then return false end

	if points.Value < amount then
		return false
	end

	points.Value -= amount

	DataService:Save(player, profile)
	PointsService:Sync(player, profile)
	return true
end

function PointsService:Sync(player, profile)
	if not player then return end
	local stats = player:FindFirstChild("Stats")
	if not stats then return end
	local points = stats:FindFirstChild("Points")
	if not points then return end
	points.Value = profile.Points or 0
end


function PointsService:AddByUserId(userid, profile, amount)
	profile.Points = (profile.Points or 0) + amount
	DataService:SaveByUserId(userid, profile)

	local target = Players:GetPlayerByUserId(userid)
	if target then
		PointsService:Sync(target, profile)
	end
end


function PointsService:RemoveByUserId(userid, profile, amount)
	profile.Points = (profile.Points or 0) - amount
	DataService:SaveByUserId(userid, profile)
	PointsService:Sync(Players:GetPlayerByUserId(userid), profile)
end

function PointsService:AddPerSecond(player, profile)
	if not player or not profile then return end
	profile.Points = (profile.Points or 0) + (profile.Rate or 1)
	PointsService:Sync(player, profile)
end


return PointsService