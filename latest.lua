--[[ 
╔════════════════════════════════════════════════════╗
║  ██╗  ██╗ ██╗   ██╗ ██╗      ██████╗               ║
║  ██║  ██║ ╚██╗ ██╔╝ ██║     ██╔═══██╗              ║
║  ███████║  ╚████╔╝  ██║     ██║   ██║              ║
║  ██╔══██║   ╚██╔╝   ██║     ██║   ██║              ║
║  ██║  ██║    ██║    ███████╗╚██████╔╝              ║
║  ╚═╝  ╚═╝    ╚═╝    ╚══════╝ ╚═════╝               ║
║                                                    ║
║         Made By @Roblo1sjG / HYLO                  ║
╚════════════════════════════════════════════════════╝
╔════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║   ██╗   ██╗███╗   ██╗██╗██╗   ██╗███████╗██████╗ ███████╗ █████╗ ██╗          ██████╗ ██╗   ██╗██╗     ║
║   ██║   ██║████╗  ██║██║██║   ██║██╔════╝██╔══██╗██╔════╝██╔══██╗██║         ██╔════╝ ██║   ██║██║     ║
║   ██║   ██║██╔██╗ ██║██║██║   ██║█████╗  ██████╔╝███████╗███████║██║         ██║  ███╗██║   ██║██║     ║
║   ██║   ██║██║╚██╗██║██║╚██╗ ██╔╝██╔══╝  ██╔══██╗╚════██║██╔══██║██║         ██║   ██║██║   ██║██║     ║
║   ╚██████╔╝██║ ╚████║██║ ╚████╔╝ ███████╗██║  ██║███████║██║  ██║███████╗    ╚██████╔╝╚██████╔╝██║     ║
║    ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝     ╚═════╝  ╚═════╝ ╚═╝     ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════════╝
]]--

---------------------------
-- SETTINGS & VARIABLES
---------------------------
local DevMode = true
local Menu_Version = "V1.0.5 BETA"
local Menu_Name = "Universal GUI"
local titleText = "Universal GUI"
local openButtonText = "Open Universal GUI"
local closeButtonText = "Close Universal GUI"

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local flyEnabled = false
local noclipEnabled = false
local flySpeed = 50
local oldGravity = nil  -- for mobile gravity restore

-- Mobile vertical control flags
local mobileUp = false
local mobileDown = false

local Page = 1
local regenConnection = nil  -- for InstantRegen

---------------------------
-- AUTO-RELOAD CHARACTER ON DEATH (Optional)
---------------------------
player.CharacterAdded:Connect(function(character)
	local hum = character:WaitForChild("Humanoid")
	hum.StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Dead then
			wait(0.1)
			player:LoadCharacter()
		end
	end)
end)

---------------------------
-- COLLISION UPDATE (Noclip)
---------------------------
RunService.RenderStepped:Connect(function()
	local character = player.Character
	if character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = not noclipEnabled
			end
		end
	end
end)

---------------------------
-- MAIN GUI SETUP
---------------------------
local MainGui = Instance.new("ScreenGui")
MainGui.Parent = player.PlayerGui
MainGui.Name = Menu_Name

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Parent = MainGui
OpenButton.Size = UDim2.new(0, 200, 0, 50)
OpenButton.Position = UDim2.new(0.032, 0, 0.386, 0)
Instance.new("UICorner", OpenButton)
OpenButton.Font = Enum.Font.FredokaOne
OpenButton.TextScaled = true
OpenButton.BackgroundColor3 = Color3.new(0, 1, 0)
OpenButton.Text = openButtonText

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainGui
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.Visible = false
MainFrame.Size = UDim2.new(0, 500, 0, 250)
MainFrame.Position = UDim2.new(0.302, 0, 0.296, 0)
Instance.new("UICorner", MainFrame)

-- Title, Version, and Credits (Author) UI
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.new(0.784, 0, 1)
TitleLabel.Position = UDim2.new(0.3, 0, -0.252, 0)
TitleLabel.Size = UDim2.new(0, 200, 0, 35)
TitleLabel.Text = titleText
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.FredokaOne
Instance.new("UICorner", TitleLabel)

