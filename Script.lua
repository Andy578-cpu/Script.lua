local Services = {
    Players = game:GetService("Players"),
    RS = game:GetService("ReplicatedStorage"),
    UIS = game:GetService("UserInputService"),
    Tween = game:GetService("TweenService"),
    Run = game:GetService("RunService")
}

local LocalPlayer = Services.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

if not PlayerGui then return warn("PlayerGui not found") end

-- Config
local CONFIG = {
    Theme = {
        Primary = Color3.fromRGB(25, 115, 255),
        Dark = Color3.fromRGB(18, 18, 28),
        Accent = Color3.fromRGB(60, 160, 255),
        Text = Color3.fromRGB(245, 245, 255),
        Border = Color3.fromRGB(45, 45, 65)
    },
    CornerRadius = 12,
    ButtonHeight = 42,
    AnimationSpeed = 0.22
}

--// Create GUI
local sg = Instance.new("ScreenGui")
sg.Name = "PornAP_Premium"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(280, 380)
main.Position = UDim2.new(0.02, 0, 0.5, -190)
main.BackgroundColor3 = CONFIG.Theme.Dark
main.BackgroundTransparency = 0.12
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = sg

local stroke = Instance.new("UIStroke")
stroke.Color = CONFIG.Theme.Border
stroke.Thickness = 1.5
stroke.Transparency = 0.65
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = main

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40,40,60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,35))
}
gradient.Rotation = 90
gradient.Parent = main

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, CONFIG.CornerRadius)
corner.Parent = main

-- Shadow (fake premium look)
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1,40,1,40)
shadow.Position = UDim2.new(0,-20,0,-20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ImageTransparency = 0.75
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49,49,450,450)
shadow.ZIndex = -1
shadow.Parent = main

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,46)
titleBar.BackgroundTransparency = 1
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7,0,1,0)
title.Position = UDim2.new(0,16,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.Text = "PORN • AP"
title.TextColor3 = CONFIG.Theme.Text
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTransparency = 0.1
title.Parent = titleBar

local version = Instance.new("TextLabel")
version.AnchorPoint = Vector2.new(1,0)
version.Position = UDim2.new(1,-16,0.5,0)
version.Size = UDim2.new(0,60,0,20)
version.BackgroundTransparency = 1
version.Font = Enum.Font.Gotham
version.Text = "v2.1 • EXT"
version.TextColor3 = Color3.fromRGB(140,180,255)
version.TextSize = 13
version.TextTransparency = 0.4
version.Parent = titleBar

-- Lock Button
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.fromOffset(34,34)
lockBtn.Position = UDim2.new(1,-46,0,6)
lockBtn.BackgroundColor3 = Color3.fromRGB(35,35,50)
lockBtn.Text = "🔓"
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 18
lockBtn.TextColor3 = Color3.fromRGB(200,220,255)
lockBtn.BorderSizePixel = 0
lockBtn.AutoButtonColor = false
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0,8)
lockBtn.Parent = titleBar

-- Scroll
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-24,1,-62)
scroll.Position = UDim2.new(0,12,0,54)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = CONFIG.Theme.Primary
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = main

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0,8)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = scroll

--// Dragging System
local dragging, dragInput, dragStart, startPos
local locked = false

local function updateDrag(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

main.InputBegan:Connect(function(input)
    if locked then return end
    if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then return end
    
    dragging = true
    dragStart = input.Position
    startPos = main.Position
    
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end)

main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

Services.UIS.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateDrag(input)
    end
end)

-- Lock toggle + animation
lockBtn.MouseButton1Click:Connect(function()
    locked = not locked
    
    local goal = locked and {BackgroundColor3 = Color3.fromRGB(190,60,60)} or {BackgroundColor3 = Color3.fromRGB(35,35,50)}
    Services.Tween:Create(lockBtn, TweenInfo.new(0.3,Enum.EasingStyle.Quint), goal):Play()
    
    lockBtn.Text = locked and "🔒" or "🔓"
end)

--// Remote Finder (more safe way)
local function getExploitRemote()
    local success, remote = pcall(function()
        local pkg = Services.RS:FindFirstChild("Packages", true)
        if not pkg then return nil end
        
        local net = pkg:FindFirstChild("Net", true)
        if not net then return nil end
        
        return net:FindFirstChild("RE/352aad58-c786-4998-886b-3e4fa390721e", true)
    end)
    
    return success and remote or nil
end

local REMOTE = getExploitRemote()
if not REMOTE then
    warn("[KiaHub] Critical: Exploit remote not found!")
end

--// Create stylish player button
local function createPremiumButton(plr)
    if plr == LocalPlayer then return end
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, CONFIG.ButtonHeight)
    btn.BackgroundColor3 = Color3.fromRGB(32, 45, 80)
    btn.BorderSizePixel = 0
    btn.TextColor3 = CONFIG.Theme.Text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 15
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Text = "  " .. plr.Name
    btn.AutoButtonColor = false
    btn.Parent = scroll
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = CONFIG.Theme.Primary
    btnStroke.Thickness = 1.2
    btnStroke.Transparency = 0.8
    btnStroke.Parent = btn
    
    local highlight = Instance.new("Frame")
    highlight.Size = UDim2.new(0,4,1,0)
    highlight.BackgroundColor3 = CONFIG.Theme.Primary
    highlight.BorderSizePixel = 0
    highlight.BackgroundTransparency = 1
    Instance.new("UICorner", highlight).CornerRadius = UDim.new(1,0)
    highlight.Parent = btn

    -- Click effect
    btn.MouseButton1Click:Connect(function()
        if not REMOTE then return end
        
        local tweenIn = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local tweenOut = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        
        -- Visual feedback
        Services.Tween:Create(btn, tweenIn, {BackgroundColor3 = Color3.fromRGB(45,65,110)}):Play()
        Services.Tween:Create(highlight, tweenIn, {BackgroundTransparency = 0}):Play()
        Services.Tween:Create(btnStroke, tweenIn, {Transparency = 0.3}):Play()
        
        task.delay(0.25, function()
            if not btn.Parent then return end
            Services.Tween:Create(btn, tweenOut, {BackgroundColor3 = Color3.fromRGB(32,45,80)}):Play()
            Services.Tween:Create(highlight, tweenOut, {BackgroundTransparency = 1}):Play()
            Services.Tween:Create(btnStroke, tweenOut, {Transparency = 0.8}):Play()
        end)

        -- Spam the effects (pro style)
        task.spawn(function()
            local effects = {"tiny", "balloon", "rocket", "inverse"}
            for _, effect in ipairs(effects) do
                pcall(function()
                    REMOTE:FireServer("78a772b6-9e1c-4827-ab8b-04a07838f298", plr, effect)
                end)
                task.wait(0.06)
            end
        end)
    end)
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        Services.Tween:Create(btnStroke, TweenInfo.new(0.25), {Transparency = 0.45}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        if not btn.Parent then return end
        Services.Tween:Create(btnStroke, TweenInfo.new(0.35), {Transparency = 0.8}):Play()
    end)
end

-- Initial load
for _, plr in Services.Players:GetPlayers() do
    createPremiumButton(plr)
end

Services.Players.PlayerAdded:Connect(createPremiumButton)

Services.Players.PlayerRemoving:Connect(function(plr)
    for _, obj in scroll:GetChildren() do
        if obj:IsA("TextButton") and obj.Text:find(plr.Name, 1, true) then
            obj:Destroy()
        end
    end
end)

-- Auto canvas size
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.fromOffset(0, list.AbsoluteContentSize.Y + 16)
end)
