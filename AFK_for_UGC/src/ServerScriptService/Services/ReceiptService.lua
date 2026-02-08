local ReceiptService = {}
ReceiptService.__index = ReceiptService

-- Variables

local InitService = require(script.Parent:WaitForChild("InitService"))

local DataService, PassService, PointsService, GiftService = InitService:Init()

-- Functions

function ReceiptService:Process(receiptInfo, player, profile)
	local purchaseId = receiptInfo.PurchaseId
	profile.ReceiptIds = profile.ReceiptIds or {}

	if profile.ReceiptIds[purchaseId] then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	local productId = receiptInfo.ProductId
	local pending = GiftService:GetPeding(player)

	local okGift = false
	local buyerprofile = DataService:LoadByUserId(pending.targetUserId)

	if pending and buyerprofile then
		okGift = GiftService:HandleReceipt(productId, player, buyerprofile, pending)
	end

	local okPoints = false
	if not okGift and buyerprofile then
		okPoints = PassService:HandleDevProduct(productId, buyerprofile)
	end

	if not okGift and not okPoints then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	profile.ReceiptIds[purchaseId] = true
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

return setmetatable({}, ReceiptService)