local Version_Text = Instance.new("TextLabel")
Version_Text.Name = "Version"
Version_Text.Parent = TitleLabel
Version_Text.Text = Menu_Version
Version_Text.Font = Enum.Font.FredokaOne
Version_Text.TextScaled = true
Version_Text.BackgroundColor3 = Color3.new(0, 0.607, 1)
Version_Text.Position = UDim2.new(0.5, 0, 1, 0)
Version_Text.Size = UDim2.new(0, 100, 0, 15)
Instance.new("UICorner", Version_Text)

local Credits = Instance.new("TextLabel")
Credits.Name = "Credits"
Credits.Parent = MainFrame
Credits.Position = UDim2.new(0, 0, 1.036, 0)
Credits.Size = UDim2.new(0, 100, 0, 15)
Credits.BackgroundColor3 = Color3.new(0, 0.784, 1)
Credits.Font = Enum.Font.FredokaOne
Credits.Text = "Made By @Roblo1sjG / HYLO"
Credits.TextScaled = true
Instance.new("UICorner", Credits)

-- Disconnect & Rejoin Buttons (inside MainFrame)
local DisconnectButton = Instance.new("TextButton")
DisconnectButton.Name = "DisconnectButton"
DisconnectButton.Text = "Disconnect"
DisconnectButton.Parent = MainFrame
DisconnectButton.Position = UDim2.new(0, 0, -0.254, 0)
DisconnectButton.Size = UDim2.new(0, 110, 0, 25)
DisconnectButton.Font = Enum.Font.FredokaOne
DisconnectButton.TextScaled = true
DisconnectButton.BackgroundColor3 = Color3.new(1, 0.607843, 0)
Instance.new("UICorner", DisconnectButton)
DisconnectButton.MouseButton1Click:Connect(function() 
	player:Kick("Disconnect.") 
end)

local RejoinButton = Instance.new("TextButton")
RejoinButton.Name = "RejoinButton"
RejoinButton.Text = "Rejoin"
RejoinButton.Parent = MainFrame
RejoinButton.Position = UDim2.new(0, 0, -0.134, 0)
RejoinButton.Size = UDim2.new(0, 110, 0, 25)
RejoinButton.Font = Enum.Font.FredokaOne
RejoinButton.TextScaled = true
RejoinButton.BackgroundColor3 = Color3.new(1, 0.607843, 0)
Instance.new("UICorner", RejoinButton)
RejoinButton.MouseButton1Click:Connect(function() 
	TeleportService:Teleport(game.PlaceId, player) 
end)

-- Tween-based Drag Function for MainFrame
local dragToggle = false
local dragSpeed = 0.25
local dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	TweenService:Create(MainFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
		dragToggle = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragToggle = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
		updateInput(input)
	end
end)

OpenButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
	if MainFrame.Visible then
		OpenButton.Text = closeButtonText
		OpenButton.BackgroundColor3 = Color3.new(1, 0, 0)
	else
		OpenButton.Text = openButtonText
		OpenButton.BackgroundColor3 = Color3.new(0, 1, 0)
	end
end)

---------------------------
-- SIDEBAR & CHEAT AREA SETUP
---------------------------
local SideBarFrame = Instance.new("Frame")
SideBarFrame.Parent = MainFrame
SideBarFrame.Name = "SideBarFrame"
SideBarFrame.BackgroundColor3 = Color3.new(0.588, 0.588, 0.588)
SideBarFrame.Position = UDim2.new(0, 0, 0, 0)
SideBarFrame.Size = UDim2.new(0, 100, 0, 250)
Instance.new("UICorner", SideBarFrame)

local ButtonsZoneFrame = Instance.new("Frame")
ButtonsZoneFrame.Parent = MainFrame
ButtonsZoneFrame.Name = "ButtonsZoneFrame"
ButtonsZoneFrame.BackgroundTransparency = 0
ButtonsZoneFrame.BackgroundColor3 = Color3.new(0, 0, 0)
ButtonsZoneFrame.Position = UDim2.new(0.2, 0, 0, 0)
ButtonsZoneFrame.Size = UDim2.new(0, 400, 0, 250)

