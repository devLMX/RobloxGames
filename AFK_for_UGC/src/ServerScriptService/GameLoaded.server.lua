local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameLoaded = ReplicatedStorage:WaitForChild("GameLoaded")

GameLoaded.OnServerEvent:Connect(function(player, stepId)
	GameLoaded:FireClient(player, stepId)
end)