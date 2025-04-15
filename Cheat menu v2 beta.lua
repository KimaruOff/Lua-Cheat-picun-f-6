local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local Window = Fluent:CreateWindow({
    Title = "Picun f-6",
    SubTitle = "By Kimaru",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftShift
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home"}),
    Bots = Window:AddTab({ Title = "Bots", Icon = "crosshair"}),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye"}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings"})
}

local ESP = {
    Enabled = false,
    Box = true,
    Name = true,
    HealthBar = true,
    Distance = true,
    Tracers = true,
    BoxColor = Color3.fromRGB(255, 255, 255),
    NameColor = Color3.fromRGB(0, 255, 0),
    TracerColor = Color3.fromRGB(255, 255, 0),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TeamCheck = false,
    WhitelistEnabled = false,
    WhitelistedPlayers = {}
}

local Bots = {
    SpinBot = false,
    InfiniteJump = false,
    NoClip = false,
    Fly = false,
    FlySpeed = 50
}

local ESPObjects = {}
local currentHumanoid
local defaultSpeed = 16
local speedHackEnabled = false
local speedHackValue = defaultSpeed
local noclipLoop
local spinBotLoop
local flyLoop
local flyKeys = {
    Forward = Enum.KeyCode.W,
    Backward = Enum.KeyCode.S,
    Left = Enum.KeyCode.A,
    Right = Enum.KeyCode.D,
    Up = Enum.KeyCode.Space,
    Down = Enum.KeyCode.LeftShift
}

function CreateESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 3
    box.Transparency = 1
    box.Filled = false
    box.Color = ESP.BoxColor
    box.Visible = false

    local name = Drawing.new("Text")
    name.Size = ESP.TextSize * 2
    name.Center = true
    name.Outline = true
    name.Color = ESP.NameColor
    name.Visible = false

    local healthBarOutline = Drawing.new("Square")
    healthBarOutline.Thickness = 2
    healthBarOutline.Filled = false
    healthBarOutline.Color = Color3.fromRGB(0, 0, 0)
    healthBarOutline.Visible = false

    local healthBar = Drawing.new("Square")
    healthBar.Thickness = 1
    healthBar.Filled = true
    healthBar.Visible = false

    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = ESP.TracerColor
    line.Visible = false

    local distanceText = Drawing.new("Text")
    distanceText.Size = ESP.TextSize * 2
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.Color = ESP.DistanceColor
    distanceText.Visible = false

    ESPObjects[player] = {
        Box = box,
        Name = name,
        HealthBarOutline = healthBarOutline,
        HealthBar = healthBar,
        Line = line,
        Distance = distanceText
    }
end

function RemoveESP(player)
    if ESPObjects[player] then
        for _, drawing in pairs(ESPObjects[player]) do
            drawing:Remove()
        end
        ESPObjects[player] = nil
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

local function updateSpeed()
    if currentHumanoid then
        currentHumanoid.WalkSpeed = speedHackEnabled and speedHackValue or defaultSpeed
    end
end

local function setupCharacter(character)
    if currentHumanoid then
        currentHumanoid:Destroy()
    end
    
    currentHumanoid = character:WaitForChild("Humanoid")
    defaultSpeed = currentHumanoid.WalkSpeed
    updateSpeed()
end

