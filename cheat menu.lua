local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local ESPEnabled = true
local showBoxes = true
local showNames = true
local showDistance = true
local showTracers = true
local speedHackEnabled = false
local Rotatespeed = 60
local speedMultiplier = 2
local spinBotEnabled = false
local infiniteJumpEnabled = false
local noclipEnabled = false
local flyEnabled = false
local menuVisible = true
local aimbotEnabled = false
local aimbotKey = Enum.KeyCode.LeftShift
local aimbotMode = "Mouse"
local aimbotFOV = 50
local aimbotSmoothness = 10
local aimbotPart = "Head"
local aimbotVisible = true
local boxColor = Color3.fromRGB(255, 255, 255)
local nameColor = Color3.fromRGB(255, 255, 255)
local distColor = Color3.fromRGB(0, 255, 255)
local tracerColor = Color3.fromRGB(255, 255, 255)
local hitboxColor = Color3.fromRGB(255, 0, 0)
local onePressMode = false
local triggerBotEnabled = false
local triggerBotKey = Enum.KeyCode.RightControl
local triggerBotDelay = 0.1
local aimbotActive = false
local lastTriggerTime = 0
local maxESPDistance = 1000
local toggleMenuKey = Enum.KeyCode.Insert
local espTargetMode = "All"
local aimbotTargetMode = "Enemies"
local triggerBotTargetMode = "Enemies"

local whitelistEnabled = false
local espWhitelist = {}
local aimbotWhitelist = {}
local triggerWhitelist = {}

local colorPalette = {
    Color3.fromRGB(255,255,255), Color3.fromRGB(255,0,0),
    Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255),
    Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255),
    Color3.fromRGB(0,255,255), Color3.fromRGB(128,128,128),
    Color3.fromRGB(0,0,0),
}

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "Cheat by Kimaru"
gui.DisplayOrder = 999
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Position = UDim2.new(0, 10, 0.5, -150)
mainFrame.Size = UDim2.new(0, 400, 0, 430)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = menuVisible
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("Frame", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, -30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BorderSizePixel = 0

local titleText = Instance.new("TextLabel", title)
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 0, 0, 0)
titleText.Text = "Cheat by Kimaru"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 18
titleText.BackgroundTransparency = 1
titleText.TextXAlignment = Enum.TextXAlignment.Left

local closeButton = Instance.new("TextButton", title)
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0

local tabButtons = Instance.new("Frame", mainFrame)
tabButtons.Size = UDim2.new(1, 0, 0, 30)
tabButtons.Position = UDim2.new(0, 0, 0, 0)
tabButtons.BackgroundTransparency = 1

local currentTab = "Main"

local mainContent = Instance.new("ScrollingFrame", mainFrame)
mainContent.Position = UDim2.new(0, 0, 0, 30)
mainContent.Size = UDim2.new(1, 0, 1, -30)
mainContent.BackgroundTransparency = 1
mainContent.ScrollBarThickness = 5
mainContent.CanvasSize = UDim2.new(0, 0, 0, 700)

local visualsContent = Instance.new("ScrollingFrame", mainFrame)
visualsContent.Position = UDim2.new(0, 0, 0, 30)
visualsContent.Size = UDim2.new(1, 0, 1, -30)
visualsContent.BackgroundTransparency = 1
visualsContent.Visible = false
visualsContent.ScrollBarThickness = 5
visualsContent.CanvasSize = UDim2.new(0, 0, 0, 900)

local botsContent = Instance.new("ScrollingFrame", mainFrame)
botsContent.Position = UDim2.new(0, 0, 0, 30)
botsContent.Size = UDim2.new(1, 0, 1, -30)
botsContent.BackgroundTransparency = 1
botsContent.Visible = false
botsContent.ScrollBarThickness = 5
botsContent.CanvasSize = UDim2.new(0, 0, 0, 1000)

local otherContent = Instance.new("ScrollingFrame", mainFrame)
otherContent.Position = UDim2.new(0, 0, 0, 30)
otherContent.Size = UDim2.new(1, 0, 1, -30)
otherContent.BackgroundTransparency = 1
otherContent.Visible = false
otherContent.ScrollBarThickness = 5
otherContent.CanvasSize = UDim2.new(0, 0, 0, 200)

local function tweenButton(button)
    local originalSize = button.Size
    local originalPos = button.Position
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, tweenInfo, {
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 5, originalSize.Y.Scale, originalSize.Y.Offset),
            Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 2.5, originalPos.Y.Scale, originalPos.Y.Offset)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, tweenInfo, {
            Size = originalSize,
            Position = originalPos
        })
        tween:Play()
    end)
end

