local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		local hrp = character:FindFirstChild("HumanoidRootPart")

		if hrp then hrp.Anchored = true end

		pcall(function()
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
		end)

		humanoid.MaxHealth = 1e9
		humanoid.Health = humanoid.MaxHealth

		humanoid.HealthChanged:Connect(function(newHealth)
			if newHealth < humanoid.MaxHealth then
				task.defer(function()
					if humanoid and humanoid.Parent then
						humanoid.Health = humanoid.MaxHealth
					end
				end)
			end
		end)
	end)
end)