local function startNoClip()
    if noclipLoop then noclipLoop:Disconnect() end
    
    noclipLoop = RunService.Stepped:Connect(function()
        if Bots.NoClip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function startFly()
    if flyLoop then flyLoop:Disconnect() end
    
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 10000
    bodyGyro.D = 1000
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = root
    
    flyLoop = RunService.Heartbeat:Connect(function()
        if not Bots.Fly or not LocalPlayer.Character or not root then
            bodyGyro:Destroy()
            bodyVelocity:Destroy()
            flyLoop:Disconnect()
            return
        end
        
        local direction = Vector3.new(
            (UserInputService:IsKeyDown(flyKeys.Right) and 1 or 0) - (UserInputService:IsKeyDown(flyKeys.Left) and 1 or 0),
            (UserInputService:IsKeyDown(flyKeys.Up) and 1 or 0) - (UserInputService:IsKeyDown(flyKeys.Down) and 1 or 0),
            (UserInputService:IsKeyDown(flyKeys.Backward) and 1 or 0) - (UserInputService:IsKeyDown(flyKeys.Forward) and 1 or 0)
        )
        
        if direction.Magnitude > 0 then
            direction = (Camera.CFrame:VectorToWorldSpace(direction)).Unit
            bodyVelocity.Velocity = direction * Bots.FlySpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        bodyGyro.CFrame = Camera.CFrame
    end)
end

local function stopFly()
    if flyLoop then
        flyLoop:Disconnect()
        flyLoop = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            for _, obj in pairs(rootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                    obj:Destroy()
                end
            end
        end
    end
end

local function startSpinBot()
    if spinBotLoop then spinBotLoop:Disconnect() end
    
    spinBotLoop = RunService.RenderStepped:Connect(function()
        if Bots.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(30), 0)
        end
    end)
end

local function setupInfiniteJump()
    UserInputService.JumpRequest:Connect(function()
        if Bots.InfiniteJump and currentHumanoid then
            currentHumanoid:ChangeState("Jumping")
        end
    end)
end

setupCharacter(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
LocalPlayer.CharacterAdded:Connect(setupCharacter)
setupInfiniteJump()

local espLoop = RunService.RenderStepped:Connect(function()
    if not ESP.Enabled then return end
    
    local localChar = LocalPlayer.Character
    if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = localChar.HumanoidRootPart.Position

    for player, drawings in pairs(ESPObjects) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character:FindFirstChild("Head") then
            if ESP.TeamCheck and player.Team == LocalPlayer.Team then
                drawings.Box.Visible = false
                drawings.Name.Visible = false
                drawings.HealthBarOutline.Visible = false
                drawings.HealthBar.Visible = false
                drawings.Line.Visible = false
                drawings.Distance.Visible = false
                continue
            end
            
            if ESP.WhitelistEnabled and not ESP.WhitelistedPlayers[player.Name] then
                drawings.Box.Visible = false
                drawings.Name.Visible = false
                drawings.HealthBarOutline.Visible = false
                drawings.HealthBar.Visible = false
                drawings.Line.Visible = false
                drawings.Distance.Visible = false
                continue
            end
            
            local hrp = character.HumanoidRootPart
            local head = character.Head
            local humanoid = character.Humanoid

            local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.6, 0))
            local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
            local screenPos = Camera:WorldToViewportPoint(hrp.Position)
            local visible = top.Z > 0 and bottom.Z > 0

            if visible then
                local distance = (myPos - hrp.Position).Magnitude
                local baseHeight = math.abs(top.Y - bottom.Y)
                local scaleFactor = math.clamp(1 / (distance / 20), 0.3, 1.5)
                
                local height = baseHeight * 1.2
                local width = height / 2

                if ESP.Box then
                    drawings.Box.Size = Vector2.new(width, height)
                    drawings.Box.Position = Vector2.new(top.X - width / 2, top.Y)
                    drawings.Box.Color = ESP.BoxColor
                    drawings.Box.Visible = true
                else
                    drawings.Box.Visible = false
                end

                if ESP.Name then
                    drawings.Name.Text = player.Name
                    drawings.Name.Size = ESP.TextSize * 1.5
                    drawings.Name.Position = Vector2.new(top.X, top.Y - 18)
                    drawings.Name.Color = ESP.NameColor
                    drawings.Name.Visible = true
                else
                    drawings.Name.Visible = false
                end

                if ESP.HealthBar then
                    local healthPerc = humanoid.Health / humanoid.MaxHealth
                    local healthColor

                    if healthPerc > 0.75 then
                        healthColor = Color3.fromRGB(0, 255, 0)
                    elseif healthPerc > 0.5 then
                        healthColor = Color3.fromRGB(255, 255, 0)
                    elseif healthPerc > 0.25 then
                        healthColor = Color3.fromRGB(255, 165, 0)
                    else
                        healthColor = Color3.fromRGB(255, 0, 0)
                    end

                    drawings.HealthBarOutline.Size = Vector2.new(4, height)
                    drawings.HealthBarOutline.Position = Vector2.new(top.X - width / 2 - 6, top.Y)
                    drawings.HealthBarOutline.Visible = true
                    
                    drawings.HealthBar.Size = Vector2.new(4, height * healthPerc)
                    drawings.HealthBar.Position = Vector2.new(top.X - width / 2 - 6, top.Y + (height * (1 - healthPerc)))
                    drawings.HealthBar.Color = healthColor
                    drawings.HealthBar.Visible = true
                else
                    drawings.HealthBarOutline.Visible = false
                    drawings.HealthBar.Visible = false
                end

                if ESP.Tracers then
                    drawings.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    drawings.Line.To = Vector2.new(screenPos.X, screenPos.Y)
                    drawings.Line.Color = ESP.TracerColor
                    drawings.Line.Visible = true
                else
                    drawings.Line.Visible = false
                end

                if ESP.Distance then
                    drawings.Distance.Text = string.format("%.1f M", distance)
                    drawings.Distance.Size = ESP.TextSize * 1.5
                    drawings.Distance.Position = Vector2.new(top.X, top.Y + height + 5)
                    drawings.Distance.Color = ESP.DistanceColor
                    drawings.Distance.Visible = true
                else
                    drawings.Distance.Visible = false
                end
            else
                drawings.Box.Visible = false
                drawings.Name.Visible = false
                drawings.HealthBarOutline.Visible = false
                drawings.HealthBar.Visible = false
                drawings.Line.Visible = false
                drawings.Distance.Visible = false
            end
        else
            drawings.Box.Visible = false
            drawings.Name.Visible = false
            drawings.HealthBarOutline.Visible = false
            drawings.HealthBar.Visible = false
            drawings.Line.Visible = false
            drawings.Distance.Visible = false
        end
    end
end)