local ButtonsScrollingFrame = Instance.new("ScrollingFrame")
ButtonsScrollingFrame.Parent = SideBarFrame
ButtonsScrollingFrame.Name = "ButtonsScrollingFrame"
ButtonsScrollingFrame.BackgroundTransparency = 1
ButtonsScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
ButtonsScrollingFrame.Size = UDim2.new(0, 100, 0, 250)

---------------------------
-- CHEAT FRAMES (Pages)
---------------------------
local Cheat1_Frame = Instance.new("Frame")
Cheat1_Frame.Visible = true
Cheat1_Frame.Name = "Cheat1"
Cheat1_Frame.Parent = ButtonsZoneFrame
Cheat1_Frame.BackgroundTransparency = 0
Cheat1_Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Cheat1_Frame.Position = UDim2.new(0, 0, 0, 0)
Cheat1_Frame.Size = UDim2.new(0, 400, 0, 250)
Instance.new("UICorner", Cheat1_Frame)

local Cheat2_Frame = Instance.new("Frame")
Cheat2_Frame.Visible = false
Cheat2_Frame.Name = "Cheat2"
Cheat2_Frame.Parent = ButtonsZoneFrame
Cheat2_Frame.BackgroundTransparency = 0
Cheat2_Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Cheat2_Frame.Position = UDim2.new(0, 0, 0, 0)
Cheat2_Frame.Size = UDim2.new(0, 400, 0, 250)
Instance.new("UICorner", Cheat2_Frame)

local Cheat3_Frame = Instance.new("Frame")
Cheat3_Frame.Visible = false
Cheat3_Frame.Name = "Cheat3"
Cheat3_Frame.Parent = ButtonsZoneFrame
Cheat3_Frame.BackgroundTransparency = 0
Cheat3_Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Cheat3_Frame.Position = UDim2.new(0, 0, 0, 0)
Cheat3_Frame.Size = UDim2.new(0, 400, 0, 250)
Instance.new("UICorner", Cheat3_Frame)

local function updateCheatPages()
	if Page == 1 then
		Cheat1_Frame.Visible = true
		Cheat2_Frame.Visible = false
		Cheat3_Frame.Visible = false
	elseif Page == 2 then
		Cheat1_Frame.Visible = false
		Cheat2_Frame.Visible = true
		Cheat3_Frame.Visible = false
	elseif Page == 3 then
		Cheat1_Frame.Visible = false
		Cheat2_Frame.Visible = false
		Cheat3_Frame.Visible = true
	end
end

---------------------------
-- SIDEBAR BUTTONS
---------------------------
local Cheat1_Button = Instance.new("TextButton")
Cheat1_Button.Name = "TPButton"
Cheat1_Button.Parent = ButtonsScrollingFrame
Cheat1_Button.Text = "TP"
Cheat1_Button.Font = Enum.Font.FredokaOne
Cheat1_Button.TextScaled = true
Cheat1_Button.BackgroundColor3 = Color3.new(1, 0.607, 0)
Cheat1_Button.Position = UDim2.new(0.05, 0, 0.02, 0)
Cheat1_Button.Size = UDim2.new(0, 90, 0, 25)
Instance.new("UICorner", Cheat1_Button)
Cheat1_Button.MouseButton1Click:Connect(function() Page = 1; updateCheatPages() end)

local Cheat2_Button = Instance.new("TextButton")
Cheat2_Button.Name = "MovementButton"
Cheat2_Button.Parent = ButtonsScrollingFrame
Cheat2_Button.Text = "Movement"
Cheat2_Button.Font = Enum.Font.FredokaOne
Cheat2_Button.TextScaled = true
Cheat2_Button.BackgroundColor3 = Color3.new(1, 0.607843, 0)
Cheat2_Button.Position = UDim2.new(0.05, 0, 0.10, 0)
Cheat2_Button.Size = UDim2.new(0, 90, 0, 25)
Instance.new("UICorner", Cheat2_Button)
Cheat2_Button.MouseButton1Click:Connect(function() Page = 2; updateCheatPages() end)

