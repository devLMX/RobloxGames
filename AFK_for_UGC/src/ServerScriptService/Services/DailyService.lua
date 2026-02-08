local DailyService = {}
DailyService.__index = DailyService

-- Variables

DailyService.Rewards = {1000,2000,3000,4000,5000,5000,5000}

-- Functions

local function ensureDaily(profile)
	profile.DailySettings = profile.DailySettings or {}
	local d = profile.DailySettings

	if typeof(d.nextClaim) ~= "number" then d.nextClaim = 0 end
	if typeof(d.day) ~= "number" then d.day = 0 end
	if typeof(d.claimed) ~= "boolean" then d.claimed = false end

	return d
end


function DailyService:CanClaim(profile)
	local daily = ensureDaily(profile)
	local now = os.time()

	local progress = daily.day or 0

	if daily.claimed then
		return false, "claimed_all", 0, progress
	end

	local nextAt = daily.nextClaim or 0
	if now < nextAt then
		local remaining = nextAt - now
		local nextDayIndex = math.clamp(progress + 1, 1, #self.Rewards)
		return false, "cooldown", remaining, progress, nextDayIndex
	end

	local nextDayIndex = math.clamp(progress + 1, 1, #self.Rewards)
	return true, "ok", nextDayIndex, progress
end


function DailyService:Claim(profile)
	local daily = ensureDaily(profile)
	local now = os.time()

	if daily.claimed then
		return false, "claimed_all"
	end

	local nextAt = daily.nextClaim or 0
	if now < nextAt then
		return false, "cooldown", (nextAt - now)
	end

	local nextDayIndex = math.clamp((daily.day or 0) + 1, 1, #self.Rewards)
	local reward = self.Rewards[nextDayIndex] or 0

	daily.day += 1
	daily.nextClaim = now + 86400

	if nextDayIndex >= #self.Rewards then
		daily.claimed = true
	end

	return true, "claimed", nextDayIndex, reward, daily.nextClaim
end

return setmetatable({}, DailyService)