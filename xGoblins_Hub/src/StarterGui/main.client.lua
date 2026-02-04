-- GetService

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ReplicatedStorage References

local rotateflag = ReplicatedStorage:WaitForChild("UGCRotate")

-- LocalScript References

local camera = workspace.CurrentCamera
local Gui = script.Parent
local focusPart = workspace:FindFirstChild("CameraFocus")

-- Frames

local MainFrame = Gui:WaitForChild("MainFrame")
local GiftTab = MainFrame:WaitForChild("GiftTab")
local Outfit = MainFrame:WaitForChild("Outfit")
local WFrame = MainFrame:WaitForChild("WFrame")
local main = MainFrame:WaitForChild("main")
local CatalogTab = MainFrame:WaitForChild("Catalog")
local BuyUGCTab = MainFrame:WaitForChild("BuyUGC")

-- Buttons

local menuBtn = Gui:WaitForChild("MENU")
local RlateralBtn = Gui:WaitForChild("lateralD")
local LlateralBtn = Gui:WaitForChild("lateralE")
local Wbtn = MainFrame:WaitForChild("warning")
local GiftBtn = MainFrame:WaitForChild("gift")
local RnextBtn = MainFrame:WaitForChild("nextUGCright")
local LnextBtn = MainFrame:WaitForChild("nextUGCleft")

local CatalogBtn = main:WaitForChild("CATALOG")
local indexBtn = main:WaitForChild("INDEX")
local PurchaseBtn = main:WaitForChild("PURCHASE")
local TryOnBtn = main:WaitForChild("TRYON")
local ExitBtn = CatalogTab:WaitForChild("exit")

-- BuyUGC

local buyUGC1 = BuyUGCTab:WaitForChild("buy_ugc")
local buyUGC2 = BuyUGCTab:WaitForChild("buy_ugc2")
local buyUGC3 = BuyUGCTab:WaitForChild("buy_ugc3")
local buyUGC4 = BuyUGCTab:WaitForChild("buy_ugc4")

-- BuyUGC Buttons

local BuyUGCBtn1 = buyUGC1:WaitForChild("main"):WaitForChild("4Frame"):WaitForChild("4BUY UGC")
local BuyUGCBtn2 = buyUGC2:WaitForChild("main"):WaitForChild("4Frame"):WaitForChild("4BUY UGC")
local BuyUGCBtn3 = buyUGC3:WaitForChild("main"):WaitForChild("4Frame"):WaitForChild("4BUY UGC")
local BuyUGCBtn4 = buyUGC4:WaitForChild("main"):WaitForChild("4Frame"):WaitForChild("4BUY UGC")

-- Rotate

local rotate = buyUGC1:WaitForChild("Rotate")
local rotate2 = buyUGC2:WaitForChild("Rotate")
local rotate3 = buyUGC3:WaitForChild("Rotate")
local rotate4 = buyUGC4:WaitForChild("Rotate")

-- Extra stuff

local BlueGradient = GiftBtn:WaitForChild("Frame"):WaitForChild("BlueGradient")
local GreenGradient = GiftBtn:WaitForChild("Frame"):WaitForChild("GreenGradient")
local BlueStroke = GiftBtn:WaitForChild("Frame"):WaitForChild("BlueStroke")
local GreenStroke = GiftBtn:WaitForChild("Frame"):WaitForChild("GreenStroke")

-- dicionary

local items = {
	{ camPos = Vector3.new(23.5, 15.132, -162.986) },
	{ camPos = Vector3.new(67, 15.132, -162.986) },
	{ camPos = Vector3.new(108, 15.132, -162.986) },
	{ camPos = Vector3.new(145.207, 15.132, -162.986) },
	{ camPos = Vector3.new(181.889, 15.132, -162.986) },
	{ camPos = Vector3.new(222, 15.132, -162.986) },
	{ camPos = Vector3.new(263.2, 15.132, -162.986) },
	{ camPos = Vector3.new(300.036, 15.132, -162.986) }
}

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

-- index tween functions

local current = 1
local activeTween
local fixedRotation

local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local function focus(index)
	local camPos = items[index].camPos
	if activeTween then activeTween:Cancel() end

	activeTween = TweenService:Create(camera, tweenInfo,
		{CFrame = CFrame.new(camPos) * fixedRotation}
	)
	activeTween:Play()
end

-- purchase tween funcions

local currentUGC = 1
local currentRotate = 1

local tweeninfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local function updateVisibilityR()
	ugcs[currentUGC].Visible = true
	ugcs[currentUGC].Position = UDim2.new(1, 0, 0, 0)
	rotates[currentRotate].Value = true

	local TweenR = TweenService:Create(
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

	local TweenCR = TweenService:Create(
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

	local TweenL = TweenService:Create(
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

	local TweenCL = TweenService:Create(
		ugcs[currentUGC],
		tweeninfo,
		{Position = UDim2.new(1, 0, 0, 0)}
	)
	TweenCL:Play()
end

-- main buttons

indexBtn.MouseButton1Click:Connect(function()
	rotateflag.Value = true

	MainFrame.Visible = false

	menuBtn.Position = UDim2.new(0.411, 0, 0.033, 0)
	menuBtn.Visible = true

	LlateralBtn.Visible = true
	RlateralBtn.Visible = true

	camera.CameraType = Enum.CameraType.Scriptable

	local look = CFrame.lookAt(
		items[1].camPos,
		focusPart.Position
	)

	fixedRotation = look.Rotation
	current = 1

	camera.CFrame = CFrame.new(items[1].camPos) * fixedRotation
end)

PurchaseBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	BuyUGCTab.Visible = true
	menuBtn.Position = UDim2.new(0.411, 0, 0.033, 0)
	menuBtn.Visible = true
	RnextBtn.Visible = true
	LnextBtn.Visible = true
	GiftBtn.Visible = true
	Wbtn.Visible = true

	-- tween funcions

	currentUGC = 1
	currentRotate = 1
	ugcs[currentUGC].Position = UDim2.new(0, 0, 0, 0)
	ugcs[currentUGC].Visible = true
	rotates[currentRotate].Value = true
end)

menuBtn.MouseButton1Click:Connect(function()

	-- start

	if activeTween then
		activeTween:Cancel()
		activeTween = nil
	end

	rotates[currentRotate].Value = false

	menuBtn.Visible = false

	MainFrame.Visible = true
	main.Visible = true

	-- frames

	BuyUGCTab.Visible = false
	Outfit.Visible = false
	WFrame.Visible = false

	-- buttons

	Wbtn.Visible = false
	GiftBtn.Visible = false
	LnextBtn.Visible = false
	RnextBtn.Visible = false
	LlateralBtn.Visible = false
	RlateralBtn.Visible = false

	-- extra stuff

	if GiftTab.Visible == true then
		BlueGradient.Enabled = true
		BlueStroke.Enabled = true
		GreenGradient.Enabled = false
		GreenStroke.Enabled = false
		GiftTab.Visible = false
	end

	if currentUGC ~= 1 then
		updateVisibilityCR()
		currentUGC = 1
		currentRotate = 1
		updateVisibilityR()
	end

	rotateflag.Value = false
end)

TryOnBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	Outfit.Visible = true
	menuBtn.Position = UDim2.new(0.8, 0, 0.033, 0)
	menuBtn.Visible = true
end)

CatalogBtn.MouseButton1Click:Connect(function()
	CatalogTab.Visible = true
end)

ExitBtn.MouseButton1Click:Connect(function()
	CatalogTab.Visible = false
end)

GiftBtn.MouseButton1Click:Connect(function()
	if WFrame.Visible == true then
		WFrame.Visible = false
	end
	if GiftTab.Visible == false then
		GiftTab.Visible = true
		GreenGradient.Enabled = true
		GreenStroke.Enabled = true
		BlueGradient.Enabled = false
		BlueStroke.Enabled = false
		BuyUGCBtn1.Interactable = false
		BuyUGCBtn2.Interactable = false
		BuyUGCBtn3.Interactable = false
		BuyUGCBtn4.Interactable = false
	else
		GiftTab.Visible = false
		BlueGradient.Enabled = true
		BlueStroke.Enabled = true
		GreenGradient.Enabled = false
		GreenStroke.Enabled = false
		BuyUGCBtn1.Interactable = true
		BuyUGCBtn2.Interactable = true
		BuyUGCBtn3.Interactable = true
		BuyUGCBtn4.Interactable = true
	end
end)

Wbtn.MouseButton1Click:Connect(function()
	if GiftTab.Visible == true then
		GiftTab.Visible = false
		BlueGradient.Enabled = true
		BlueStroke.Enabled = true
		GreenGradient.Enabled = false
		GreenStroke.Enabled = false
	end
	if WFrame.Visible == true then
		WFrame.Visible = false
	else
		WFrame.Visible = true
	end
end)

-- Lateral Buttons

RlateralBtn.MouseButton1Click:Connect(function()
	current += 1
	if current > #items then current = 1 end
	focus(current)
end)

LlateralBtn.MouseButton1Click:Connect(function()
	current -= 1
	if current < 1 then current = #items end
	focus(current)
end)


-- next buttons

RnextBtn.MouseButton1Click:Connect(function()
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
	WFrame.Visible = false
end)

LnextBtn.MouseButton1Click:Connect(function()
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
	WFrame.Visible = false
end)