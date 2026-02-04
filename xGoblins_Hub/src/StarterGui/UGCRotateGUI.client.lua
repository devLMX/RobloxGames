local tweenService = game:GetService("TweenService")

local gui = script.Parent
local MainFrame = gui:WaitForChild("MainFrame")
local BuyUGC = MainFrame:WaitForChild("BuyUGC")

local nextR = MainFrame:WaitForChild("nextUGCright")
local nextL = MainFrame:WaitForChild("nextUGCleft")

local buyUGC1 = BuyUGC:WaitForChild("buy_ugc")
local buyUGC2 = BuyUGC:WaitForChild("buy_ugc2")
local buyUGC3 = BuyUGC:WaitForChild("buy_ugc3")
local buyUGC4 = BuyUGC:WaitForChild("buy_ugc4")

local Wframe = MainFrame:WaitForChild("WFrame")

local MENU = gui:WaitForChild("MENU")

local PURCHASE = MainFrame:WaitForChild("main"):WaitForChild("PURCHASE")

local rotate = buyUGC1:WaitForChild("Rotate")
local rotate2 = buyUGC2:WaitForChild("Rotate")
local rotate3 = buyUGC3:WaitForChild("Rotate")
local rotate4 = buyUGC4:WaitForChild("Rotate")

local ugcs = {
	buyUGC1,
	buyUGC2,
	buyUGC3,
	buyUGC4
}

local rotates = {
	rotate,
	rotate2,
	rotate3,
	rotate4
}

local currentUGC = 1
local currentRotate = 1

local tweeninfo = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out
)

local function updateVisibilityR()
	ugcs[currentUGC].Visible = true
	ugcs[currentUGC].Position = UDim2.new(1, 0, 0, 0)
	rotates[currentRotate].Value = true

	local TweenR = tweenService:Create(
		ugcs[currentUGC],
		tweeninfo,
		{Position = UDim2.new(0, 0, 0, 0)}
	)
	TweenR:Play()
end

local function updateVisibilityCR()
	ugcs[currentUGC].Visible = true
	ugcs[currentUGC].Position = UDim2.new(0, 0, 0, 0)
	rotates[currentRotate].Value = false

	local TweenCR = tweenService:Create(
		ugcs[currentUGC],
		tweeninfo,
		{Position = UDim2.new(-1, 0, 0, 0)}
	)
	TweenCR:Play()
end

local function updateVisibilityL()
	ugcs[currentUGC].Visible = true
	ugcs[currentUGC].Position = UDim2.new(-1, 0, 0, 0)
	rotates[currentRotate].Value = true

	local TweenL = tweenService:Create(
		ugcs[currentUGC],
		tweeninfo,
		{Position = UDim2.new(0, 0, 0, 0)}
	)
	TweenL:Play()
end

local function updateVisibilityCL()
	ugcs[currentUGC].Visible = true
	ugcs[currentUGC].Position = UDim2.new(0, 0, 0, 0)
	rotates[currentRotate].Value = false

	local TweenCL = tweenService:Create(
		ugcs[currentUGC],
		tweeninfo,
		{Position = UDim2.new(1, 0, 0, 0)}
	)
	TweenCL:Play()
end

nextR.MouseButton1Click:Connect(function()
	updateVisibilityCR()
	currentUGC = currentUGC + 1
	if currentUGC > #ugcs then
		currentUGC = 1
	end
	currentRotate = currentRotate + 1
	if currentRotate > #rotates then
		currentRotate = 1
	end
	updateVisibilityR()
	Wframe.Visible = false
end)

nextL.MouseButton1Click:Connect(function()
	updateVisibilityCL()
	currentUGC = currentUGC - 1
	if currentUGC < 1 then
		currentUGC = #ugcs
	end
	currentRotate = currentRotate - 1
	if currentRotate < 1 then 
		currentRotate = #rotates
	end
	updateVisibilityL()
	Wframe.Visible = false
end)

MENU.MouseButton1Click:Connect(function()
	rotates[currentRotate].Value = false
end)

PURCHASE.MouseButton1Click:Connect(function()
	currentUGC = 1
	currentRotate = 1
	ugcs[currentUGC].Position = UDim2.new(0, 0, 0, 0)
	ugcs[currentUGC].Visible = true
	rotates[currentRotate].Value = true
end)