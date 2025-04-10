local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPEnabled = true
local showBoxes = true
local showNames = true
local showDistance = true
local speedHackEnabled = false
local Rotatespeed = 60
local speedMultiplier = 2
local spinBotEnabled = false
local infiniteJumpEnabled = false
local menuVisible = true

local boxColor = Color3.fromRGB(255, 255, 255)
local nameColor = Color3.fromRGB(255, 255, 255)
local distColor = Color3.fromRGB(0, 255, 255)

local colorPalette = {
    Color3.fromRGB(255,255,255), Color3.fromRGB(255,0,0),
    Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255),
    Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255),
    Color3.fromRGB(0,255,255), Color3.fromRGB(128,128,128),
    Color3.fromRGB(0,0,0),
}

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "UnifiedMenu"
gui.DisplayOrder = 999
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Position = UDim2.new(0, 10, 0.5, -150)
mainFrame.Size = UDim2.new(0, 220, 0, 350)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = menuVisible

local currentTab = "Main"

local mainContent = Instance.new("Frame", mainFrame)
mainContent.Position = UDim2.new(0, 0, 0, 30)
mainContent.Size = UDim2.new(1, 0, 1, -30)
mainContent.BackgroundTransparency = 1

local visualsContent = Instance.new("Frame", mainFrame)
visualsContent.Position = UDim2.new(0, 0, 0, 30)
visualsContent.Size = UDim2.new(1, 0, 1, -30)
visualsContent.BackgroundTransparency = 1
visualsContent.Visible = false

local function createTabButton(name, index)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.5, 0, 0, 30)
    btn.Position = UDim2.new((index-1)*0.5, 0, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = currentTab == name and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    
    btn.MouseButton1Click:Connect(function()
        currentTab = name
        mainContent.Visible = name == "Main"
        visualsContent.Visible = name == "Visuals"
        for _, child in ipairs(mainFrame:GetChildren()) do
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

local speedSlider = createSlider(mainContent, "Speed Multiplier", 0, 1, 10, speedMultiplier, function(value)
    speedMultiplier = value
end)

local speedBtn = createToggleButton(mainContent, "Speed Hack", 55, speedHackEnabled, function(value)
    speedHackEnabled = value
end)

local spinBotBtn = createToggleButton(mainContent, "Spin Bot", 90, spinBotEnabled, function(value)
    spinBotEnabled = value
end)

local infiniteJumpBtn = createToggleButton(mainContent, "Infinite Jump", 125, infiniteJumpEnabled, function(value)
    infiniteJumpEnabled = value
end)

local rotateSlider = createSlider(mainContent, "Spin Speed", 160, 1, 360, Rotatespeed, function(value)
    Rotatespeed = value
end)

createLabel(mainContent, "Teleport to Player:", 215)
local playerNameInput = Instance.new("TextBox", mainContent)
playerNameInput.Size = UDim2.new(1, -10, 0, 25)
playerNameInput.Position = UDim2.new(0, 5, 0, 235)
playerNameInput.PlaceholderText = "Player Name"
playerNameInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerNameInput.TextColor3 = Color3.new(1, 1, 1)
playerNameInput.Font = Enum.Font.SourceSans
playerNameInput.TextSize = 14
playerNameInput.BorderSizePixel = 0

local teleportBtn = Instance.new("TextButton", mainContent)
teleportBtn.Size = UDim2.new(1, -10, 0, 25)
teleportBtn.Position = UDim2.new(0, 5, 0, 265)
teleportBtn.Text = "Teleport"
teleportBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Font = Enum.Font.SourceSans
teleportBtn.TextSize = 14
teleportBtn.BorderSizePixel = 0
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

local closeBtn = Instance.new("TextButton", mainContent)
closeBtn.Size = UDim2.new(1, -10, 0, 25)
closeBtn.Position = UDim2.new(0, 5, 0, 295)
closeBtn.Text = "Close Menu"
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSans
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
closeBtn.MouseButton1Click:Connect(function()
    menuVisible = false
    mainFrame.Visible = false
    paletteFrame.Visible = false
    
    ESPEnabled = false
    speedHackEnabled = false
    spinBotEnabled = false
    infiniteJumpEnabled = false
    
    espBtn.Text = "ESP: OFF"
    espBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    speedBtn.Text = "Speed Hack: OFF"
    speedBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    spinBotBtn.Text = "Spin Bot: OFF"
    spinBotBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    infiniteJumpBtn.Text = "Infinite Jump: OFF"
    infiniteJumpBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    
    for _, player in pairs(espObjects) do
        for _, obj in pairs(player) do
            obj.Visible = false
        end
    end
end)

local espBtn = createToggleButton(visualsContent, "ESP", 0, ESPEnabled, function(value)
    ESPEnabled = value
    if not value then
        for _, player in pairs(espObjects) do
            for _, obj in pairs(player) do
                obj.Visible = false
            end
        end
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

local boxColorPreview = createColorOption(visualsContent, "Box Color", 140, boxColor, function(color)
    boxColor = color
end)

local nameColorPreview = createColorOption(visualsContent, "Name Color", 175, nameColor, function(color)
    nameColor = color
end)

local distColorPreview = createColorOption(visualsContent, "Distance Color", 210, distColor, function(color)
    distColor = color
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        menuVisible = not menuVisible
        mainFrame.Visible = menuVisible
        paletteFrame.Visible = false
    end
    
    if input.KeyCode == Enum.KeyCode.Space and infiniteJumpEnabled then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local espObjects = {}

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

    espObjects[player] = {box = box, name = nameText, dist = distText}
end

local function removeESP(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            obj:Remove()
        end
        espObjects[player] = nil
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

local humanoid
RunService.RenderStepped:Connect(function()
    if speedHackEnabled and LocalPlayer.Character then
        humanoid = humanoid or LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 * speedMultiplier
        end
    elseif humanoid then
        humanoid.WalkSpeed = 16
    end
    
    if spinBotEnabled and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Rotatespeed), 0)
        end
    end
    
    if menuVisible and ESPEnabled then
        for player, esp in pairs(espObjects) do
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if hrp and humanoid and humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
                    local scale = 1 / distance * 100
                    local width, height = 35 * scale, 60 * scale

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
                else
                    esp.box.Visible = false
                    esp.name.Visible = false
                    esp.dist.Visible = false
                end
            else
                esp.box.Visible = false
                esp.name.Visible = false
                esp.dist.Visible = false
            end
        end
    end
end)