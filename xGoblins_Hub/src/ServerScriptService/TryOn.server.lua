local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TryOn = ReplicatedStorage:WaitForChild("Extra"):WaitForChild("TryOn")

TryOn.OnServerEvent:Connect(function(player, assetId)
	assetId = tonumber(assetId)
	if not assetId then return end
	TryOn:FireClient(player, assetId)
end)