Tabs.Main:AddToggle("SpeedHackToggle", {
    Title = "Enable Speed Hack",
    Default = speedHackEnabled,
    Callback = function(value)
        speedHackEnabled = value
        updateSpeed()
    end
})

Tabs.Main:AddSlider("SpeedHackValue", {
    Title = "Speed Value",
    Default = speedHackValue,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        speedHackValue = value
        updateSpeed()
    end
})

Tabs.Main:AddToggle("InfiniteJumpToggle", {
    Title = "Infinite Jump",
    Default = Bots.InfiniteJump,
    Callback = function(value)
        Bots.InfiniteJump = value
    end
})

Tabs.Main:AddToggle("NoClipToggle", {
    Title = "No Clip",
    Default = Bots.NoClip,
    Callback = function(value)
        Bots.NoClip = value
        if value then
            startNoClip()
        elseif noclipLoop then
            noclipLoop:Disconnect()
            noclipLoop = nil
        end
    end
})

Tabs.Main:AddToggle("FlyToggle", {
    Title = "Fly",
    Default = Bots.Fly,
    Callback = function(value)
        Bots.Fly = value
        if value then
            startFly()
        else
            stopFly()
        end
    end
})

Tabs.Main:AddSlider("FlySpeedSlider", {
    Title = "Fly Speed",
    Default = Bots.FlySpeed,
    Min = 1,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        Bots.FlySpeed = value
    end
})

Tabs.Bots:AddToggle("SpinBotToggle", {
    Title = "Spin Bot",
    Default = Bots.SpinBot,
    Callback = function(value)
        Bots.SpinBot = value
        if value then
            startSpinBot()
        elseif spinBotLoop then
            spinBotLoop:Disconnect()
            spinBotLoop = nil
        end
    end
})

local playerList = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerList, player.Name)
    end
end

Tabs.Visuals:AddDropdown("ESPWhitelist", {
    Title = "Whitelist Players",
    Values = playerList,
    Multi = true,
    Default = {},
    Callback = function(selected)
        ESP.WhitelistedPlayers = {}
        for playerName, _ in pairs(selected) do
            ESP.WhitelistedPlayers[playerName] = true
        end
    end
})

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        table.insert(playerList, player.Name)
        Tabs.Visuals.ESPWhitelist:SetValues(playerList)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    for i, name in pairs(playerList) do
        if name == player.Name then
            table.remove(playerList, i)
            break
        end
    end
    ESP.WhitelistedPlayers[player.Name] = nil
    Tabs.Visuals.ESPWhitelist:SetValues(playerList)
end)

