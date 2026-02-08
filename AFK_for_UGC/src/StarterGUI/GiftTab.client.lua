-- Services

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

-- Variables

local GiftTab = script.Parent.Parent:WaitForChild("Tabs"):WaitForChild("GiftTabFindPlayer")

local FindPlayerBtn = GiftTab:WaitForChild("FindPlayer")
local SendGiftBtn = GiftTab:WaitForChild("SendGift")

local UsernameBox = GiftTab:WaitForChild("UsernameBox")
local GiftBox = UsernameBox:WaitForChild("TextBox")

local displayname = GiftTab:WaitForChild("displayname")
local username = GiftTab:WaitForChild("username")
local found = GiftTab:WaitForChild("found")
local giftname = GiftTab:WaitForChild("giftname")
local thumbnail = GiftTab:WaitForChild("Thumbnail")

local SendGift = ReplicatedStorage:WaitForChild("SendGift")
local GameLoaded = ReplicatedStorage:WaitForChild("GameLoaded")

local userId
local Gifted
local Gift

-- Events

FindPlayerBtn.MouseButton1Click:Connect(function()
	if GiftBox.Text == "" then
		found.Text = "Player not found!"
	elseif GiftBox.Text ~= "" then
		found.Text = "Finding Player..."
		local playerBox = GiftBox.Text
		userId = Players:GetUserIdFromNameAsync(playerBox)
		local player = Players:GetNameFromUserIdAsync(userId)
		local thumb, isReady = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		task.wait(1.2)
		if not userId or not thumb then
			found.Text = "Player not found!"
		end

		username.Text = "@" .. player
		displayname.Text = player
		thumbnail.Image = thumb
		found.Text = "Player found!"
	end
end)

SendGiftBtn.MouseButton1Click:Connect(function()
	Gifted = userId
	Gift = giftname.Text
	if Gifted ~= nil and Gift ~= nil then
		SendGift:FireServer(Gifted, Gift)
	end
end)

SendGift.OnClientEvent:Connect(function(status)
	if status == "success" then
		found.Text = "Gift sent!"
	elseif status == "cannot_gift_self" then
		SendGiftBtn.Text = "You cannot gift yourself!"
		task.wait(0.8)
		SendGiftBtn.Text = "Send Gift"
	elseif status == "already_owned" then
		SendGiftBtn.Text = "Player already owns this gift!"
		task.wait(0.8)
		SendGiftBtn.Text = "Send Gift"
	end
end)

task.wait(1.1)
GameLoaded:FireServer("GiftTab")