local function createTabButton(name, index)
    local btn = Instance.new("TextButton", tabButtons)
    btn.Size = UDim2.new(0.25, -2, 1, 0)
    btn.Position = UDim2.new((index-1)*0.25, 1, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = currentTab == name and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    tweenButton(btn)
    
    btn.MouseButton1Click:Connect(function()
        currentTab = name
        mainContent.Visible = name == "Main"
        visualsContent.Visible = name == "Visuals"
        botsContent.Visible = name == "Bots"
        otherContent.Visible = name == "Other"
        for _, child in ipairs(tabButtons:GetChildren()) do
            if child:IsA("TextButton") and child ~= btn then
                child.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    return btn
end

local mainTabBtn = createTabButton("Main", 1)
local visualsTabBtn = createTabButton("Visuals", 2)
local botsTabBtn = createTabButton("Bots", 3)
local otherTabBtn = createTabButton("Other", 4)

local paletteFrame = Instance.new("Frame", gui)
paletteFrame.Position = UDim2.new(0, 240, 0.5, -150)
paletteFrame.Size = UDim2.new(0, 180, 0, 120)
paletteFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
paletteFrame.BorderSizePixel = 0
paletteFrame.Visible = false

local paletteTitle = Instance.new("TextLabel", paletteFrame)
paletteTitle.Size = UDim2.new(1, 0, 0, 20)
paletteTitle.Position = UDim2.new(0, 0, 0, 0)
paletteTitle.Text = "Select Color"
paletteTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
paletteTitle.TextColor3 = Color3.new(1, 1, 1)
paletteTitle.Font = Enum.Font.SourceSans
paletteTitle.TextSize = 14

local function createLabel(parent, text, y)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.Position = UDim2.new(0, 5, 0, y)
    lbl.Text = text
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local function createToggleButton(parent, name, posY, value, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.Position = UDim2.new(0, 5, 0, posY)
    frame.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.7, 0, 1, 0)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.Text = name .. ": " .. (value and "ON" or "OFF")
    btn.BackgroundColor3 = value and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    tweenButton(btn)
    
    btn.MouseButton1Click:Connect(function()
        value = not value
        btn.Text = name .. ": " .. (value and "ON" or "OFF")
        btn.BackgroundColor3 = value and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        callback(value)
    end)
    
    return btn, frame
end

local function createSlider(parent, name, posY, min, max, value, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.Position = UDim2.new(0, 5, 0, posY)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 15)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Text = name .. ": " .. value
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local slider = Instance.new("TextBox", frame)
    slider.Size = UDim2.new(1, 0, 0, 25)
    slider.Position = UDim2.new(0, 0, 0, 20)
    slider.Text = tostring(value)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    slider.TextColor3 = Color3.new(1, 1, 1)
    slider.Font = Enum.Font.SourceSans
    slider.TextSize = 14
    slider.BorderSizePixel = 0
    tweenButton(slider)
    
    slider.FocusLost:Connect(function()
        local num = tonumber(slider.Text)
        if num and num >= min and num <= max then
            value = num
            label.Text = name .. ": " .. value
            callback(value)
        else
            slider.Text = tostring(value)
        end
    end)
    
    return slider
end

local function createDropdown(parent, name, posY, options, current, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.Position = UDim2.new(0, 5, 0, posY)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 15)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Text = name
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdown = Instance.new("TextButton", frame)
    dropdown.Size = UDim2.new(1, 0, 0, 25)
    dropdown.Position = UDim2.new(0, 0, 0, 20)
    dropdown.Text = current
    dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropdown.TextColor3 = Color3.new(1, 1, 1)
    dropdown.Font = Enum.Font.SourceSans
    dropdown.TextSize = 14
    dropdown.BorderSizePixel = 0
    tweenButton(dropdown)
    
    local dropdownFrame = Instance.new("Frame", gui)
    dropdownFrame.Size = UDim2.new(0, 150, 0, math.min(#options * 25 + 5, 150))
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    dropdownFrame.BorderSizePixel = 1
    dropdownFrame.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
    dropdownFrame.Visible = false
    dropdownFrame.ZIndex = 1000
    
    local scroll = Instance.new("ScrollingFrame", dropdownFrame)
    scroll.Size = UDim2.new(1, -5, 1, -5)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.CanvasSize = UDim2.new(0, 0, 0, #options * 25)
    scroll.ScrollBarThickness = 5
    scroll.BackgroundTransparency = 1
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 0)
    
    dropdown.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
        
        if dropdownFrame.Visible then
            local buttonPos = dropdown.AbsolutePosition
            local buttonSize = dropdown.AbsoluteSize
            local frameSize = dropdownFrame.AbsoluteSize
            
            local viewportSize = workspace.CurrentCamera.ViewportSize
            local yPos = buttonPos.Y + buttonSize.Y
            
            if yPos + frameSize.Y > viewportSize.Y then
                yPos = buttonPos.Y - frameSize.Y
            end
            
            dropdownFrame.Position = UDim2.new(0, buttonPos.X, 0, yPos)
        end
    end)
    
    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton", scroll)
        optionBtn.Size = UDim2.new(1, -5, 0, 25)
        optionBtn.Position = UDim2.new(0, 0, 0, (i-1)*25)
        optionBtn.Text = " " .. option
        optionBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        optionBtn.TextColor3 = Color3.new(1, 1, 1)
        optionBtn.Font = Enum.Font.SourceSans
        optionBtn.TextSize = 14
        optionBtn.TextXAlignment = Enum.TextXAlignment.Left
        optionBtn.BorderSizePixel = 0
        optionBtn.ZIndex = 1001
        tweenButton(optionBtn)
        
        optionBtn.MouseButton1Click:Connect(function()
            dropdown.Text = option
            callback(option)
            dropdownFrame.Visible = false
        end)
    end
    
    local function closeDropdown(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdownFrame.Visible then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local framePos = dropdownFrame.AbsolutePosition
            local frameSize = dropdownFrame.AbsoluteSize
            
            local isInsideDropdown = 
                mousePos.X >= framePos.X and 
                mousePos.X <= framePos.X + frameSize.X and
                mousePos.Y >= framePos.Y and 
                mousePos.Y <= framePos.Y + frameSize.Y
                
            local isInsideButton = 
                mousePos.X >= dropdown.AbsolutePosition.X and 
                mousePos.X <= dropdown.AbsolutePosition.X + dropdown.AbsoluteSize.X and
                mousePos.Y >= dropdown.AbsolutePosition.Y and 
                mousePos.Y <= dropdown.AbsolutePosition.Y + dropdown.AbsoluteSize.Y
            
            if not isInsideDropdown and not isInsideButton then
                dropdownFrame.Visible = false
            end
        end
    end
    
    UserInputService.InputBegan:Connect(closeDropdown)
    
    return dropdown
end

local function createWhitelistMenu(parent, tab)
    local whitelistFrame = Instance.new("Frame", gui)
    whitelistFrame.Position = UDim2.new(0, 420, 0.5, -150)
    whitelistFrame.Size = UDim2.new(0, 300, 0, 300)
    whitelistFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    whitelistFrame.BorderSizePixel = 0
    whitelistFrame.Visible = false
    whitelistFrame.Active = true
    whitelistFrame.Draggable = true

    local whitelistTitle = Instance.new("Frame", whitelistFrame)
    whitelistTitle.Size = UDim2.new(1, 0, 0, 30)
    whitelistTitle.Position = UDim2.new(0, 0, 0, -30)
    whitelistTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    whitelistTitle.BorderSizePixel = 0

    local whitelistTitleText = Instance.new("TextLabel", whitelistTitle)
    whitelistTitleText.Size = UDim2.new(1, -30, 1, 0)
    whitelistTitleText.Position = UDim2.new(0, 0, 0, 0)
    whitelistTitleText.Text = tab .. " Whitelist"
    whitelistTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    whitelistTitleText.Font = Enum.Font.SourceSansBold
    whitelistTitleText.TextSize = 18
    whitelistTitleText.BackgroundTransparency = 1
    whitelistTitleText.TextXAlignment = Enum.TextXAlignment.Left

    local whitelistCloseButton = Instance.new("TextButton", whitelistTitle)
    whitelistCloseButton.Size = UDim2.new(0, 30, 1, 0)
    whitelistCloseButton.Position = UDim2.new(1, -30, 0, 0)
    whitelistCloseButton.Text = "X"
    whitelistCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    whitelistCloseButton.Font = Enum.Font.SourceSansBold
    whitelistCloseButton.TextSize = 18
    whitelistCloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    whitelistCloseButton.BorderSizePixel = 0

    local whitelistContent = Instance.new("ScrollingFrame", whitelistFrame)
    whitelistContent.Position = UDim2.new(0, 0, 0, 0)
    whitelistContent.Size = UDim2.new(1, 0, 1, 0)
    whitelistContent.BackgroundTransparency = 1
    whitelistContent.ScrollBarThickness = 5
    whitelistContent.CanvasSize = UDim2.new(0, 0, 0, 0)

    local whitelistToggle = Instance.new("TextButton", whitelistFrame)
    whitelistToggle.Size = UDim2.new(1, -10, 0, 30)
    whitelistToggle.Position = UDim2.new(0, 5, 1, -35)
    whitelistToggle.Text = "Enable Whitelist"
    whitelistToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    whitelistToggle.TextColor3 = Color3.new(1, 1, 1)
    whitelistToggle.Font = Enum.Font.SourceSans
    whitelistToggle.TextSize = 14
    whitelistToggle.BorderSizePixel = 0

    local function updateWhitelist()
        whitelistContent.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 30)
        
        for _, child in ipairs(whitelistContent:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local yPos = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local playerFrame = Instance.new("Frame", whitelistContent)
                playerFrame.Size = UDim2.new(1, -10, 0, 25)
                playerFrame.Position = UDim2.new(0, 5, 0, yPos)
                playerFrame.BackgroundTransparency = 1

                local playerName = Instance.new("TextLabel", playerFrame)
                playerName.Size = UDim2.new(0.7, 0, 1, 0)
                playerName.Position = UDim2.new(0, 0, 0, 0)
                playerName.Text = player.Name
                playerName.BackgroundTransparency = 1
                playerName.TextColor3 = Color3.new(1, 1, 1)
                playerName.Font = Enum.Font.SourceSans
                playerName.TextSize = 14
                playerName.TextXAlignment = Enum.TextXAlignment.Left

                local toggleBtn = Instance.new("TextButton", playerFrame)
                toggleBtn.Size = UDim2.new(0.3, 0, 1, 0)
                toggleBtn.Position = UDim2.new(0.7, 0, 0, 0)
                toggleBtn.Text = "OFF"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
                toggleBtn.TextColor3 = Color3.new(1, 1, 1)
                toggleBtn.Font = Enum.Font.SourceSans
                toggleBtn.TextSize = 14
                toggleBtn.BorderSizePixel = 0

                if tab == "ESP" and espWhitelist[player] then
                    toggleBtn.Text = "ON"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                elseif tab == "Aimbot" and aimbotWhitelist[player] then
                    toggleBtn.Text = "ON"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                elseif tab == "Trigger" and triggerWhitelist[player] then
                    toggleBtn.Text = "ON"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                end

                toggleBtn.MouseButton1Click:Connect(function()
                    if tab == "ESP" then
                        espWhitelist[player] = not espWhitelist[player]
                        toggleBtn.Text = espWhitelist[player] and "ON" or "OFF"
                        toggleBtn.BackgroundColor3 = espWhitelist[player] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
                    elseif tab == "Aimbot" then
                        aimbotWhitelist[player] = not aimbotWhitelist[player]
                        toggleBtn.Text = aimbotWhitelist[player] and "ON" or "OFF"
                        toggleBtn.BackgroundColor3 = aimbotWhitelist[player] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
                    elseif tab == "Trigger" then
                        triggerWhitelist[player] = not triggerWhitelist[player]
                        toggleBtn.Text = triggerWhitelist[player] and "ON" or "OFF"
                        toggleBtn.BackgroundColor3 = triggerWhitelist[player] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
                    end
                end)

                yPos = yPos + 30
            end
        end
    end

    whitelistToggle.MouseButton1Click:Connect(function()
        whitelistEnabled = not whitelistEnabled
        whitelistToggle.Text = whitelistEnabled and "Disable Whitelist" or "Enable Whitelist"
        whitelistToggle.BackgroundColor3 = whitelistEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
    end)

    whitelistCloseButton.MouseButton1Click:Connect(function()
        whitelistFrame.Visible = false
    end)

    Players.PlayerAdded:Connect(updateWhitelist)
    Players.PlayerRemoving:Connect(updateWhitelist)

    return function()
        whitelistFrame.Visible = not whitelistFrame.Visible
        if whitelistFrame.Visible then
            updateWhitelist()
        end
    end
end

local speedSlider = createSlider(mainContent, "Speed Multiplier", 0, 1, 1000, speedMultiplier, function(value)
    speedMultiplier = value
end)

local speedBtn = createToggleButton(mainContent, "Speed Hack", 55, speedHackEnabled, function(value)
    speedHackEnabled = value
    if not value and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end)

local spinBotBtn = createToggleButton(mainContent, "Spin Bot", 90, spinBotEnabled, function(value)
    spinBotEnabled = value
end)

local infiniteJumpBtn = createToggleButton(mainContent, "Infinite Jump", 125, infiniteJumpEnabled, function(value)
    infiniteJumpEnabled = value
end)

local noclipBtn = createToggleButton(mainContent, "Noclip & Fly", 160, noclipEnabled, function(value)
    noclipEnabled = value
    flyEnabled = value
end)

local rotateSlider = createSlider(mainContent, "Spin Speed", 195, 1, 360, Rotatespeed, function(value)
    Rotatespeed = value
end)

createLabel(mainContent, "Teleport to Player:", 250)
local playerNameInput = Instance.new("TextBox", mainContent)
playerNameInput.Size = UDim2.new(1, -10, 0, 25)
playerNameInput.Position = UDim2.new(0, 5, 0, 270)
playerNameInput.PlaceholderText = "Player Name"
playerNameInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerNameInput.TextColor3 = Color3.new(1, 1, 1)
playerNameInput.Font = Enum.Font.SourceSans
playerNameInput.TextSize = 14
playerNameInput.BorderSizePixel = 0
tweenButton(playerNameInput)

local teleportBtn = Instance.new("TextButton", mainContent)
teleportBtn.Size = UDim2.new(1, -10, 0, 25)
teleportBtn.Position = UDim2.new(0, 5, 0, 300)
teleportBtn.Text = "Teleport"
teleportBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Font = Enum.Font.SourceSans
teleportBtn.TextSize = 14
teleportBtn.BorderSizePixel = 0
tweenButton(teleportBtn)

teleportBtn.MouseButton1Click:Connect(function()
    local targetName = playerNameInput.Text
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(targetName:lower()) then
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                LocalPlayer.Character:MoveTo(hrp.Position)
            end
            break
        end
    end
end)

local espObjects = {}
local hitboxParts = {}

local function clearESP()
    for _, player in pairs(espObjects) do
        if player.box then player.box:Remove() end
        if player.name then player.name:Remove() end
        if player.dist then player.dist:Remove() end
        if player.tracer then player.tracer:Remove() end
    end
    espObjects = {}
end

local function closeMenu()
    gui:Destroy()
    ESPEnabled = false
    speedHackEnabled = false
    spinBotEnabled = false
    infiniteJumpEnabled = false
    noclipEnabled = false
    flyEnabled = false
    aimbotEnabled = false
    
    for _, player in pairs(espObjects) do
        if player.box then player.box:Remove() end
        if player.name then player.name:Remove() end
        if player.dist then player.dist:Remove() end
        if player.tracer then player.tracer:Remove() end
    end
    espObjects = {}
    
    for part, box in pairs(hitboxParts) do
        if box then box:Destroy() end
    end
    hitboxParts = {}
end

closeButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2), {Position = UDim2.new(0, -400, 0.5, -150)})
    tween:Play()
    tween.Completed:Wait()
    closeMenu()
end)

local espBtn = createToggleButton(visualsContent, "ESP", 0, ESPEnabled, function(value)
    ESPEnabled = value
    if not value then
        clearESP()
    end
end)

local boxesBtn = createToggleButton(visualsContent, "Boxes", 35, showBoxes, function(value)
    showBoxes = value
end)

local namesBtn = createToggleButton(visualsContent, "Names", 70, showNames, function(value)
    showNames = value
end)

local distBtn = createToggleButton(visualsContent, "Distance", 105, showDistance, function(value)
    showDistance = value
end)

local tracersBtn = createToggleButton(visualsContent, "Tracers", 140, showTracers, function(value)
    showTracers = value
end)

local distanceSlider = createSlider(visualsContent, "Max ESP Distance", 175, 0, 1000, maxESPDistance, function(value)
    maxESPDistance = value
end)

local espTargetDropdown = createDropdown(visualsContent, "ESP Targets", 230, {"All", "Enemies", "Teammates"}, espTargetMode, function(value)
    espTargetMode = value
end)

local espWhitelistBtn = Instance.new("TextButton", visualsContent)
espWhitelistBtn.Size = UDim2.new(1, -10, 0, 25)
espWhitelistBtn.Position = UDim2.new(0, 5, 0, 265)
espWhitelistBtn.Text = "ESP Whitelist"
espWhitelistBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espWhitelistBtn.TextColor3 = Color3.new(1, 1, 1)
espWhitelistBtn.Font = Enum.Font.SourceSans
espWhitelistBtn.TextSize = 14
espWhitelistBtn.BorderSizePixel = 0
tweenButton(espWhitelistBtn)

local showESPWhitelist = createWhitelistMenu(visualsContent, "ESP")
espWhitelistBtn.MouseButton1Click:Connect(showESPWhitelist)

local function createColorOption(parent, name, posY, colorVar, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.Position = UDim2.new(0, 5, 0, posY)
    frame.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.7, 0, 1, 0)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    tweenButton(btn)
    
    local colorPreview = Instance.new("Frame", frame)
    colorPreview.Size = UDim2.new(0.25, 0, 1, 0)
    colorPreview.Position = UDim2.new(0.75, 0, 0, 0)
    colorPreview.BackgroundColor3 = colorVar
    colorPreview.BorderSizePixel = 0
    
    btn.MouseButton1Click:Connect(function()
        paletteFrame.Visible = not paletteFrame.Visible
        paletteTitle.Text = name
        
        for _, child in ipairs(paletteFrame:GetChildren()) do
            if child ~= paletteTitle then
                child:Destroy()
            end
        end
        
        for i, color in ipairs(colorPalette) do
            local colorBtn = Instance.new("TextButton", paletteFrame)
            colorBtn.Size = UDim2.new(0, 30, 0, 30)
            colorBtn.Position = UDim2.new(0, ((i-1) % 6) * 30, 0, 20 + math.floor((i-1)/6) * 30)
            colorBtn.BackgroundColor3 = color
            colorBtn.BorderSizePixel = 0
            colorBtn.Text = ""
            tweenButton(colorBtn)
            
            if color == colorVar then
                colorBtn.BorderSizePixel = 2
                colorBtn.BorderColor3 = Color3.new(1, 1, 1)
            end
            
            colorBtn.MouseButton1Click:Connect(function()
                callback(color)
                colorPreview.BackgroundColor3 = color
                paletteFrame.Visible = false
            end)
        end
    end)
    
    return colorPreview
end

local boxColorPreview = createColorOption(visualsContent, "Box Color", 300, boxColor, function(color)
    boxColor = color
end)

local nameColorPreview = createColorOption(visualsContent, "Name Color", 335, nameColor, function(color)
    nameColor = color
end)

local distColorPreview = createColorOption(visualsContent, "Distance Color", 370, distColor, function(color)
    distColor = color
end)

local tracerColorPreview = createColorOption(visualsContent, "Tracer Color", 405, tracerColor, function(color)
    tracerColor = color
end)

local hitboxColorPreview = createColorOption(visualsContent, "Hitbox Color", 440, hitboxColor, function(color)
    hitboxColor = color
end)

local function isEnemy(player)
    if player == LocalPlayer then return false end
    
    if whitelistEnabled then
        if aimbotWhitelist[player] ~= nil then return not aimbotWhitelist[player] end
        if espWhitelist[player] ~= nil then return not espWhitelist[player] end
        if triggerWhitelist[player] ~= nil then return not triggerWhitelist[player] end
    end
    
    local localTeam = LocalPlayer.Team
    local playerTeam = player.Team
    
    if not localTeam or not playerTeam then return true end
    
    return localTeam ~= playerTeam
end

local function isTeammate(player)
    return not isEnemy(player)
end

local function isPlayerVisible(player)
    if not player or not player.Character then return false end
    
    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or humanoid.Health <= 0 or not head then return false end
    
    local cameraPos = Camera.CFrame.Position
    local targetPos = head.Position
    
    if maxESPDistance > 0 and (targetPos - cameraPos).Magnitude > maxESPDistance then
        return false
    end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    
    local raycastResult = workspace:Raycast(cameraPos, (targetPos - cameraPos).Unit * 1000, raycastParams)
    
    return not raycastResult
end

local function shouldShowESP(player)
    if player == LocalPlayer then return false end
    
    if whitelistEnabled and espWhitelist[player] ~= nil then 
        return espWhitelist[player] 
    end
    
    if espTargetMode == "All" then return true end
    if espTargetMode == "Enemies" and isEnemy(player) then return true end
    if espTargetMode == "Teammates" and isTeammate(player) then return true end
    
    return false
end

local function shouldAimbotTarget(player)
    if player == LocalPlayer then return false end
    
    if whitelistEnabled and aimbotWhitelist[player] ~= nil then 
        return aimbotWhitelist[player] 
    end
    
    if aimbotTargetMode == "All" then return true end
    if aimbotTargetMode == "Enemies" and isEnemy(player) then return true end
    if aimbotTargetMode == "Teammates" and isTeammate(player) then return true end
    
    return false
end

local function shouldTriggerBotTarget(player)
    if player == LocalPlayer then return false end
    
    if whitelistEnabled and triggerWhitelist[player] ~= nil then 
        return triggerWhitelist[player] 
    end
    
    if triggerBotTargetMode == "All" then return true end
    if triggerBotTargetMode == "Enemies" and isEnemy(player) then return true end
    if triggerBotTargetMode == "Teammates" and isTeammate(player) then return true end
    
    return false
end

local function triggerBot()
    if not triggerBotEnabled or tick() - lastTriggerTime < triggerBotDelay then return end
    
    local target = Mouse.Target
    if target and target.Parent then
        local humanoid = target.Parent:FindFirstChildOfClass("Humanoid")
        local player = Players:GetPlayerFromCharacter(target.Parent)
        if humanoid and humanoid.Health > 0 and player and player ~= LocalPlayer and shouldTriggerBotTarget(player) then
            lastTriggerTime = tick()
            local mousePos = UserInputService:GetMouseLocation()
            VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)
        end
    end