local Cheat3_Button = Instance.new("TextButton")
Cheat3_Button.Name = "OPButton"
Cheat3_Button.Parent = ButtonsScrollingFrame
Cheat3_Button.Text = "OP"
Cheat3_Button.Font = Enum.Font.FredokaOne
Cheat3_Button.TextScaled = true
Cheat3_Button.BackgroundColor3 = Color3.new(1, 0.607843, 0)
Cheat3_Button.Position = UDim2.new(0.05, 0, 0.18, 0)
Cheat3_Button.Size = UDim2.new(0, 90, 0, 25)
Instance.new("UICorner", Cheat3_Button)
Cheat3_Button.MouseButton1Click:Connect(function() Page = 3; updateCheatPages() end)

---------------------------
-- CHEAT PAGE 1: TELEPORT
---------------------------
local XPos = Instance.new("TextBox")
XPos.TextScaled = true
XPos.PlaceholderText = "X Coordinates"
XPos.Parent = Cheat1_Frame
XPos.Text = ""
XPos.Position = UDim2.new(0.087, 0, 0.42, 0)
XPos.Size = UDim2.new(0, 100, 0, 25)
XPos.BackgroundColor3 = Color3.new(1, 1, 1)
XPos.Font = Enum.Font.FredokaOne
XPos.Name = "XPos"
Instance.new("UICorner", XPos)

local YPos = Instance.new("TextBox")
YPos.TextScaled = true
YPos.PlaceholderText = "Y Coordinates"
YPos.Parent = Cheat1_Frame
YPos.Text = ""
YPos.Position = UDim2.new(0.375, 0, 0.42, 0)
YPos.Size = UDim2.new(0, 100, 0, 25)
YPos.BackgroundColor3 = Color3.new(1, 1, 1)
YPos.Font = Enum.Font.FredokaOne
YPos.Name = "YPos"
Instance.new("UICorner", YPos)

local ZPos = Instance.new("TextBox")
ZPos.TextScaled = true
ZPos.PlaceholderText = "Z Coordinates"
ZPos.Parent = Cheat1_Frame
ZPos.Text = ""
ZPos.Position = UDim2.new(0.663, 0, 0.42, 0)
ZPos.Size = UDim2.new(0, 100, 0, 25)
ZPos.BackgroundColor3 = Color3.new(1, 1, 1)
ZPos.Font = Enum.Font.FredokaOne
ZPos.Name = "ZPos"
Instance.new("UICorner", ZPos)

local ExecuteTPButton = Instance.new("TextButton")
ExecuteTPButton.Parent = Cheat1_Frame
ExecuteTPButton.Text = "Execute"
ExecuteTPButton.Name = "ExecuteTPButton"
ExecuteTPButton.BackgroundColor3 = Color3.new(1, 0.607, 0)
ExecuteTPButton.Position = UDim2.new(0.25, 0, 0.72, 0)
ExecuteTPButton.Size = UDim2.new(0, 200, 0, 50)
ExecuteTPButton.Font = Enum.Font.FredokaOne
ExecuteTPButton.TextScaled = true
Instance.new("UICorner", ExecuteTPButton)
ExecuteTPButton.MouseButton1Click:Connect(function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = CFrame.new(tonumber(XPos.Text), tonumber(YPos.Text), tonumber(ZPos.Text))
	end
end)

---------------------------
-- CHEAT PAGE 2: MOVEMENT
---------------------------
local WS = Instance.new("TextBox")
WS.Parent = Cheat2_Frame
WS.Position = UDim2.new(0.087, 0, 0.42, 0)
WS.Size = UDim2.new(0, 100, 0, 25)
WS.PlaceholderText = "WalkSpeed"
WS.BackgroundColor3 = Color3.new(1, 1, 1)
WS.TextScaled = true
WS.Text = "16"
WS.Font = Enum.Font.FredokaOne
WS.Name = "WS"
Instance.new("UICorner", WS)

