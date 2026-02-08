local DataService = {}
DataService.__index = DataService

-- Services

local DataStoreService = game:GetService("DataStoreService")

-- Variables

local ProfileStore = DataStoreService:GetDataStore("PlayerProfile")

local TEMPLATE = {
	Points = 0,
	Rate = 1,
	GroupClaimed = false,
	DailySettings = {
		nextClaim = 0,
		claimed = false,
		day = 0
	},
	Inventory = {},
    RedeemedCodes = {},
    ReceiptIds = {}
}

local cache = {}

-- Functions

local function deepCopy(v)
	if typeof(v) ~= "table" then
		return v
	end
	local copy = {}
	for k, val in pairs(v) do
		copy[k] = deepCopy(val)
	end
	return copy
end


local function reconcile(data, template)
	if typeof(data) ~= "table" then
		data = {}
	end

	for key, value in pairs(template) do
		if data[key] == nil then
			data[key] = deepCopy(value)

		elseif typeof(value) == "table" then
			if typeof(data[key]) ~= "table" then
				data[key] = deepCopy(value)
			else
				reconcile(data[key], value)
			end

		else
			if typeof(data[key]) == "table" then
				data[key] = value
			end
		end
	end
end


function DataService:Load(player)
	print("Loading data for player " .. player.Name)
	local userId = player.UserId

	local data

	local success, result = pcall(function()
		return ProfileStore:GetAsync(userId)
	end)

	if success and typeof(result) == "table" then
		data = result
		reconcile(data, TEMPLATE)
	else
		data = deepCopy(TEMPLATE)
	end

	cache[userId] = data
	print(data)
	return data
end

function DataService:Get(player)
	return cache[player.UserId]
end

function DataService:Save(player, data)
	local userId = player.UserId
	data = data or cache[userId]
	if not data then
		return
	end

	pcall(function()
		ProfileStore:SetAsync(userId, data)
	end)
end


function DataService:Remove(player)
	cache[player.UserId] = nil
end

function DataService:LoadByUserId(userId: number)
	local success, result = pcall(function()
		return ProfileStore:GetAsync(userId)
	end)

	local data
	if success and typeof(result) == "table" then
		data = result
		reconcile(data, TEMPLATE)
	else
		data = deepCopy(TEMPLATE)
	end

	return data
end

function DataService:SaveByUserId(userId: number, data: table)
	if not data then return end
	pcall(function()
		print("Saving profile for user ID " .. userId)
		print(data.Points)
		ProfileStore:SetAsync(userId, data)
		print(data.Points)
	end)
end

return DataService