end

local aimbotBtn = createToggleButton(botsContent, "Aimbot", 0, aimbotEnabled, function(value)
    aimbotEnabled = value
    fovCircle.Visible = aimbotEnabled and aimbotVisible
end)

local onePressBtn = createToggleButton(botsContent, "One-Press Mode", 35, onePressMode, function(value)
    onePressMode = value
end)

local triggerBotBtn = createToggleButton(botsContent, "Trigger Bot", 70, triggerBotEnabled, function(value)
    triggerBotEnabled = value
end)

local modeDropdown = createDropdown(botsContent, "Aimbot Mode", 105, {"Mouse", "Camera"}, aimbotMode, function(value)
    aimbotMode = value
end)

local partDropdown = createDropdown(botsContent, "Aimbot Part", 160, {"Head", "HumanoidRootPart", "Torso"}, aimbotPart, function(value)
    aimbotPart = value
end)

local fovSlider = createSlider(botsContent, "Aimbot FOV", 215, 1, 360, aimbotFOV, function(value)
    aimbotFOV = value
    updateFovCircle()
end)

local smoothSlider = createSlider(botsContent, "Aimbot Smoothness", 270, 1, 30, aimbotSmoothness, function(value)
    aimbotSmoothness = value
end)

local aimbotTargetDropdown = createDropdown(botsContent, "Aimbot Targets", 325, {"All", "Enemies", "Teammates"}, aimbotTargetMode, function(value)
    aimbotTargetMode = value
end)

