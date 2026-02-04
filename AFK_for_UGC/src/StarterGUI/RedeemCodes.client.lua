-- Services

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables

local MainFrame = script.Parent.Parent
local RedeemCodesTab = MainFrame:WaitForChild("Tabs"):WaitForChild("RedeemCodesTab")

local RedeemTextBox = RedeemCodesTab:WaitForChild("TextBox")
local RedeemButton = RedeemCodesTab:WaitForChild("TextButton")

local RedeemCode = ReplicatedStorage:WaitForChild("RedeemCode")
local GameLoaded = ReplicatedStorage:WaitForChild("GameLoaded")

local busy = false

-- Functions

local function showMessage(message)
	RedeemTextBox.Text = message
	task.wait(1)
	RedeemTextBox.Text = ""
end

local function RedeemCodeFunction()
	if busy then return end
	busy = true

	local code = RedeemTextBox.Text
	if typeof(code) ~= "string" or code == "" then
		showMessage("Invalid code")
		busy = false
		return
	end

	RedeemTextBox.Text = ""

	local success, ok, result = pcall(function()
		return RedeemCode:InvokeServer(code)
	end)

	if not success then
		showMessage("Error")
		busy = false
		return
	end

	if ok then
		showMessage(("VALID! +%d points!"):format(result))
	else
		if result == "code_not_found" then
			showMessage("Invalid code")
		elseif result == "already_used" then
			showMessage("Already used")
		elseif result == "expired" then
			showMessage("Code expired")
		elseif result == "already_redeemed" then
			showMessage("Code already redeemed")
		elseif result == "limit_uses" then
			showMessage("Code reached max uses")
		else
			showMessage("Error")
		end
	end

	busy = false
end

-- Connections

RedeemButton.MouseButton1Click:Connect(RedeemCodeFunction)

GameLoaded:FireServer("RedeemCodesLoaded")