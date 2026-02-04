local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local SoundService = game:GetService("SoundService")

local music = game.ReplicatedStorage:WaitForChild("BackgroundMusic"):Clone()
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

TextChatService.ChatInputBarConfiguration.TargetTextChannel = nil
TextChatService.ChatWindowConfiguration.Enabled = false
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

music.Parent = SoundService
music:Play()

local function disableReset()
	while true do
		local success = pcall(function()
			StarterGui:SetCore("ResetButtonCallback", false)
		end)
		if success then
			break
		end
		task.wait()
	end
end

disableReset()

player.CharacterAdded:Connect(function(character)
	camera.CameraType = Enum.CameraType.Scriptable

	local humanoid = character:WaitForChild("Humanoid")

	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0

	if character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.Anchored = true
	end

	for _, tool in ipairs(player.Backpack:GetChildren()) do
		tool.Enabled = false
	end
end)