local triggerBotTargetDropdown = createDropdown(botsContent, "Trigger Bot Targets", 390, {"All", "Enemies", "Teammates"}, triggerBotTargetMode, function(value)
    triggerBotTargetMode = value
end)

local aimbotWhitelistBtn = Instance.new("TextButton", botsContent)
aimbotWhitelistBtn.Size = UDim2.new(1, -10, 0, 25)
aimbotWhitelistBtn.Position = UDim2.new(0, 5, 0, 455)
aimbotWhitelistBtn.Text = "Aimbot Whitelist"
aimbotWhitelistBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
aimbotWhitelistBtn.TextColor3 = Color3.new(1, 1, 1)
aimbotWhitelistBtn.Font = Enum.Font.SourceSans
aimbotWhitelistBtn.TextSize = 14
aimbotWhitelistBtn.BorderSizePixel = 0
tweenButton(aimbotWhitelistBtn)

local showAimbotWhitelist = createWhitelistMenu(botsContent, "Aimbot")
aimbotWhitelistBtn.MouseButton1Click:Connect(showAimbotWhitelist)

local triggerWhitelistBtn = Instance.new("TextButton", botsContent)
triggerWhitelistBtn.Size = UDim2.new(1, -10, 0, 25)
triggerWhitelistBtn.Position = UDim2.new(0, 5, 0, 490)
triggerWhitelistBtn.Text = "Trigger Whitelist"
triggerWhitelistBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
triggerWhitelistBtn.TextColor3 = Color3.new(1, 1, 1)
triggerWhitelistBtn.Font = Enum.Font.SourceSans
triggerWhitelistBtn.TextSize = 14
triggerWhitelistBtn.BorderSizePixel = 0
tweenButton(triggerWhitelistBtn)