local JP = Instance.new("TextBox")
JP.Parent = Cheat2_Frame
JP.Position = UDim2.new(0.375, 0, 0.42, 0)
JP.Size = UDim2.new(0, 100, 0, 25)
JP.PlaceholderText = "JumpPower"
JP.BackgroundColor3 = Color3.new(1, 1, 1)
JP.TextScaled = true
JP.Text = "50"
JP.Font = Enum.Font.FredokaOne
JP.Name = "JP"
Instance.new("UICorner", JP)

local LG = Instance.new("TextButton")
LG.Parent = Cheat2_Frame
LG.Position = UDim2.new(0.663, 0, 0.42, 0)
LG.Size = UDim2.new(0, 100, 0, 25)
LG.BackgroundColor3 = Color3.new(1, 0, 0)
LG.TextScaled = true
LG.Text = "Low Gravity: Off"
LG.Font = Enum.Font.FredokaOne
LG.Name = "LG"
Instance.new("UICorner", LG)
LG.MouseButton1Click:Connect(function()
	if LG.Text == "Low Gravity: Off" then
		local success, err = pcall(function() workspace.Gravity = 50 end)
		if not success then warn("Failed to change Gravity: " .. tostring(err)) end
		LG.Text = "Low Gravity: On"
		LG.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		local success, err = pcall(function() workspace.Gravity = 196.2 end)
		if not success then warn("Failed to change Gravity: " .. tostring(err)) end
		LG.Text = "Low Gravity: Off"
		LG.BackgroundColor3 = Color3.new(1, 0, 0)
	end
end)

local ExecuteWSButton = Instance.new("TextButton")
ExecuteWSButton.Parent = Cheat2_Frame
ExecuteWSButton.Position = UDim2.new(0.087, 0, 0.58, 0)
ExecuteWSButton.Size = UDim2.new(0, 100, 0, 25)
ExecuteWSButton.BackgroundColor3 = Color3.new(1, 0.607843, 0)
ExecuteWSButton.TextScaled = true
ExecuteWSButton.Font = Enum.Font.FredokaOne
ExecuteWSButton.Text = "Execute"
ExecuteWSButton.Name = "ExecuteWSButton"
Instance.new("UICorner", ExecuteWSButton)
ExecuteWSButton.MouseButton1Click:Connect(function()
	local wsVal = tonumber(WS.Text) or 16
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		local success, err = pcall(function() humanoid.WalkSpeed = wsVal end)
		if not success then warn("Failed to change WalkSpeed: " .. tostring(err)) end
	end
end)

local ExecuteJPButton = Instance.new("TextButton")
ExecuteJPButton.Parent = Cheat2_Frame
ExecuteJPButton.Position = UDim2.new(0.375, 0, 0.58, 0)
ExecuteJPButton.Size = UDim2.new(0, 100, 0, 25)
ExecuteJPButton.BackgroundColor3 = Color3.new(1, 0.607843, 0)
ExecuteJPButton.TextScaled = true
ExecuteJPButton.Font = Enum.Font.FredokaOne
ExecuteJPButton.Text = "Execute"
ExecuteJPButton.Name = "ExecuteJPButton"
Instance.new("UICorner", ExecuteJPButton)
ExecuteJPButton.MouseButton1Click:Connect(function()
	local jpVal = tonumber(JP.Text) or 50
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		local success, err = pcall(function() humanoid.JumpPower = jpVal end)
		if not success then warn("Failed to change JumpPower: " .. tostring(err)) end
	end
end)

---------------------------
-- CHEAT PAGE 3: OP (Fly, Noclip, Map Transparency, Highlight, InstantRegen, Refresh)
---------------------------
local MT = Instance.new("TextBox")
MT.Parent = Cheat3_Frame
MT.Position = UDim2.new(0.087, 0, 0.42, 0)
MT.Size = UDim2.new(0, 100, 0, 25)
MT.BackgroundColor3 = Color3.new(1, 1, 1)
MT.TextScaled = true
MT.Font = Enum.Font.FredokaOne
MT.Text = "0.5"
MT.Name = "MT"
MT.PlaceholderText = "Map Transparency [NUMBER]"
Instance.new("UICorner", MT)

