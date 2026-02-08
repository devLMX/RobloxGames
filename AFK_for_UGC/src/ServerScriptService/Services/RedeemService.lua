-- Services

local DataStoreService = game:GetService("DataStoreService")

-- Variables

local UsesData = DataStoreService:GetDataStore("UsesData")

local RedeemService = {}
RedeemService.__index = RedeemService

RedeemService.Codes = {
	TESTCODE = { reward = 100, expiresat = 0, maxuses = 0 },
}

-- Functions

local function normalize(code: string)
	code = string.gsub(code, "%s+", "")
	return string.upper(code)
end

local function expired(info, now)
	return info.expiresat and info.expiresat > 0 and now >= info.expiresat
end

local function ensureRedeemed(profile)
	profile.RedeemedCodes = profile.RedeemedCodes or {}
	return profile.RedeemedCodes
end

function RedeemService:Redeem(player, profile, rawCode: string)
	if type(rawCode) ~= "string" then
		return false, "invalid_input"
	end

	local code = normalize(rawCode)
	local info = self.Codes[code]
	if not info then
		return false, "code_not_found"
	end

	local now = os.time()
	if expired(info, now) then
		return false, "expired"
	end

	local redeemed = ensureRedeemed(profile)
	if redeemed[code] then
		return false, "already_redeemed"
	end

	local maxuses = info.maxuses or 0
	if maxuses > 0 then
		local globalkey = "CODE_" .. code

		local ok, state = pcall(function()
			return UsesData:UpdateAsync(globalkey, function(old)
				old = old or { count = 0 }
				local count = tonumber(old.count) or 0

				if count >= maxuses then
					return { count = count, granted = false }
				end

				return { count = count + 1, granted = true }
			end)
		end)

		if not ok or type(state) ~= "table" then
			return false, "datastore_error"
		end

		if state.granted == false then
			return false, "limit_uses"
		end
	end

	local reward = info.reward or 0
	profile.Points = (profile.Points or 0) + reward
	redeemed[code] = true

	return true, reward
end

return setmetatable({}, RedeemService)