local showTriggerWhitelist = createWhitelistMenu(botsContent, "Trigger")
triggerWhitelistBtn.MouseButton1Click:Connect(showTriggerWhitelist)

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Transparency = 0.5

local function updateFovCircle()
    fovCircle.Visible = aimbotEnabled and aimbotVisible
    fovCircle.Radius = aimbotFOV
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
end

local fovToggleBtn = createToggleButton(botsContent, "Show FOV Circle", 525, aimbotVisible, function(value)
    aimbotVisible = value
    updateFovCircle()
end)

local keyInput = Instance.new("TextButton", botsContent)
keyInput.Size = UDim2.new(1, -10, 0, 25)
keyInput.Position = UDim2.new(0, 5, 0, 560)
keyInput.Text = "Aimbot Key: LeftShift"
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyInput.TextColor3 = Color3.new(1, 1, 1)
keyInput.Font = Enum.Font.SourceSans
keyInput.TextSize = 14
keyInput.BorderSizePixel = 0
tweenButton(keyInput)

keyInput.MouseButton1Click:Connect(function()
    keyInput.Text = "Press any key..."
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            aimbotKey = input.KeyCode
            keyInput.Text = "Aimbot Key: " .. tostring(input.KeyCode)
            connection:Disconnect()
        end
    end)