local Fly = Instance.new("TextButton")
Fly.Parent = Cheat3_Frame
Fly.Position = UDim2.new(0.375, 0, 0.42, 0)
Fly.Size = UDim2.new(0, 100, 0, 25)
Fly.BackgroundColor3 = Color3.new(1, 0, 0)
Fly.TextScaled = true
Fly.Font = Enum.Font.FredokaOne
Fly.Text = "Fly: Off"
Fly.Name = "Fly"
Instance.new("UICorner", Fly)

local Noclip = Instance.new("TextButton")
Noclip.Parent = Cheat3_Frame
Noclip.Position = UDim2.new(0.675, 0, 0.42, 0)
Noclip.Size = UDim2.new(0, 100, 0, 25)
Noclip.BackgroundColor3 = Color3.new(1, 0, 0)
Noclip.TextScaled = true
Noclip.Font = Enum.Font.FredokaOne
Noclip.Text = "Noclip: Off"
Noclip.Name = "Noclip"
Instance.new("UICorner", Noclip)

local HighlightAll = Instance.new("TextButton")
HighlightAll.Parent = Cheat3_Frame
HighlightAll.Position = UDim2.new(0.675, 0, 0.58, 0)
HighlightAll.Size = UDim2.new(0, 100, 0, 25)
HighlightAll.BackgroundColor3 = Color3.new(1, 0, 0)
HighlightAll.TextScaled = true
HighlightAll.Font = Enum.Font.FredokaOne
HighlightAll.Text = "Highlight All: Off"
HighlightAll.Name = "HighlightAll"
Instance.new("UICorner", HighlightAll)
HighlightAll.ZIndex = 2

local InstantRegen = Instance.new("TextButton")
InstantRegen.Parent = Cheat3_Frame
InstantRegen.Position = UDim2.new(0.375, 0, 0.58, 0)
InstantRegen.Size = UDim2.new(0, 100, 0, 25)
InstantRegen.BackgroundColor3 = Color3.new(1, 0, 0)
InstantRegen.TextScaled = true
InstantRegen.Font = Enum.Font.FredokaOne
InstantRegen.Text = "InstantRegen: Off"
InstantRegen.Name = "InstantRegen"
Instance.new("UICorner", InstantRegen)
InstantRegen.ZIndex = 2

local RefreshCharacter = Instance.new("TextButton")
RefreshCharacter.Parent = MainFrame
RefreshCharacter.Position = UDim2.new(0.25, 0, -0.094, 0)
RefreshCharacter.Size = UDim2.new(0, 100, 0, 15)
RefreshCharacter.BackgroundColor3 = Color3.new(1, 0.607843, 0)
RefreshCharacter.TextScaled = true
RefreshCharacter.Font = Enum.Font.FredokaOne
RefreshCharacter.Text = "RefreshCharacter"
RefreshCharacter.Name = "RefreshCharacter"
Instance.new("UICorner", RefreshCharacter)
RefreshCharacter.ZIndex = 2
RefreshCharacter.MouseButton1Click:Connect(function()
	local character = player.Character
	if character and character:FindFirstChild("Humanoid") then
		character.Humanoid.Health = 0
	end
end)