Tabs.Visuals:AddToggle("ESPEnabled", {
    Title = "Enable ESP",
    Default = ESP.Enabled,
    Callback = function(value)
        ESP.Enabled = value
    end
})

Tabs.Visuals:AddToggle("ESPBox", {
    Title = "Box ESP",
    Default = ESP.Box,
    Callback = function(value)
        ESP.Box = value
    end
})

Tabs.Visuals:AddToggle("ESPName", {
    Title = "Name ESP",
    Default = ESP.Name,
    Callback = function(value)
        ESP.Name = value
    end
})

Tabs.Visuals:AddToggle("ESPHealth", {
    Title = "Health Bar",
    Default = ESP.HealthBar,
    Callback = function(value)
        ESP.HealthBar = value
    end
})

Tabs.Visuals:AddToggle("ESPTracers", {
    Title = "Tracers",
    Default = ESP.Tracers,
    Callback = function(value)
        ESP.Tracers = value
    end
})

Tabs.Visuals:AddToggle("ESPDistance", {
    Title = "Distance",
    Default = ESP.Distance,
    Callback = function(value)
        ESP.Distance = value
    end
})

Tabs.Visuals:AddToggle("ESPTeamCheck", {
    Title = "Team Check",
    Default = ESP.TeamCheck,
    Callback = function(value)
        ESP.TeamCheck = value
    end
})

Tabs.Visuals:AddToggle("ESPWhitelistEnabled", {
    Title = "Whitelist Mode",
    Default = ESP.WhitelistEnabled,
    Callback = function(value)
        ESP.WhitelistEnabled = value
    end
})

Tabs.Visuals:AddSlider("ESPTextSize", {
    Title = "Text Size",
    Default = ESP.TextSize,
    Min = 8,
    Max = 24,
    Rounding = 1,
    Callback = function(value)
        ESP.TextSize = value
    end
})

Tabs.Visuals:AddColorpicker("ESPBoxColor", {
    Title = "Box Color",
    Default = ESP.BoxColor,
    Callback = function(value)
        ESP.BoxColor = value
    end
})

Tabs.Visuals:AddColorpicker("ESPNameColor", {
    Title = "Name Color",
    Default = ESP.NameColor,
    Callback = function(value)
        ESP.NameColor = value
    end
})

Tabs.Visuals:AddColorpicker("ESPTracerColor", {
    Title = "Tracer Color",
    Default = ESP.TracerColor,
    Callback = function(value)
        ESP.TracerColor = value
    end
})

Tabs.Visuals:AddColorpicker("ESPDistanceColor", {
    Title = "Distance Color",
    Default = ESP.DistanceColor,
    Callback = function(value)
        ESP.DistanceColor = value
    end
})

local availableThemes = {
    "Dark",
    "Light",
    "Darker",
    "Aqua",
    "Amethyst"
}

Tabs.Settings:AddDropdown("ThemeDropdown", {
    Title = "UI Theme",
    Values = availableThemes,
    Default = "Dark",
    Multi = false,
    Callback = function(value)
        Fluent:SetTheme(value)
    end
})

local uiKeybind = Tabs.Settings:AddKeybind("UIToggleKeybind", {
    Title = "Toggle UI Keybind",
    Mode = "Toggle",
    Default = "LeftShift",
    Callback = function(value)
        print("key rebinded:", value) 
    end,
    ChangedCallback = function(newKey)
        Window.MinimizeKey = newKey
        Fluent.MinimizeKey = newKey
    end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:LoadAutoloadConfig()

Window:SelectTab(1)

local function resetAllFeatures()
    speedHackEnabled = false
    Bots.NoClip = false
    Bots.Fly = false
    Bots.SpinBot = false
    Bots.InfiniteJump = false
    ESP.Enabled = false
    
    if currentHumanoid then
        currentHumanoid.WalkSpeed = defaultSpeed
    end
    
    if noclipLoop then 
        noclipLoop:Disconnect() 
        noclipLoop = nil
    end
    
    stopFly()
    
    if spinBotLoop then 
        spinBotLoop:Disconnect() 
        spinBotLoop = nil
    end
    
    for player, drawings in pairs(ESPObjects) do
        RemoveESP(player)
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    if Fluent.Unloaded then
        resetAllFeatures()
        if espLoop then
            espLoop:Disconnect()
        end
    end
end)