end)

local triggerKeyInput = Instance.new("TextButton", botsContent)
triggerKeyInput.Size = UDim2.new(1, -10, 0, 25)
triggerKeyInput.Position = UDim2.new(0, 5, 0, 595)
triggerKeyInput.Text = "Trigger Key: RightControl"
triggerKeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
triggerKeyInput.TextColor3 = Color3.new(1, 1, 1)
triggerKeyInput.Font = Enum.Font.SourceSans
triggerKeyInput.TextSize = 14
triggerKeyInput.BorderSizePixel = 0
tweenButton(triggerKeyInput)

triggerKeyInput.MouseButton1Click:Connect(function()
    triggerKeyInput.Text = "Press any key..."
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            triggerBotKey = input.KeyCode
            triggerKeyInput.Text = "Trigger Key: " .. tostring(input.KeyCode)
            connection:Disconnect()
        end
    end)
end)

local menuKeyInput = Instance.new("TextButton", otherContent)
menuKeyInput.Size = UDim2.new(1, -10, 0, 25)
menuKeyInput.Position = UDim2.new(0, 5, 0, 0)
menuKeyInput.Text = "Menu Toggle Key: Insert"
menuKeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
menuKeyInput.TextColor3 = Color3.new(1, 1, 1)
menuKeyInput.Font = Enum.Font.SourceSans
menuKeyInput.TextSize = 14
menuKeyInput.BorderSizePixel = 0
tweenButton(menuKeyInput)

