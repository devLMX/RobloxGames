local GroupService = {}
GroupService.__index = GroupService

-- Variables

GroupService.GroupId = 35856053
GroupService.Reward = 7000

-- Functions

local function ensureGroup(profile)
	profile.Group = profile.Group or { Claimed = false }
	return profile.Group
end

function GroupService:CanClaim(player, profile)
	local g = ensureGroup(profile)

	if g.Claimed then
		return true, "already_claimed"
	end

	local okIn, inGroup = pcall(function()
		return player:IsInGroup(self.GroupId)
	end)
	if not okIn then
		return false, "group_check_failed"
	end

	if not inGroup then
		return true, "not_in_group"
	end

	return true, "can_claim"
end

function GroupService:Claim(player, profile)
	local ok, status = self:CanClaim(player, profile)
	if not ok then
		return false, status
	end
	if status ~= "can_claim" then
		return true, status, 0
	end

	local g = ensureGroup(profile)
	g.Claimed = true

	return true, "claimed", self.Reward
end

return setmetatable({}, GroupService)