local ExecuteTransButton = Instance.new("TextButton")
ExecuteTransButton.Parent = Cheat3_Frame
ExecuteTransButton.Text = "Execute"
ExecuteTransButton.Name = "ExecuteTransButton"
-- Updated position per request:
ExecuteTransButton.Position = UDim2.new(0.087, 0, 0.58, 0)
ExecuteTransButton.Size = UDim2.new(0, 100, 0, 25)
ExecuteTransButton.BackgroundColor3 = Color3.new(1, 0.607843, 0)
ExecuteTransButton.TextScaled = true
ExecuteTransButton.Font = Enum.Font.FredokaOne
Instance.new("UICorner", ExecuteTransButton)
ExecuteTransButton.MouseButton1Click:Connect(function()
	local transparencyValue = tonumber(MT.Text) or 0.5
	local ws = game:GetService("Workspace")
	local Players = game:GetService("Players")
	local function isPlayerCharacter(object)
		for _, plr in pairs(Players:GetPlayers()) do
			if plr.Character and object:IsDescendantOf(plr.Character) then return true end
		end
		return false
	end
	local function applyTransparency()
		local count = 0
		for _, obj in pairs(ws:GetDescendants()) do
			if obj:IsA("BasePart") and not isPlayerCharacter(obj) then
				obj.Transparency = transparencyValue
				count = count + 1
			end
		end
		print("Transparency applied to", count, "map parts")
	end
	repeat wait() until player:FindFirstChild("PlayerGui")
	print("Starting transparency change...")
	applyTransparency()
	print("Transparency change complete!")
end)

---------------------------
-- FLY SPEED TEXTBOX & MOBILE FLY BUTTONS (for mobile)
---------------------------
local FlySpeedBox = Instance.new("TextBox")
FlySpeedBox.Name = "FlySpeedBox"
FlySpeedBox.Parent = MainGui
FlySpeedBox.Position = UDim2.new(0.5, -50, 0, 20)
FlySpeedBox.Size = UDim2.new(0, 100, 0, 30)
FlySpeedBox.BackgroundColor3 = Color3.new(1, 0.607843, 0)
FlySpeedBox.TextScaled = true
FlySpeedBox.Font = Enum.Font.FredokaOne
FlySpeedBox.PlaceholderText = "Fly Speed"
FlySpeedBox.Text = tostring(flySpeed)
Instance.new("UICorner", FlySpeedBox)
FlySpeedBox.Visible = false

FlySpeedBox.FocusLost:Connect(function()
	local newSpeed = tonumber(FlySpeedBox.Text)
	if newSpeed then
		flySpeed = newSpeed
	else
		FlySpeedBox.Text = tostring(flySpeed)
	end
end)

local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Parent = MainGui
UpButton.Text = "Up"
UpButton.Font = Enum.Font.FredokaOne
UpButton.TextScaled = true
UpButton.BackgroundColor3 = Color3.new(0, 1, 0)
UpButton.Position = UDim2.new(0, 20, 1, -150)
UpButton.Size = UDim2.new(0, 48, 0, 25)
Instance.new("UICorner", UpButton)
UpButton.Visible = false

local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Parent = MainGui
DownButton.Text = "Down"
DownButton.Font = Enum.Font.FredokaOne
DownButton.TextScaled = true
DownButton.BackgroundColor3 = Color3.new(1, 0, 0)
DownButton.Position = UDim2.new(0, 80, 1, -150)
DownButton.Size = UDim2.new(0, 48, 0, 25)
Instance.new("UICorner", DownButton)
DownButton.Visible = false

UpButton.MouseButton1Down:Connect(function() mobileUp = true end)
UpButton.MouseButton1Up:Connect(function() mobileUp = false end)
DownButton.MouseButton1Down:Connect(function() mobileDown = true end)
DownButton.MouseButton1Up:Connect(function() mobileDown = false end)

---------------------------
-- FLY HANDLING (HD Admin–Style: Freeze Body & Smoothly Follow Camera)
---------------------------
local bv, bg  -- BodyVelocity and BodyGyro
local hdFlying = false