menuKeyInput.MouseButton1Click:Connect(function()
    menuKeyInput.Text = "Press any key..."
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            toggleMenuKey = input.KeyCode
            menuKeyInput.Text = "Menu Toggle Key: " .. tostring(input.KeyCode)
            connection:Disconnect()
        end
    end)
end)

local function noclipLoop()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

local flySpeed = 50
local flyKeys = {
    [Enum.KeyCode.W] = Vector3.new(0, 0, -1),
    [Enum.KeyCode.S] = Vector3.new(0, 0, 1),
    [Enum.KeyCode.A] = Vector3.new(-1, 0, 0),
    [Enum.KeyCode.D] = Vector3.new(1, 0, 0),
    [Enum.KeyCode.Space] = Vector3.new(0, 1, 0),
    [Enum.KeyCode.LeftShift] = Vector3.new(0, -1, 0)
}

local function flyLoop()
    if flyEnabled and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local camCF = Camera.CFrame
            local moveVector = Vector3.new()
            
            for key, vector in pairs(flyKeys) do
                if UserInputService:IsKeyDown(key) then
                    moveVector = moveVector + vector
                end
            end
            
            if moveVector.Magnitude > 0 then
                moveVector = camCF:VectorToWorldSpace(moveVector).Unit * flySpeed
                root.Velocity = moveVector
                root.AssemblyLinearVelocity = moveVector
            else
                root.Velocity = Vector3.new()
                root.AssemblyLinearVelocity = Vector3.new()
                root.Velocity = root.Velocity + Vector3.new(0, 6.15, 0)
            end
        end
    end
end

local function findClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and shouldAimbotTarget(player) then
            local character = player.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local part = character:FindFirstChild(aimbotPart)
            
            if humanoid and humanoid.Health > 0 and part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (screenPoint - center).Magnitude
                    
                    if distance <= aimbotFOV then
                        local realDistance = (part.Position - Camera.CFrame.Position).Magnitude
                        if realDistance < closestDistance then
                            closestDistance = realDistance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAt(target)
    if not target or not target.Character then return end
    
    local part = target.Character:FindFirstChild(aimbotPart)
    if not part then return end
    
    if aimbotMode == "Mouse" then
        local screenPos = Camera:WorldToViewportPoint(part.Position)
        local mouse = game:GetService("UserInputService"):GetMouseLocation()
        local delta = Vector2.new(screenPos.X - mouse.X, screenPos.Y - mouse.Y)
        mousemoverel(delta.X/aimbotSmoothness, delta.Y/aimbotSmoothness)
    else
        local camCF = Camera.CFrame
        local targetPos = part.Position
        local direction = (targetPos - camCF.Position).Unit
        local smoothFactor = 1 / aimbotSmoothness
        local newLook = camCF.LookVector:Lerp(direction, smoothFactor)
        Camera.CFrame = CFrame.new(camCF.Position, camCF.Position + newLook)
    end
end

local function toggleMenu()
    menuVisible = not menuVisible
    if menuVisible then
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        mainFrame.Visible = true
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2), {Position = UDim2.new(0, 10, 0.5, -150)})
        tween:Play()
    else
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2), {Position = UDim2.new(0, -400, 0.5, -150)})
        tween:Play()
        tween.Completed:Wait()
        mainFrame.Visible = false
    end
    paletteFrame.Visible = false
end

