local InitService = {}
InitService.__index = InitService

-- Services

local Services = game:GetService("ServerScriptService"):WaitForChild("Services")

-- Functions

function InitService:Init()
	local DataService = require(Services:WaitForChild("DataService"))
	local PassService = require(Services:WaitForChild("PassService"))
    local PointsService = require(Services:WaitForChild("PointsService"))
	local GiftService = require(Services:WaitForChild("GiftService"))

	GiftService.pending = {}
    return DataService, PassService, PointsService, GiftService
end

return setmetatable({}, InitService)