local function startFly_HD()
	local character = player.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local hum = character:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	hum.PlatformStand = true
	FlySpeedBox.Visible = true
	if UIS.TouchEnabled then
		UpButton.Visible = true
		DownButton.Visible = true
		oldGravity = workspace.Gravity
		workspace.Gravity = 0
	end

	bv = Instance.new("BodyVelocity", hrp)
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)

	bg = Instance.new("BodyGyro", hrp)
	bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bg.CFrame = workspace.CurrentCamera.CFrame

	hdFlying = true
	local flyConn = RunService.RenderStepped:Connect(function()
		if not hdFlying then
			if flyConn then flyConn:Disconnect() end
			return
		end

		local cam = workspace.CurrentCamera
		local moveDir = Vector3.new(0, 0, 0)
		if UIS.TouchEnabled then
			local horizontal = hum.MoveDirection
			local vertical = 0
			if mobileUp then vertical = vertical + 1 end
			if mobileDown then vertical = vertical - 1 end
			moveDir = Vector3.new(horizontal.X, vertical, horizontal.Z)
		else
			if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
		end

		if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
		bv.Velocity = moveDir * flySpeed
		bg.CFrame = bg.CFrame:Lerp(cam.CFrame, 0.1)
	end)
end

local function stopFly_HD()
	hdFlying = false
	local character = player.Character
	if character then
		local hum = character:FindFirstChildOfClass("Humanoid")
		if hum then hum.PlatformStand = false end
	end
	if bv then
		bv:Destroy() 
		bv = nil
	end
	if bg then
		bg:Destroy() 
		bg = nil
	end
	if UIS.TouchEnabled and oldGravity then
		workspace.Gravity = oldGravity
		oldGravity = nil
	end
	FlySpeedBox.Visible = false
	UpButton.Visible = false
	DownButton.Visible = false
end

Fly.MouseButton1Click:Connect(function()
	if not flyEnabled then
		flyEnabled = true
		startFly_HD()
		Fly.Text = "Fly: On"
		Fly.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		flyEnabled = false
		stopFly_HD()
		Fly.Text = "Fly: Off"
		Fly.BackgroundColor3 = Color3.new(1, 0, 0)
	end
end)

Noclip.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		Noclip.Text = "Noclip: On"
		Noclip.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		Noclip.Text = "Noclip: Off"
		Noclip.BackgroundColor3 = Color3.new(1, 0, 0)
	end
end)

HighlightAll.MouseButton1Click:Connect(function()
	local Players = game:GetService("Players")
	if HighlightAll.Text == "Highlight All: Off" then
		local function highlightCharacter(character)
			if character and not character:FindFirstChildOfClass("Highlight") then
				local hl = Instance.new("Highlight")
				hl.Parent = character
			end
		end
		for _, plr in pairs(Players:GetPlayers()) do
			if plr.Character then highlightCharacter(plr.Character) end
			plr.CharacterAdded:Connect(highlightCharacter)
		end
		HighlightAll.Text = "Highlight All: On"
		HighlightAll.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		for _, plr in pairs(Players:GetPlayers()) do
			if plr.Character then
				for _, child in ipairs(plr.Character:GetChildren()) do
					if child:IsA("Highlight") then child:Destroy() end
				end
			end
		end
		HighlightAll.Text = "Highlight All: Off"
		HighlightAll.BackgroundColor3 = Color3.new(1, 0, 0)
	end
end)

InstantRegen.MouseButton1Click:Connect(function()
	if InstantRegen.Text == "InstantRegen: Off" then
		InstantRegen.Text = "InstantRegen: On"
		InstantRegen.BackgroundColor3 = Color3.new(0, 1, 0)
		noclipEnabled = true
		regenConnection = RunService.Heartbeat:Connect(function()
			local character = player.Character
			if character then
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					humanoid.MaxHealth = 99999
					humanoid.Health = 99999
					if not character:FindFirstChild("ForceField") then
						local ff = Instance.new("ForceField")
						ff.Parent = character
					end
				end
			end
		end)
	else
		InstantRegen.Text = "InstantRegen: Off"
		InstantRegen.BackgroundColor3 = Color3.new(1, 0, 0)
		noclipEnabled = false
		if regenConnection then
			regenConnection:Disconnect()
		end
		local character = player.Character
		if character then
			local ff = character:FindFirstChild("ForceField")
			if ff then ff:Destroy() end
		end
	end
end)

---------------------------
-- UPDATE CHEAT PAGE DISPLAY
---------------------------
updateCheatPages()