local function createESP(player)
    if player == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Visible = false

    local nameText = Drawing.new("Text")
    nameText.Size = 13
    nameText.Center = true
    nameText.Outline = true
    nameText.Visible = false

    local distText = Drawing.new("Text")
    distText.Size = 13
    distText.Center = true
    distText.Outline = true
    distText.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 1

    espObjects[player] = {box = box, name = nameText, dist = distText, tracer = tracer}
end

local function removeESP(player)
    if espObjects[player] then
        if espObjects[player].box then espObjects[player].box:Remove() end
        if espObjects[player].name then espObjects[player].name:Remove() end
        if espObjects[player].dist then espObjects[player].dist:Remove() end
        if espObjects[player].tracer then espObjects[player].tracer:Remove() end
        espObjects[player] = nil
    end
end

local function createHitbox(player)
    if player == LocalPlayer or hitboxParts[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_Hitbox"
    box.Adornee = humanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 4)
    box.Transparency = 0.7
    box.Color3 = hitboxColor
    box.Parent = humanoidRootPart
    hitboxParts[player] = box
    
    local function onCharacterAdded(newCharacter)
        if hitboxParts[player] then
            hitboxParts[player]:Destroy()
            hitboxParts[player] = nil
        end
        
        if ESPEnabled then
            task.wait(1)
            if player.Character then
                createHitbox(player)
            end
        end
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
end

local function removeHitbox(player)
    if hitboxParts[player] then
        hitboxParts[player]:Destroy()
        hitboxParts[player] = nil
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
    if ESPEnabled then
        createHitbox(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
    if ESPEnabled then
        createHitbox(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
    removeHitbox(player)
end)

local humanoid
RunService.Stepped:Connect(function()
    noclipLoop()
    flyLoop()
    
    if triggerBotEnabled then
        triggerBot()
    end
    
    if aimbotEnabled and onePressMode and aimbotActive then
        local target = findClosestPlayer()
        if target then
            aimAt(target)
        end
    end
    
    if LocalPlayer.Character then
        humanoid = humanoid or LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedHackEnabled and (16 * speedMultiplier) or 16
        end
    end
    
    if spinBotEnabled and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Rotatespeed), 0)
        end
    end
    
    if ESPEnabled then
        for player, esp in pairs(espObjects) do
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if hrp and humanoid and humanoid.Health > 0 and shouldShowESP(player) then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
                
                if onScreen and (maxESPDistance == 0 or distance <= maxESPDistance) then
                    local scale = 1 / distance * 100
                    local width, height = 25 * scale, 30 * scale

                    esp.box.Visible = showBoxes
                    esp.box.Color = boxColor
                    esp.box.Size = Vector2.new(width, height)
                    esp.box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)

                    esp.name.Visible = showNames
                    esp.name.Color = nameColor
                    esp.name.Text = player.Name
                    esp.name.Position = Vector2.new(pos.X, pos.Y - height/2 - 15)

                    esp.dist.Visible = showDistance
                    esp.dist.Color = distColor
                    esp.dist.Text = tostring(math.floor(distance)) .. "m"
                    esp.dist.Position = Vector2.new(pos.X, pos.Y + height/2 + 5)

                    if showTracers then
                        esp.tracer.Visible = true
                        esp.tracer.Color = tracerColor
                        esp.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        esp.tracer.To = Vector2.new(pos.X, pos.Y + height/2)
                    else
                        esp.tracer.Visible = false
                    end
                    
                    if not hitboxParts[player] then
                        createHitbox(player)
                    else
                        hitboxParts[player].Visible = true
                        hitboxParts[player].Color3 = hitboxColor
                    end
                else
                    esp.box.Visible = false
                    esp.name.Visible = false
                    esp.dist.Visible = false
                    esp.tracer.Visible = false
                    
                    if hitboxParts[player] then
                        hitboxParts[player].Visible = false
                    end
                end
            else
                esp.box.Visible = false
                esp.name.Visible = false
                esp.dist.Visible = false
                esp.tracer.Visible = false
                
                if hitboxParts[player] then
                    hitboxParts[player].Visible = false
                end
            end
        end
    else
        for _, esp in pairs(espObjects) do
            esp.box.Visible = false
            esp.name.Visible = false
            esp.dist.Visible = false
            esp.tracer.Visible = false
        end
        
        for player in pairs(hitboxParts) do
            if hitboxParts[player] then
                hitboxParts[player].Visible = false
            end
        end
    end
    
    if aimbotEnabled and not onePressMode and UserInputService:IsKeyDown(aimbotKey) then
        local target = findClosestPlayer()
        if target then
            aimAt(target)
        end
    end
    
    updateFovCircle()
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == toggleMenuKey then
        toggleMenu()
    end
    
    if input.KeyCode == Enum.KeyCode.Space and infiniteJumpEnabled then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
    
    if input.KeyCode == aimbotKey and aimbotEnabled then
        if onePressMode then
            aimbotActive = not aimbotActive
        else
            local target = findClosestPlayer()
            if target then
                aimAt(target)
            end
        end
    end
    
    if input.KeyCode == triggerBotKey then
        triggerBotEnabled = not triggerBotEnabled
        triggerBotBtn.Text = "Trigger Bot: " .. (triggerBotEnabled and "ON" or "OFF")
        triggerBotBtn.BackgroundColor3 = triggerBotEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    end
end)
