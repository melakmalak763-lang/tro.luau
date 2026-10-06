-- ============================================================
-- TRO HUB - Full Version with Toggle Switch & Sliding Line
-- Owner: سـجّـاد
-- ============================================================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")
local Run = game:GetService("RunService")
local SG = game:GetService("StarterGui")
local player = Players.LocalPlayer

if CG:FindFirstChild("DEDSEC_PythonPureGUI") then CG.DEDSEC_PythonPureGUI:Destroy() end
if CG:FindFirstChild("DEDSEC_PythonToggle") then CG.DEDSEC_PythonToggle:Destroy() end

local dataService = RS:FindFirstChild("RemoteEvents")
if dataService then dataService = dataService:FindFirstChild("DataService") end
local cmdRemote = RS:FindFirstChild("HDAdminHDClient")
if cmdRemote then
    cmdRemote = cmdRemote:FindFirstChild("Signals")
    if cmdRemote then cmdRemote = cmdRemote:FindFirstChild("RequestCommandModification") end
end

local function sendText(t)
    if dataService then pcall(function() dataService:FireServer(t) end) end
    if cmdRemote then
        pcall(function()
            if cmdRemote:IsA("RemoteEvent") then cmdRemote:FireServer(t)
            elseif cmdRemote:IsA("RemoteFunction") then cmdRemote:InvokeServer(t) end
        end)
    end
end

local function getHRP()
    local c = player.Character
    if c then return c:FindFirstChild("HumanoidRootPart") end
    return nil
end

local function clearBodyMovers(hrp)
    if not hrp then return end
    for _, v in ipairs(hrp:GetChildren()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyForce")
            or v:IsA("BodyThrust") or v:IsA("BodyGyro") or v:IsA("VectorForce")
            or v:IsA("Torque") or v:IsA("AngularVelocity") or v:IsA("LinearVelocity")
            or v:IsA("AlignPosition") or v:IsA("AlignOrientation") then
            pcall(function() v:Destroy() end)
        end
    end
end

local function sendNotify(t, x)
    pcall(function()
        SG:SetCore("SendNotification", {Title = t, Text = x, Duration = 5})
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- 🚫 ANTI-EMOTE
-- ═══════════════════════════════════════════════════════════════════
local function CreateAntiEmote(parentFrame)
    local state = { active = false, blocked = 0, recent = {}, conns = {}, hum = nil, allowed = {} }

    local box = Instance.new("Frame", parentFrame)
    box.Size = UDim2.new(0.92, 0, 0, 305)
    box.Position = UDim2.new(0.04, 0, 0, 565)
    box.BackgroundColor3 = Color3.fromRGB(4, 14, 8)
    box.BorderSizePixel = 0
    box.ZIndex = 4
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local bs = Instance.new("UIStroke", box)
    bs.Color = Color3.fromRGB(0, 255, 120)
    bs.Thickness = 1.2

    local scan = Instance.new("Frame", box)
    scan.Size = UDim2.new(1, 0, 0, 2)
    scan.Position = UDim2.new(0, 0, 0, 0)
    scan.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    scan.BackgroundTransparency = 0.6
    scan.BorderSizePixel = 0
    scan.ZIndex = 5
    task.spawn(function()
        while box.Parent do
            scan.Position = UDim2.new(0, 0, 0, 0)
            local tw = TS:Create(scan, TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 1, -2)})
            tw:Play()
            tw.Completed:Wait()
            task.wait(0.3)
        end
    end)

    local title = Instance.new("TextLabel", box)
    title.Size = UDim2.new(1, -80, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "🚫 ANTI-EMOTE"
    title.TextColor3 = Color3.fromRGB(0, 255, 120)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 6

    local subtitle = Instance.new("TextLabel", box)
    subtitle.Size = UDim2.new(1, -80, 0, 12)
    subtitle.Position = UDim2.new(0, 10, 0, 24)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Natural Movement Protection"
    subtitle.TextColor3 = Color3.fromRGB(100, 200, 140)
    subtitle.Font = Enum.Font.Code
    subtitle.TextSize = 8
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 6

    local statusDot = Instance.new("Frame", box)
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Position = UDim2.new(1, -70, 0, 12)
    statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 6
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        while statusDot.Parent do
            TS:Create(statusDot, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.7}):Play()
            task.wait(0.7)
            if not statusDot.Parent then break end
            TS:Create(statusDot, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play()
            task.wait(0.7)
        end
    end)

    local statusTxt = Instance.new("TextLabel", box)
    statusTxt.Size = UDim2.new(0, 60, 0, 14)
    statusTxt.Position = UDim2.new(1, -60, 0, 9)
    statusTxt.BackgroundTransparency = 1
    statusTxt.Text = "IDLE"
    statusTxt.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusTxt.Font = Enum.Font.Code
    statusTxt.TextSize = 10
    statusTxt.TextXAlignment = Enum.TextXAlignment.Left
    statusTxt.ZIndex = 6

    local counter = Instance.new("TextLabel", box)
    counter.Size = UDim2.new(1, -20, 0, 24)
    counter.Position = UDim2.new(0, 10, 0, 42)
    counter.BackgroundTransparency = 1
    counter.Text = "BLOCKED: 0"
    counter.TextColor3 = Color3.fromRGB(255, 100, 100)
    counter.Font = Enum.Font.GothamBlack
    counter.TextSize = 14
    counter.TextXAlignment = Enum.TextXAlignment.Left
    counter.ZIndex = 6

    local logBox = Instance.new("ScrollingFrame", box)
    logBox.Size = UDim2.new(1, -20, 0, 120)
    logBox.Position = UDim2.new(0, 10, 0, 72)
    logBox.BackgroundColor3 = Color3.fromRGB(2, 7, 4)
    logBox.BackgroundTransparency = 0.3
    logBox.BorderSizePixel = 0
    logBox.ScrollBarThickness = 2
    logBox.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 100)
    logBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    logBox.ZIndex = 5
    Instance.new("UICorner", logBox).CornerRadius = UDim.new(0, 6)
    Instance.new("UIListLayout", logBox).Padding = UDim.new(0, 2)

    local emptyLbl = Instance.new("TextLabel", logBox)
    emptyLbl.Size = UDim2.new(1, 0, 0, 120)
    emptyLbl.BackgroundTransparency = 1
    emptyLbl.Text = "— لا يوجد سجل بعد —"
    emptyLbl.TextColor3 = Color3.fromRGB(60, 100, 75)
    emptyLbl.Font = Enum.Font.Gotham
    emptyLbl.TextSize = 9
    emptyLbl.ZIndex = 6

    local toggleBtn = Instance.new("TextButton", box)
    toggleBtn.Size = UDim2.new(1, -20, 0, 36)
    toggleBtn.Position = UDim2.new(0, 10, 1, -44)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 15, 15)
    toggleBtn.Text = "▶️ تشغيل الحماية"
    toggleBtn.TextColor3 = Color3.fromRGB(220, 255, 220)
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.TextSize = 13
    toggleBtn.AutoButtonColor = false
    toggleBtn.ZIndex = 6
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)
    local tbStroke = Instance.new("UIStroke", toggleBtn)
    tbStroke.Color = Color3.fromRGB(255, 100, 100)
    tbStroke.Thickness = 1.5

    local function log(reason)
        state.blocked = state.blocked + 1
        counter.Text = "BLOCKED: " .. state.blocked
        TS:Create(counter, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 200)}):Play()
        task.delay(0.15, function()
            if counter.Parent then TS:Create(counter, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play() end
        end)
        table.insert(state.recent, 1, reason)
        while #state.recent > 15 do table.remove(state.recent) end
        for _, c in ipairs(logBox:GetChildren()) do
            if c:IsA("TextLabel") and c ~= emptyLbl then c:Destroy() end
        end
        emptyLbl.Visible = (#state.recent == 0)
        for i, r in ipairs(state.recent) do
            local l = Instance.new("TextLabel", logBox)
            l.Size = UDim2.new(1, -4, 0, 18)
            l.BackgroundColor3 = Color3.fromRGB(20, 8, 8)
            l.BackgroundTransparency = 0.5
            l.BorderSizePixel = 0
            l.LayoutOrder = i
            l.Text = "  🚫 " .. r .. "  (" .. os.date("%H:%M:%S") .. ")"
            l.TextColor3 = Color3.fromRGB(255, 120, 120)
            l.Font = Enum.Font.Code
            l.TextSize = 9
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.TextTruncate = Enum.TextTruncate.AtEnd
            l.ZIndex = 6
            Instance.new("UICorner", l).CornerRadius = UDim.new(0, 4)
        end
        logBox.CanvasSize = UDim2.new(0, 0, 0, #state.recent * 20)
    end

    local WL = {
        ["rbxassetid://507766666"]=1, ["rbxassetid://507766951"]=1, ["rbxassetid://507766388"]=1,
        ["rbxassetid://507777826"]=1, ["rbxassetid://507767714"]=1, ["rbxassetid://507765000"]=1,
        ["rbxassetid://507767968"]=1, ["rbxassetid://507765644"]=1, ["rbxassetid://507784897"]=1,
        ["rbxassetid://507785072"]=1, ["rbxassetid://507768133"]=1, ["rbxassetid://507768375"]=1,
        ["rbxassetid://507770239"]=1, ["rbxassetid://507770453"]=1, ["rbxassetid://507771019"]=1,
        ["rbxassetid://507771931"]=1,
        ["rbxassetid://180435571"]=1, ["rbxassetid://180435792"]=1, ["rbxassetid://180426354"]=1,
        ["rbxassetid://125750702"]=1, ["rbxassetid://180436148"]=1, ["rbxassetid://180436334"]=1,
    }

    local function setup(char)
        for _, c in ipairs(state.conns) do pcall(function() c:Disconnect() end) end
        state.conns = {}

        local hum = char:WaitForChild("Humanoid", 10)
        if not hum then return end
        state.hum = hum

        table.insert(state.conns, hum:GetPropertyChangedSignal("Sit"):Connect(function()
            if state.active and hum.Sit then hum.Sit = false; log("Sit blocked") end
        end))
        table.insert(state.conns, hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
            if state.active and hum.PlatformStand then hum.PlatformStand = false; log("PlatformStand blocked") end
        end))
        table.insert(state.conns, hum.StateChanged:Connect(function(_, ns)
            if not state.active then return end
            if ns == Enum.HumanoidStateType.Sitting then
                hum.Sit = false
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            elseif ns == Enum.HumanoidStateType.PlatformStanding then
                hum.PlatformStand = false
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            elseif ns == Enum.HumanoidStateType.Ragdoll or ns == Enum.HumanoidStateType.Physics then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
        end))

        local animator = hum:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = hum
        end

        for _, t in pairs(animator:GetPlayingAnimationTracks()) do
            local a = t.Animation
            if a and a.AnimationId and a.AnimationId ~= "" then state.allowed[a.AnimationId] = true end
        end

        table.insert(state.conns, animator.AnimationPlayed:Connect(function(track)
            if not state.active then return end
            local a = track.Animation
            if not a then return end
            local id = a.AnimationId
            if not id or id == "" then return end
            if WL[id] or state.allowed[id] then return end
            pcall(function()
                track:AdjustSpeed(0)
                track:AdjustWeight(0, 0)
                track:Stop(0)
            end)
            task.defer(function() pcall(function() track:Destroy() end) end)
            log("Anim blocked")
        end))

        table.insert(state.conns, Run.Heartbeat:Connect(function()
            if not state.active or not hum.Parent then return end
            if hum.Sit then hum.Sit = false end
            if hum.PlatformStand then hum.PlatformStand = false end
        end))

        print("[Anti-Emote] Ready for " .. char.Name)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        state.active = not state.active
        if state.active then
            toggleBtn.Text = "⏹️ إيقاف الحماية"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
            tbStroke.Color = Color3.fromRGB(0, 255, 100)
            statusTxt.Text = "ACTIVE"
            statusTxt.TextColor3 = Color3.fromRGB(0, 255, 100)
            statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            sendNotify("Anti-Emote", "✅ الحماية مفعلة")
            if player.Character then task.spawn(function() setup(player.Character) end) end
        else
            toggleBtn.Text = "▶️ تشغيل الحماية"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 15, 15)
            tbStroke.Color = Color3.fromRGB(255, 100, 100)
            statusTxt.Text = "IDLE"
            statusTxt.TextColor3 = Color3.fromRGB(255, 100, 100)
            statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            sendNotify("Anti-Emote", "⛔ الحماية معطلة")
            for _, c in ipairs(state.conns) do pcall(function() c:Disconnect() end) end
            state.conns = {}
        end
    end)

    player.CharacterAdded:Connect(function(char)
        if state.active then task.spawn(function() setup(char) end) end
    end)

    return state
end

-- ═══════════════════════════════════════════════════════════════════
-- MAIN BUILD
-- ═══════════════════════════════════════════════════════════════════
local function BUILD_ALL()
    -- ═══ Toggle Button GUI مع الخط ═══
    local tgGui = Instance.new("ScreenGui")
    tgGui.Name = "DEDSEC_PythonToggle"
    tgGui.ResetOnSpawn = false
    tgGui.Parent = CG

    local tgBtn = Instance.new("TextButton", tgGui)
    tgBtn.Size = UDim2.new(0, 55, 0, 55)
    tgBtn.Position = UDim2.new(1, -70, 0.5, -27)
    tgBtn.BackgroundColor3 = Color3.fromRGB(10, 20, 12)
    tgBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
    tgBtn.Text = "TRO"
    tgBtn.TextSize = 13
    tgBtn.Font = Enum.Font.GothamBold
    tgBtn.AutoButtonColor = false
    tgBtn.ZIndex = 60
    Instance.new("UICorner", tgBtn).CornerRadius = UDim.new(0, 12)
    local tgS = Instance.new("UIStroke", tgBtn)
    tgS.Thickness = 2
    tgS.Color = Color3.fromRGB(0, 255, 120)

    local tgGlow = Instance.new("Frame", tgBtn)
    tgGlow.Size = UDim2.new(1, -8, 1, -8)
    tgGlow.Position = UDim2.new(0, 4, 0, 4)
    tgGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    tgGlow.BackgroundTransparency = 0.85
    tgGlow.BorderSizePixel = 0
    tgGlow.ZIndex = 0
    Instance.new("UICorner", tgGlow).CornerRadius = UDim.new(0, 10)

    local tgLine = Instance.new("Frame", tgGui)
    tgLine.Size = UDim2.new(0, 0, 0, 3)
    tgLine.Position = UDim2.new(1, -16, 0.5, -1.5)
    tgLine.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    tgLine.BorderSizePixel = 0
    tgLine.AnchorPoint = Vector2.new(1, 0.5)
    tgLine.ZIndex = 45
    tgLine.Visible = false
    local tgLineGlow = Instance.new("UIStroke", tgLine)
    tgLineGlow.Color = Color3.fromRGB(0, 255, 120)
    tgLineGlow.Thickness = 1
    tgLineGlow.Transparency = 0.5

    local tgDot = Instance.new("Frame", tgGui)
    tgDot.Size = UDim2.new(0, 12, 0, 12)
    tgDot.Position = UDim2.new(1, -38, 0.5, -6)
    tgDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    tgDot.BorderSizePixel = 0
    tgDot.ZIndex = 65
    Instance.new("UICorner", tgDot).CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        while tgDot.Parent do
            TS:Create(tgDot, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.6}):Play()
            task.wait(0.8)
            if not tgDot.Parent then break end
            TS:Create(tgDot, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play()
            task.wait(0.8)
        end
    end)

    -- ═══ Main GUI ═══
    local gui = Instance.new("ScreenGui")
    gui.Name = "DEDSEC_PythonPureGUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = CG

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 840, 0, 530)
    main.Position = UDim2.new(0.5, -420, 0.5, -265)
    main.BackgroundColor3 = Color3.fromRGB(6, 12, 8)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.Active = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

    local bgImg = Instance.new("ImageLabel", main)
    bgImg.Size = UDim2.new(1, 0, 1, 0)
    bgImg.BackgroundTransparency = 1
    bgImg.Image = "rbxassetid://131961371008778"
    bgImg.ScaleType = Enum.ScaleType.Stretch
    bgImg.ZIndex = 0
    Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 10)

    local matrixBox = Instance.new("Frame", main)
    matrixBox.Size = UDim2.new(1, 0, 1, 0)
    matrixBox.BackgroundTransparency = 1
    matrixBox.ClipsDescendants = true
    matrixBox.ZIndex = 1

    local phrases = {"import tro_attack as ta", "initiate_core_sequence()", "loading remote_events...", "bypass_security_level = 99", "executing python_payload...", "connection established...", "root@tro-core:~$ attack_ready", "spawning threads: [OK]", "cve_exploit_module loaded"}

    task.spawn(function()
        while gui.Parent do
            if not main.Visible then task.wait(1) else
                local lbl = Instance.new("TextLabel", matrixBox)
                lbl.Size = UDim2.new(0, 300, 0, 20)
                lbl.Position = UDim2.new(math.random(5, 75) / 100, 0, 1.1, 0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.fromRGB(0, 255, 120)
                lbl.TextTransparency = 0.4
                lbl.TextSize = 10
                lbl.Font = Enum.Font.Code
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Text = phrases[math.random(1, #phrases)]
                lbl.ZIndex = 1
                local tw = TS:Create(lbl, TweenInfo.new(3.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(lbl.Position.X.Scale, 0, -0.1, 0), TextTransparency = 1})
                tw:Play()
                tw.Completed:Connect(function() lbl:Destroy() end)
                task.wait(0.25)
            end
        end
    end)

    local shadow = Instance.new("UIStroke", main)
    shadow.Thickness = 2
    shadow.Color = Color3.fromRGB(0, 255, 120)
    shadow.Transparency = 0.3

    task.spawn(function()
        while gui.Parent do
            TS:Create(shadow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.7}):Play()
            TS:Create(tgS, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.7}):Play()
            task.wait(1.2)
            if not gui.Parent then break end
            TS:Create(shadow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
            TS:Create(tgS, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
            task.wait(1.2)
        end
    end)

    local tBar = Instance.new("Frame", main)
    tBar.Size = UDim2.new(1, 0, 0, 42)
    tBar.BackgroundColor3 = Color3.fromRGB(10, 20, 12)
    tBar.BackgroundTransparency = 0.85
    tBar.BorderSizePixel = 0
    tBar.ZIndex = 5
    Instance.new("UICorner", tBar).CornerRadius = UDim.new(0, 10)

    local tText = Instance.new("TextLabel", tBar)
    tText.Size = UDim2.new(0.85, 0, 1, 0)
    tText.Position = UDim2.new(0.02, 0, 0, 0)
    tText.BackgroundTransparency = 1
    tText.TextColor3 = Color3.fromRGB(0, 255, 120)
    tText.Text = "root@TRO-core:~/sajjad_attack/main.py --user=سـجّـاد"
    tText.TextSize = 12
    tText.Font = Enum.Font.Code
    tText.TextXAlignment = Enum.TextXAlignment.Left
    tText.ZIndex = 6

    local closeBtn = Instance.new("TextButton", tBar)
    closeBtn.Size = UDim2.new(0, 40, 0, 30)
    closeBtn.Position = UDim2.new(1, -45, 0, 6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Text = "X"
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.Code
    closeBtn.ZIndex = 20
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    local isVisible = true
    local function toggleWin()
        isVisible = not isVisible
        if isVisible then
            tgLine.Visible = true
            TS:Create(tgLine, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 90, 0, 3)
            }):Play()
            main.Visible = true
            main.Position = UDim2.new(1, 80, 0.5, -265)
            task.wait(0.05)
            TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -420, 0.5, -265)
            }):Play()
            TS:Create(tgBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = 180
            }):Play()
        else
            local tw = TS:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 80, 0.5, -265)
            })
            tw:Play()
            tw.Completed:Connect(function()
                if not isVisible then main.Visible = false end
            end)
            local lw = TS:Create(tgLine, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 3)
            })
            lw:Play()
            lw.Completed:Connect(function()
                if not isVisible then tgLine.Visible = false end
            end)
            TS:Create(tgBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = 0
            }):Play()
        end
    end
    closeBtn.MouseButton1Click:Connect(toggleWin)
    tgBtn.MouseButton1Click:Connect(toggleWin)

    local side = Instance.new("ScrollingFrame", main)
    side.Size = UDim2.new(0.28, 0, 1, -55)
    side.Position = UDim2.new(0.01, 0, 0, 48)
    side.BackgroundColor3 = Color3.fromRGB(8, 15, 10)
    side.BackgroundTransparency = 0.85
    side.BorderSizePixel = 0
    side.CanvasSize = UDim2.new(0, 0, 0, 750)
    side.ScrollBarThickness = 2
    side.ZIndex = 5
    Instance.new("UICorner", side).CornerRadius = UDim.new(0, 8)

    local sideLayout = Instance.new("UIListLayout", side)
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Padding = UDim.new(0, 5)
    sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(0.69, 0, 1, -55)
    content.Position = UDim2.new(0.30, 0, 0, 48)
    content.BackgroundColor3 = Color3.fromRGB(8, 15, 10)
    content.BackgroundTransparency = 0.85
    content.BorderSizePixel = 0
    content.ClipsDescendants = true
    content.ZIndex = 2
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

    local function mkPage()
        local p = Instance.new("ScrollingFrame", content)
        p.Size = UDim2.new(1, 0, 1, 0)
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.CanvasSize = UDim2.new(0, 0, 0, 1400)
        p.ScrollBarThickness = 2
        p.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 100)
        p.Visible = false
        p.ZIndex = 3
        return p
    end

    local pages = {}
    local homeP = mkPage(); homeP.Visible = true; pages["HOME"] = homeP
    local troP = mkPage(); pages["TRO"] = troP
    local plrP = mkPage(); pages["PLR"] = plrP
    local tgtP = mkPage(); pages["TGT"] = tgtP
    local protP = mkPage(); pages["PROT"] = protP
    local antP = mkPage(); pages["ANT"] = antP
    local trkP = mkPage(); pages["TRK"] = trkP
    local extP = mkPage(); pages["EXT"] = extP
    local dncP = mkPage(); dncP.CanvasSize = UDim2.new(0, 0, 0, 650); pages["DNC"] = dncP
    local wlkP = mkPage(); wlkP.CanvasSize = UDim2.new(0, 0, 0, 750); pages["WLK"] = wlkP
    local shieldP = mkPage(); shieldP.CanvasSize = UDim2.new(0, 0, 0, 1350); pages["SHIELD"] = shieldP
    local atkP = mkPage(); atkP.CanvasSize = UDim2.new(0, 0, 0, 800); pages["ATK"] = atkP
    local setP = mkPage(); pages["SET"] = setP

    local sideOrder = 0
    local function mkSideTab(txt, pageKey)
        sideOrder = sideOrder + 1
        local b = Instance.new("TextButton", side)
        b.Size = UDim2.new(0.92, 0, 0, 35)
        b.LayoutOrder = sideOrder
        b.BackgroundColor3 = Color3.fromRGB(12, 25, 15)
        b.BackgroundTransparency = 0.4
        b.TextColor3 = Color3.fromRGB(200, 255, 200)
        b.Text = txt
        b.Font = Enum.Font.Gotham
        b.TextSize = 11
        b.TextWrapped = true
        b.ZIndex = 10
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(function()
            for k, p in pairs(pages) do p.Visible = (k == pageKey) end
        end)
    end

    mkSideTab("🏠 الرئيسية", "HOME")
    mkSideTab("⚡ TRO Attack", "TRO")
    mkSideTab("🏃 أدوات اللاعب", "PLR")
    mkSideTab("🎯 نظام الاستهداف", "TGT")
    mkSideTab("🛡️ الحماية", "PROT")
    mkSideTab("🔴 TRO ANT", "ANT")
    mkSideTab("📍 Tracker", "TRK")
    mkSideTab("📦 أدوات إضافية", "EXT")
    mkSideTab("💃 رقصات", "DNC")
    mkSideTab("🚶 مشيات", "WLK")
    mkSideTab("🔒 TRO Shield", "SHIELD")
    mkSideTab("⚔️ TRO Sabotage", "ATK")
    mkSideTab("⚙️ الألوان", "SET")

    -- HOME
    do
        local hc = Instance.new("Frame", homeP)
        hc.Size = UDim2.new(0.92, 0, 0, 200)
        hc.Position = UDim2.new(0.04, 0, 0, 20)
        hc.BackgroundColor3 = Color3.fromRGB(12, 25, 15)
        hc.BackgroundTransparency = 0.2
        hc.BorderSizePixel = 0
        hc.ZIndex = 4
        Instance.new("UICorner", hc).CornerRadius = UDim.new(0, 8)
        local t = Instance.new("TextLabel", hc)
        t.Size = UDim2.new(0.9, 0, 0, 30)
        t.Position = UDim2.new(0.05, 0, 0, 15)
        t.BackgroundTransparency = 1
        t.TextColor3 = Color3.fromRGB(0, 255, 120)
        t.Text = "[+] TRO HUB - By سـجّـاد"
        t.TextSize = 11
        t.Font = Enum.Font.Gotham
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.ZIndex = 5
        local d = Instance.new("TextLabel", hc)
        d.Size = UDim2.new(0.9, 0, 0, 130)
        d.Position = UDim2.new(0.05, 0, 0, 55)
        d.BackgroundTransparency = 1
        d.TextColor3 = Color3.fromRGB(180, 255, 200)
        d.Text = "import tro_attack\nimport theme_config\nimport player_tools\nimport vr7_target_system\nimport protection_system\nimport tracker\nimport extra_tools\nimport anti_emote\nimport dances\nimport walks\nimport tro_shield\nimport tro_sabotage"
        d.TextSize = 10
        d.Font = Enum.Font.Gotham
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.TextYAlignment = Enum.TextYAlignment.Top
        d.ZIndex = 5
    end

    -- PLAYER
    local InfiniteJump, Noclip, JumpPower = false, false, 50
    do
        local pT = Instance.new("TextLabel", plrP)
        pT.Size = UDim2.new(0.9, 0, 0, 30)
        pT.Position = UDim2.new(0.04, 0, 0, 10)
        pT.BackgroundTransparency = 1
        pT.TextColor3 = Color3.fromRGB(0, 255, 120)
        pT.Text = "[*] أدوات اللاعب // player_tools.py"
        pT.TextSize = 11
        pT.Font = Enum.Font.Gotham
        pT.TextXAlignment = Enum.TextXAlignment.Left
        pT.ZIndex = 4

        local spdL = Instance.new("TextLabel", plrP)
        spdL.Size = UDim2.new(0.9, 0, 0, 25)
        spdL.Position = UDim2.new(0.04, 0, 0, 50)
        spdL.BackgroundTransparency = 1
        spdL.TextColor3 = Color3.fromRGB(0, 255, 120)
        spdL.Text = "⚡ السرعة: 0.0"
        spdL.TextSize = 11
        spdL.Font = Enum.Font.Gotham
        spdL.TextXAlignment = Enum.TextXAlignment.Left
        spdL.ZIndex = 4

        local jmpL = Instance.new("TextLabel", plrP)
        jmpL.Size = UDim2.new(0.9, 0, 0, 25)
        jmpL.Position = UDim2.new(0.04, 0, 0, 85)
        jmpL.BackgroundTransparency = 1
        jmpL.TextColor3 = Color3.fromRGB(0, 255, 120)
        jmpL.Text = "🦘 القفز: 50"
        jmpL.TextSize = 11
        jmpL.Font = Enum.Font.Gotham
        jmpL.TextXAlignment = Enum.TextXAlignment.Left
        jmpL.ZIndex = 4

        local ijB = Instance.new("TextButton", plrP)
        ijB.Size = UDim2.new(0.92, 0, 0, 40)
        ijB.Position = UDim2.new(0.04, 0, 0, 120)
        ijB.BackgroundColor3 = Color3.fromRGB(20, 50, 30)
        ijB.BackgroundTransparency = 0.2
        ijB.TextColor3 = Color3.fromRGB(200, 255, 200)
        ijB.Text = "♾️ قفز لا نهائي: OFF"
        ijB.TextSize = 11
        ijB.Font = Enum.Font.Gotham
        ijB.ZIndex = 10
        Instance.new("UICorner", ijB).CornerRadius = UDim.new(0, 6)
        ijB.MouseButton1Click:Connect(function()
            InfiniteJump = not InfiniteJump
            ijB.Text = InfiniteJump and "♾️ قفز لا نهائي: ON" or "♾️ قفز لا نهائي: OFF"
            ijB.BackgroundColor3 = InfiniteJump and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(20, 50, 30)
        end)

        local ncB = Instance.new("TextButton", plrP)
        ncB.Size = UDim2.new(0.92, 0, 0, 40)
        ncB.Position = UDim2.new(0.04, 0, 0, 170)
        ncB.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
        ncB.BackgroundTransparency = 0.2
        ncB.TextColor3 = Color3.fromRGB(200, 255, 200)
        ncB.Text = "🌀 Noclip: OFF"
        ncB.TextSize = 11
        ncB.Font = Enum.Font.Gotham
        ncB.ZIndex = 10
        Instance.new("UICorner", ncB).CornerRadius = UDim.new(0, 6)
        ncB.MouseButton1Click:Connect(function()
            Noclip = not Noclip
            ncB.Text = Noclip and "🌀 Noclip: ON" or "🌀 Noclip: OFF"
            ncB.BackgroundColor3 = Noclip and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 20, 50)
        end)

        local jF = Instance.new("Frame", plrP)
        jF.Size = UDim2.new(0.92, 0, 0, 40)
        jF.Position = UDim2.new(0.04, 0, 0, 220)
        jF.BackgroundColor3 = Color3.fromRGB(15, 30, 18)
        jF.BackgroundTransparency = 0.2
        jF.BorderSizePixel = 0
        jF.ZIndex = 4
        Instance.new("UICorner", jF).CornerRadius = UDim.new(0, 6)

        local jD = Instance.new("TextButton", jF)
        jD.Size = UDim2.new(0.3, 0, 1, 0)
        jD.Position = UDim2.new(0.02, 0, 0, 0)
        jD.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        jD.Text = "-"
        jD.TextColor3 = Color3.fromRGB(200, 255, 200)
        jD.TextSize = 16
        jD.Font = Enum.Font.Gotham
        jD.ZIndex = 10
        Instance.new("UICorner", jD).CornerRadius = UDim.new(0, 6)
        jD.MouseButton1Click:Connect(function()
            JumpPower = math.max(JumpPower - 5, 10)
            jmpL.Text = "🦘 القفز: " .. JumpPower
            local c = player.Character
            if c then local h = c:FindFirstChild("Humanoid"); if h then h.JumpPower = JumpPower end end
        end)

        local jU = Instance.new("TextButton", jF)
        jU.Size = UDim2.new(0.3, 0, 1, 0)
        jU.Position = UDim2.new(0.68, 0, 0, 0)
        jU.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
        jU.Text = "+"
        jU.TextColor3 = Color3.fromRGB(200, 255, 200)
        jU.TextSize = 16
        jU.Font = Enum.Font.Gotham
        jU.ZIndex = 10
        Instance.new("UICorner", jU).CornerRadius = UDim.new(0, 6)
        jU.MouseButton1Click:Connect(function()
            JumpPower = math.min(JumpPower + 5, 150)
            jmpL.Text = "🦘 القفز: " .. JumpPower
            local c = player.Character
            if c then local h = c:FindFirstChild("Humanoid"); if h then h.JumpPower = JumpPower end end
        end)

        local jV = Instance.new("TextLabel", jF)
        jV.Size = UDim2.new(0.3, 0, 1, 0)
        jV.Position = UDim2.new(0.35, 0, 0, 0)
        jV.BackgroundTransparency = 1
        jV.Text = "50"
        jV.TextColor3 = Color3.fromRGB(0, 255, 120)
        jV.TextSize = 11
        jV.Font = Enum.Font.Gotham
        jV.TextXAlignment = Enum.TextXAlignment.Center
        jV.ZIndex = 5

        task.spawn(function()
            while gui.Parent do
                task.wait(0.2)
                local c = player.Character
                if c then
                    local root = c:FindFirstChild("HumanoidRootPart")
                    local hum = c:FindFirstChild("Humanoid")
                    if root and hum then
                        local v = root.AssemblyLinearVelocity
                        spdL.Text = "⚡ السرعة: " .. math.floor((v.X * v.X + v.Z * v.Z) ^ 0.5 * 10) / 10
                        JumpPower = hum.JumpPower
                        jmpL.Text = "🦘 القفز: " .. JumpPower
                        jV.Text = JumpPower
                        if InfiniteJump and hum then hum.JumpPower = 50 end
                    end
                end
            end
        end)
    end

    -- TARGET SYSTEM
    local CurrentTarget = nil
    local FlingOriginalPos = nil
    local TalkRepeater = nil

    local function GetLocalChar() return player.Character end
    local function GetLocalRoot()
        local c = GetLocalChar()
        if c then return c:FindFirstChild("HumanoidRootPart") end
        return nil
    end
    local function GetTargetChar()
        if CurrentTarget then return CurrentTarget.Character end
        return nil
    end
    local function GetTargetRoot()
        local c = GetTargetChar()
        if c then return c:FindFirstChild("HumanoidRootPart") end
        return nil
    end
    local function playAnimById(id, speed, timePos)
        pcall(function()
            local char = GetLocalChar()
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            for _, t in pairs(hum:GetPlayingAnimationTracks()) do t:Stop() end
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(id)
            local track = hum:LoadAnimation(anim)
            track.Priority = Enum.AnimationPriority.Action
            track.Looped = false
            track:Play()
            if timePos then track.TimePosition = timePos end
            if speed then track:AdjustSpeed(speed) end
        end)
    end

    do
        local tT = Instance.new("TextLabel", tgtP)
        tT.Size = UDim2.new(0.9, 0, 0, 30)
        tT.Position = UDim2.new(0.04, 0, 0, 10)
        tT.BackgroundTransparency = 1
        tT.TextColor3 = Color3.fromRGB(0, 255, 120)
        tT.Text = "[*] نظام الاستهداف المتقدم // VR7 target_system.py"
        tT.TextSize = 11
        tT.Font = Enum.Font.Gotham
        tT.TextXAlignment = Enum.TextXAlignment.Left
        tT.ZIndex = 4

        local targetImg = Instance.new("ImageLabel", tgtP)
        targetImg.Size = UDim2.new(0, 85, 0, 85)
        targetImg.Position = UDim2.new(0.04, 0, 0, 45)
        targetImg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        targetImg.BorderColor3 = Color3.fromRGB(0, 255, 120)
        targetImg.Image = "rbxassetid://10818605405"
        targetImg.ZIndex = 4
        Instance.new("UICorner", targetImg).CornerRadius = UDim.new(0, 8)

        local tInp = Instance.new("TextBox", tgtP)
        tInp.Size = UDim2.new(0, 175, 0, 30)
        tInp.Position = UDim2.new(0.28, 0, 0, 45)
        tInp.PlaceholderText = "@target..."
        tInp.PlaceholderColor3 = Color3.fromRGB(100, 200, 110)
        tInp.TextColor3 = Color3.fromRGB(200, 255, 200)
        tInp.BackgroundColor3 = Color3.fromRGB(10, 25, 14)
        tInp.Font = Enum.Font.Gotham
        tInp.TextSize = 11
        tInp.ClearTextOnFocus = false
        tInp.ZIndex = 5
        Instance.new("UICorner", tInp).CornerRadius = UDim.new(0, 6)

        local clickTgtBtn = Instance.new("TextButton", tgtP)
        clickTgtBtn.Size = UDim2.new(0, 30, 0, 30)
        clickTgtBtn.Position = UDim2.new(0.77, 0, 0, 45)
        clickTgtBtn.Text = "🎯"
        clickTgtBtn.TextColor3 = Color3.fromRGB(200, 255, 200)
        clickTgtBtn.BackgroundColor3 = Color3.fromRGB(15, 60, 30)
        clickTgtBtn.Font = Enum.Font.GothamBold
        clickTgtBtn.TextSize = 14
        clickTgtBtn.ZIndex = 10
        Instance.new("UICorner", clickTgtBtn).CornerRadius = UDim.new(0, 6)

        local infoL = Instance.new("TextLabel", tgtP)
        infoL.Size = UDim2.new(0, 180, 0, 65)
        infoL.Position = UDim2.new(0.28, 0, 0, 78)
        infoL.BackgroundTransparency = 1
        infoL.Text = "UserID: ---\nDisplay: ---\nJoined: ---"
        infoL.TextColor3 = Color3.fromRGB(0, 255, 120)
        infoL.Font = Enum.Font.Gotham
        infoL.TextSize = 10
        infoL.TextXAlignment = Enum.TextXAlignment.Left
        infoL.TextYAlignment = Enum.TextYAlignment.Top
        infoL.ZIndex = 4

        local function UpdateTarget(secondaryPlayer)
            if secondaryPlayer == nil then
                tInp.Text = "@target..."
                infoL.Text = "UserID: ---\nDisplay: ---\nJoined: ---"
                targetImg.Image = "rbxassetid://10818605405"
                CurrentTarget = nil
                for _, btn in ipairs(tgtP:GetChildren()) do
                    if btn:IsA("TextButton") and btn:FindFirstChild("Ticket_Asset") then
                        btn.Ticket_Asset.ImageColor3 = Color3.fromRGB(255, 0, 0)
                    end
                end
                if TalkRepeater then TalkRepeater:Disconnect() TalkRepeater = nil end
                return
            end
            CurrentTarget = secondaryPlayer
            tInp.Text = secondaryPlayer.Name
            local success, thumb = pcall(function()
                return Players:GetUserThumbnailAsync(secondaryPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
            targetImg.Image = success and thumb or "rbxassetid://10818605405"
            local age = os.date("%Y/%m/%d", os.time() - (secondaryPlayer.AccountAge * 86400))
            infoL.Text = "UserID: " .. secondaryPlayer.UserId ..
                         "\nDisplay: @" .. secondaryPlayer.DisplayName ..
                         "\nJoined: " .. age
            sendNotify("Target", "✅ تم تحديد: " .. secondaryPlayer.Name)
            if TalkRepeater then TalkRepeater:Disconnect() TalkRepeater = nil end
        end

        local function makeActionButton(text, x, y)
            local b = Instance.new("TextButton", tgtP)
            b.Size = UDim2.new(0, 175, 0, 32)
            b.Position = UDim2.new(0, x, 0, y)
            b.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
            b.BackgroundTransparency = 0.3
            b.TextColor3 = Color3.fromRGB(200, 255, 200)
            b.Text = text
            b.TextSize = 10
            b.Font = Enum.Font.Gotham
            b.ZIndex = 10
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", b)
            bs.Thickness = 0.8
            bs.Color = Color3.fromRGB(0, 255, 120)
            local tkt = Instance.new("ImageLabel", b)
            tkt.Name = "Ticket_Asset"
            tkt.Size = UDim2.new(0, 22, 0, 22)
            tkt.Position = UDim2.new(1, -28, 0.5, -11)
            tkt.BackgroundTransparency = 1
            tkt.Image = "rbxassetid://3926305904"
            tkt.ImageColor3 = Color3.fromRGB(255, 0, 0)
            tkt.ImageRectOffset = Vector2.new(424, 4)
            tkt.ImageRectSize = Vector2.new(36, 36)
            tkt.ZIndex = 11
            return b
        end

        local function toggleColor(btn)
            if btn.Ticket_Asset.ImageColor3 ~= Color3.fromRGB(255, 0, 0) then
                btn.Ticket_Asset.ImageColor3 = Color3.fromRGB(255, 0, 0)
            else
                btn.Ticket_Asset.ImageColor3 = Color3.fromRGB(0, 255, 0)
            end
        end

        local function isActive(btn)
            return btn.Ticket_Asset.ImageColor3 == Color3.fromRGB(0, 255, 0)
        end

        local flingBtn = makeActionButton("فلنق (Fling)", 15, 155)
        local viewBtn = makeActionButton("مشاهدة (View)", 205, 155)
        local bangRevBtn = makeActionButton("بانق عكسي (Reverse)", 15, 195)
        local bangBtn = makeActionButton("بانق (Bang)", 205, 195)
        local headSitBtn = makeActionButton("جلوس في راسه", 15, 235)
        local suckingBtn = makeActionButton("تمص (Sucking)", 205, 235)
        local assSlapBtn = makeActionButton("ضرب مؤخرة", 15, 275)
        local headFuckBtn = makeActionButton("يمص (HeadFuck)", 205, 275)
        local backpackBtn = makeActionButton("حقيبة ظهر", 15, 315)
        local jerkBtn = makeActionButton("سوها عليه", 205, 315)
        local focusBtn = makeActionButton("سماع (Focus)", 15, 355)
        local repeatBtn = makeActionButton("تقليد الكلام", 205, 355)
        local tpBtn = makeActionButton("تنقل (Teleport)", 15, 395)
        local clickToolBtn = makeActionButton("اداة الاختيار", 205, 395)

        flingBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            toggleColor(flingBtn)
            if isActive(flingBtn) then
                FlingOriginalPos = GetLocalRoot() and GetLocalRoot().CFrame
                sendNotify("Fling", "🚀 بدء الفلنق...")
                task.spawn(function()
                    local origFPDH = workspace.FallenPartsDestroyHeight
                    workspace.FallenPartsDestroyHeight = -math.huge
                    while isActive(flingBtn) do
                        Run.Heartbeat:Wait()
                        local tH = GetTargetRoot()
                        local mH = GetLocalRoot()
                        if tH and mH and GetLocalChar().Humanoid then
                            GetLocalChar().Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                            local sum = tick() * 1000
                            mH.CFrame = tH.CFrame * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(sum), 0, math.rad(sum))
                            mH.AssemblyLinearVelocity = Vector3.new(900000000, 900000000, 900000000)
                            mH.AssemblyAngularVelocity = Vector3.new(900000000, 900000000, 900000000)
                        else break end
                    end
                    workspace.FallenPartsDestroyHeight = origFPDH
                    if GetLocalRoot() and FlingOriginalPos then
                        GetLocalRoot().CFrame = FlingOriginalPos
                        GetLocalChar().Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                        GetLocalChar().Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end)
            else
                if GetLocalRoot() and FlingOriginalPos then
                    GetLocalRoot().CFrame = FlingOriginalPos
                    if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                        GetLocalChar().Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                        GetLocalChar().Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
            end
        end)

        viewBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            toggleColor(viewBtn)
            if isActive(viewBtn) then
                task.spawn(function()
                    while isActive(viewBtn) do
                        Run.Heartbeat:Wait()
                        local tChar = GetTargetChar()
                        if tChar and tChar:FindFirstChildOfClass("Humanoid") then
                            workspace.CurrentCamera.CameraSubject = tChar.Humanoid
                        else break end
                    end
                    if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                        workspace.CurrentCamera.CameraSubject = GetLocalChar().Humanoid
                    end
                end)
            else
                if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                    workspace.CurrentCamera.CameraSubject = GetLocalChar().Humanoid
                end
            end
        end)

        bangRevBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            toggleColor(bangRevBtn)
            if isActive(bangRevBtn) then
                task.spawn(function()
                    local sum, step, yOffset = -2, 0.15, -1
                    while isActive(bangRevBtn) do
                        Run.Heartbeat:Wait()
                        local tChar = GetTargetChar()
                        local mH = GetLocalRoot()
                        if tChar and mH then
                            local torso = tChar:FindFirstChild("Torso") or tChar:FindFirstChild("UpperTorso")
                            if torso then
                                if torso.Name == "Torso" then yOffset = -0.75 end
                                if GetLocalChar().Humanoid then GetLocalChar().Humanoid.Sit = true end
                                mH.CFrame = torso.CFrame * CFrame.new(0, yOffset, sum) * CFrame.Angles(math.rad(270), 0, 0)
                                mH.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                sum = sum + step
                                if sum >= -1 or sum <= -2 then step = -step end
                            end
                        else break end
                    end
                    if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                        GetLocalChar().Humanoid.Sit = false
                    end
                end)
            end
        end)

        bangBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            toggleColor(bangBtn)
            if isActive(bangBtn) then
                task.spawn(function()
                    while isActive(bangBtn) do
                        Run.Heartbeat:Wait()
                        local tChar = GetTargetChar()
                        local mH = GetLocalRoot()
                        if tChar and mH then
                            local torso = tChar:FindFirstChild("Torso") or tChar:FindFirstChild("UpperTorso")
                            if torso and GetLocalChar().Humanoid then
                                GetLocalChar().Humanoid.Sit = true
                                mH.CFrame = torso.CFrame * CFrame.new(0, 0, 1)
                                mH.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                if GetLocalChar().Humanoid.RigType.Name == "R15" then
                                    playAnimById("5918726674", 2)
                                else
                                    playAnimById("148840371", 2.5)
                                end
                            end
                        else break end
                    end
                    if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                        GetLocalChar().Humanoid.Sit = false
                    end
                end)
            end
        end)

        headSitBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            toggleColor(headSitBtn)
            if isActive(headSitBtn) then
                task.spawn(function()
                    while isActive(headSitBtn) do
                        Run.Heartbeat:Wait()
                        local tChar = GetTargetChar()
                        local mH = GetLocalRoot()
                        if tChar and tChar:FindFirstChild("Head") and mH and GetLocalChar().Humanoid then
                            GetLocalChar().Humanoid.Sit = true
                            mH.CFrame = tChar.Head.CFrame * CFrame.new(0, 2, 0)
                            mH.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        else break end
                    end
                    if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                        GetLocalChar().Humanoid.Sit = false
                    end
                end)
            end
        end)

        suckingBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            toggleColor(suckingBtn)
            if isActive(suckingBtn) then
                task.spawn(function()
                    local sum, step = -2, 0.15
                    while isActive(suckingBtn) do
                        Run.Heartbeat:Wait()
                        local tChar = GetTargetChar()
                        local mH = GetLocalRoot()
                        if tChar and mH and GetLocalChar().Humanoid then
                            local torso = tChar:FindFirstChild("Torso") or tChar:FindFirstChild("UpperTorso")
                            if torso then
                                GetLocalChar().Humanoid.Sit = true
                                mH.CFrame = torso.CFrame * CFrame.new(0, -2.4, sum) * CFrame.Angles(0, math.rad(180), 0)
                                mH.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                sum = sum + step
                                if sum >= -1 or sum <= -2 then step = -step end
                            end
                        else break end
                    end
                    if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                        GetLocalChar().Humanoid.Sit = false
                    end
                end)
            end
        end)

        assSlapBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            if not GetLocalChar() or GetLocalChar().Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
                sendNotify("AssSlap", "يجب أن تكون R15")
                return
            end
            toggleColor(assSlapBtn)
            if isActive(assSlapBtn) then
                task.spawn(function()
                    while isActive(assSlapBtn) do
                        playAnimById("16302986", 1, 16)
                        task.wait(1)
                    end
                end)
                task.spawn(function()
                    while isActive(assSlapBtn) do
                        Run.Heartbeat:Wait()
                        local tChar = GetTargetChar()
                        local mH = GetLocalRoot()
                        if tChar and mH and GetLocalChar().Humanoid then
                            local torso = tChar:FindFirstChild("Torso") or tChar:FindFirstChild("UpperTorso")
                            if torso then
                                GetLocalChar().Humanoid.Sit = true
                                mH.CFrame = torso.CFrame * CFrame.new(-2, -0.2, 1.7)
                                mH.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            end
                        else break end
                    end
                    if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                        GetLocalChar().Humanoid.Sit = false
                    end
                end)
            end
        end)

        headFuckBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            toggleColor(headFuckBtn)
            if isActive(headFuckBtn) then
                task.spawn(function()
                    local sum, step = -2, 0.3
                    while isActive(headFuckBtn) do
                        task.wait(0.01)
                        local tChar = GetTargetChar()
                        local mH = GetLocalRoot()
                        if tChar and tChar:FindFirstChild("Head") and mH and GetLocalChar().Humanoid then
                            GetLocalChar().Humanoid.Sit = true
                            mH.CFrame = tChar.Head.CFrame * CFrame.new(0, 0.7, sum) * CFrame.Angles(0, math.rad(180), 0)
                            mH.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            sum = sum + step
                            if sum >= -1 or sum <= -2 then step = -step end
                        else break end
                    end
                    if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                        GetLocalChar().Humanoid.Sit = false
                    end
                end)
            end
        end)

        backpackBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            toggleColor(backpackBtn)
            if isActive(backpackBtn) then
                task.spawn(function()
                    while isActive(backpackBtn) do
                        Run.Heartbeat:Wait()
                        local tH = GetTargetRoot()
                        local mH = GetLocalRoot()
                        if tH and mH and GetLocalChar().Humanoid then
                            GetLocalChar().Humanoid.Sit = true
                            mH.CFrame = tH.CFrame * CFrame.new(0, 0, 1.2) * CFrame.Angles(0, -3, 0)
                            mH.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        else break end
                    end
                    if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                        GetLocalChar().Humanoid.Sit = false
                    end
                end)
            end
        end)

        jerkBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            toggleColor(jerkBtn)
            if isActive(jerkBtn) then
                task.spawn(function()
                    while isActive(jerkBtn) do
                        if GetLocalChar() and GetLocalChar().Humanoid.RigType == Enum.HumanoidRigType.R15 then
                            playAnimById("698251653", 0.4, 0.6)
                            task.wait(0.16)
                        else
                            playAnimById("72042024", 1, 0.675)
                            task.wait(0.4)
                        end
                    end
                end)
                task.spawn(function()
                    while isActive(jerkBtn) do
                        Run.Heartbeat:Wait()
                        local tH = GetTargetRoot()
                        local mH = GetLocalRoot()
                        if tH and mH and GetLocalChar().Humanoid then
                            GetLocalChar().Humanoid.Sit = true
                            mH.CFrame = tH.CFrame * CFrame.new(0, 1, -3) * CFrame.Angles(0, math.pi, 0)
                            mH.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        else break end
                    end
                    if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                        GetLocalChar().Humanoid.Sit = false
                    end
                end)
            end
        end)

        focusBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            toggleColor(focusBtn)
            if isActive(focusBtn) then
                local oldPos = GetLocalRoot() and GetLocalRoot().Position
                task.spawn(function()
                    while isActive(focusBtn) do
                        Run.Heartbeat:Wait()
                        local tChar = GetTargetChar()
                        local mH = GetLocalRoot()
                        if tChar and tChar:FindFirstChild("Head") and mH then
                            mH.CFrame = tChar.Head.CFrame * CFrame.new(0, -20, 0) * CFrame.Angles(math.rad(180), 0, 0)
                            workspace.CurrentCamera.CameraSubject = tChar.Humanoid
                        else break end
                    end
                    if GetLocalRoot() and oldPos then GetLocalRoot().CFrame = CFrame.new(oldPos) end
                    if GetLocalChar() and GetLocalChar():FindFirstChildOfClass("Humanoid") then
                        workspace.CurrentCamera.CameraSubject = GetLocalChar().Humanoid
                        GetLocalChar().Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end)
            end
        end)

        repeatBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            toggleColor(repeatBtn)
            if isActive(repeatBtn) then
                if TalkRepeater then TalkRepeater:Disconnect() end
                TalkRepeater = game:GetService("TextChatService").MessageReceived:Connect(function(msg)
                    if msg.TextSource and msg.TextSource.UserId == CurrentTarget.UserId then
                        sendText(msg.Text)
                    end
                end)
            else
                if TalkRepeater then TalkRepeater:Disconnect() TalkRepeater = nil end
            end
        end)

        tpBtn.MouseButton1Click:Connect(function()
            if not CurrentTarget then sendNotify("Target", "❌ حدد ضحية أولاً!") return end
            pcall(function()
                GetLocalRoot().CFrame = GetTargetRoot().CFrame
            end)
        end)

        local function addClickTool()
            pcall(function()
                for _, t in ipairs(player.Backpack:GetChildren()) do
                    if t.Name == "ClickTargetTRO" then t:Destroy() end
                end
                local tool = Instance.new("Tool")
                tool.Name = "ClickTargetTRO"
                tool.RequiresHandle = false
                tool.TextureId = "rbxassetid://13769558274"
                tool.ToolTip = "اختار شخص"
                tool.Activated:Connect(function()
                    local mouse = player:GetMouse()
                    local target = mouse.Target
                    if target and target.Parent then
                        local plr
                        if target.Parent:IsA("Model") then
                            plr = Players:GetPlayerFromCharacter(target.Parent)
                        elseif target.Parent:IsA("Accessory") then
                            plr = Players:GetPlayerFromCharacter(target.Parent.Parent)
                        end
                        if plr and plr ~= player then
                            UpdateTarget(plr)
                        end
                    end
                end)
                tool.Parent = player.Backpack
            end)
            sendNotify("ClickTarget", "أضفنا لك أداة الاختيار في الحقيبة")
        end

        clickToolBtn.MouseButton1Click:Connect(addClickTool)
        clickTgtBtn.MouseButton1Click:Connect(addClickTool)

        tInp.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local q = tInp.Text:gsub("^%s+", ""):gsub("%s+$", "")
                if q == "" then return end
                local lq = string.lower(q)
                local found
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and (string.find(string.lower(p.Name), lq, 1, true) or string.find(string.lower(p.DisplayName), lq, 1, true)) then
                        found = p
                        break
                    end
                end
                if found then UpdateTarget(found)
                else sendNotify("Target", "❌ لم يتم العثور على اللاعب") end
            end
        end)

        Players.PlayerRemoving:Connect(function(p)
            if CurrentTarget and p == CurrentTarget then
                sendNotify("Target", "🚪 الضحية خرجت من السيرفر")
                UpdateTarget(nil)
            end
        end)
    end

    Run.Stepped:Connect(function()
        if Noclip and player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    UIS.JumpRequest:Connect(function()
        if InfiniteJump and player.Character then
            local h = player.Character:FindFirstChild("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    -- TRO PAGE
    do
        local trT = Instance.new("TextLabel", troP)
        trT.Size = UDim2.new(0.9, 0, 0, 30)
        trT.Position = UDim2.new(0.04, 0, 0, 10)
        trT.BackgroundTransparency = 1
        trT.TextColor3 = Color3.fromRGB(0, 255, 120)
        trT.Text = "[*] نظام السبام // tro_attack.py"
        trT.TextSize = 11
        trT.Font = Enum.Font.Gotham
        trT.TextXAlignment = Enum.TextXAlignment.Left
        trT.ZIndex = 4

        local iHold = Instance.new("Frame", troP)
        iHold.Size = UDim2.new(0.92, 0, 0, 120)
        iHold.Position = UDim2.new(0.04, 0, 0, 50)
        iHold.BackgroundTransparency = 1
        iHold.ZIndex = 4

        local grid = Instance.new("UIGridLayout", iHold)
        grid.CellSize = UDim2.new(0, 68, 0, 28)
        grid.CellPadding = UDim2.new(0, 3, 0, 5)
        grid.FillDirection = Enum.FillDirection.Horizontal
        grid.FillDirectionMaxCells = 7
        grid.SortOrder = Enum.SortOrder.LayoutOrder

        local pInputs = {}
        for i = 1, 14 do
            local c = Instance.new("Frame", iHold)
            c.BackgroundColor3 = Color3.fromRGB(15, 30, 18)
            c.BorderSizePixel = 0
            c.ZIndex = 4
            Instance.new("UICorner", c).CornerRadius = UDim.new(0, 4)
            local cs = Instance.new("UIStroke", c)
            cs.Color = Color3.fromRGB(0, 255, 120)
            local inp = Instance.new("TextBox", c)
            inp.Size = UDim2.new(1, 0, 1, 0)
            inp.BackgroundTransparency = 1
            inp.TextColor3 = Color3.fromRGB(200, 255, 200)
            inp.PlaceholderText = "لاعب " .. i
            inp.PlaceholderColor3 = Color3.fromRGB(100, 200, 110)
            inp.Text = ""
            inp.Font = Enum.Font.Gotham
            inp.TextSize = 9
            inp.TextXAlignment = Enum.TextXAlignment.Center
            inp.ClearTextOnFocus = false
            inp.ZIndex = 5
            pInputs[i] = inp
        end

        local cBox = Instance.new("TextBox", troP)
        cBox.Size = UDim2.new(0.92, 0, 0, 45)
        cBox.Position = UDim2.new(0.04, 0, 0, 180)
        cBox.BackgroundColor3 = Color3.fromRGB(15, 30, 18)
        cBox.TextColor3 = Color3.fromRGB(200, 255, 200)
        cBox.PlaceholderText = "الأمر المدمج..."
        cBox.Text = ""
        cBox.Font = Enum.Font.Gotham
        cBox.TextSize = 11
        cBox.TextWrapped = true
        cBox.ClearTextOnFocus = false
        cBox.ZIndex = 5
        Instance.new("UICorner", cBox).CornerRadius = UDim.new(0, 8)

        local lbls = {"تجهيز 1", "تجهيز 2", "تجهيز 3", "هيد ادمن", "غامض 5"}
        local mysteryCmd = ";jc me ;ice me ;loopwarp me ;loopkill me ;blur me ;loopexplode me ;noclip me -inf ;squash me ;size me 2 ;warn me ;logs me ;ap me -inf ;smoke me ;sup me ;change me ;nv me"
        local rawCmds = {
            [1] = ";re me ;res me ;clogs me ;logs me ",
            [2] = ";re me ;nv me ;clogs me ;logs me ",
            [3] = ";ap me inf ;jc mc me ;nv me ;clogs me ;ice me ",
            [4] = ";jc me ;ice me ;explode me ;loopkill me ;loopwarp me ;blur me ;squash me ;size me 2 ;color me red ;shine ;logs me ;clogs me ;nv me ;n m ;chatlogs me ;warn me ;dog me ;aura me ; ;jc me ;ice me ;explode me ;loopkill me ;loopwarp me ;blur me ;squash me ;size me 2 ;color me red ;shine ;logs me ;clogs me ;nv me ;n m ;chatlogs me ;warn me ;dog me ;aura me ; ;jc me ;ice me ;explode me ;loopkill me ;loopwarp me ;blur me ;squash me ;size me 2 ;color me red ;shine ;logs me ;clogs me ;nv me ;n m ;chatlogs me ;warn me ;dog me ;aura me ; ;jc me ;ice me ;explode me ;loopkill me ;loopwarp me ;blur me ;squash me ;size me 2 ;color me red ;shine ;logs me ;clogs me ;nv me ;n m ;chatlogs me ;warn me ;dog me ;aura me ; ;jc me ;ice me ;explode me ;loopkill me ;loopwarp me ;blur me ;squash me ;size me 2 ;color me red ;shine ;logs me ;clogs me ;nv me ;n m ;chatlogs me ;warn me ;dog me ;aura me ; ;jc me ;ice me ;explode me ;loopkill me ;loopwarp me ;blur me ;squash me ;size me 2 ;color me red ;shine ;logs me ;clogs me ;nv me ;n m ;chatlogs me ;warn me ;dog me ;aura me ; ;jc me ;ice me ;explode me ;loopkill me ;loopwarp me ;blur me ;squash me ;size me 2 ;color me red ;shine ;logs me ;clogs me ;nv me ;n m ;chatlogs me ;warn me ;dog me ;aura me ; ;jc me ;ice me ;explode me ;loopkill me ;loopwarp me ;blur me ;squash me ;size me 2 ;color me red ;shine ;logs me ;clogs me ;nv me ;n m ;chatlogs me ;warn me ;dog me ;aura me ; ;jc me ;ice me ;explode me ;loopkill me ;loopwarp me ;blur me ;squash me ;size me 2 ;color me red ;shine ;logs me ;clogs me ;nv me ;n m ;chatlogs me ;warn me ;dog me ;aura me ; ;jc me ;ice me ;explode me ;loopkill me ;loopwarp me ;blur me ;squash me ;size me 2 ;color me red ;shine ;logs me ;clogs me ;nv me ;n m ;chatlogs me ;warn me ;dog me ;aura me ; ;jc me ;ice me ;explode me ;loopkill me ;loopwarp me ;blur me ;squash me ;size me 2 ;color me red ;shine ;logs me ;clogs me ;nv me ;n m ;chatlogs me ;warn me ;dog me ;aura me ;",
            [5] = mysteryCmd
        }

        local bW, bG = 0.174, 0.012
        local pBtns = {}
        for i = 1, 5 do
            local b = Instance.new("TextButton", troP)
            b.Size = UDim2.new(bW, 0, 0, 32)
            b.Position = UDim2.new(0.04 + (i - 1) * (bW + bG), 0, 0, 240)
            b.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
            b.Text = lbls[i]
            b.TextColor3 = Color3.fromRGB(200, 255, 200)
            b.Font = Enum.Font.Gotham
            b.TextSize = 11
            b.ZIndex = 10
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", b)
            bs.Color = Color3.fromRGB(0, 255, 120)
            pBtns[i] = b
        end

        local cpB = Instance.new("TextButton", troP)
        cpB.Size = UDim2.new(0.92, 0, 0, 32)
        cpB.Position = UDim2.new(0.04, 0, 0, 290)
        cpB.BackgroundColor3 = Color3.fromRGB(0, 80, 40)
        cpB.Text = "📋 نسخ جميع الأسماء"
        cpB.TextColor3 = Color3.fromRGB(200, 255, 200)
        cpB.Font = Enum.Font.Gotham
        cpB.TextSize = 10
        cpB.ZIndex = 10
        Instance.new("UICorner", cpB).CornerRadius = UDim.new(0, 6)

        local spamB = Instance.new("TextButton", troP)
        spamB.Size = UDim2.new(0.92, 0, 0, 45)
        spamB.Position = UDim2.new(0.04, 0, 0, 335)
        spamB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
        spamB.Text = "⚠ INITIATE SPAM"
        spamB.TextColor3 = Color3.fromRGB(200, 255, 200)
        spamB.Font = Enum.Font.Gotham
        spamB.TextSize = 14
        spamB.ZIndex = 10
        Instance.new("UICorner", spamB).CornerRadius = UDim.new(0, 8)
        local spamBS = Instance.new("UIStroke", spamB)
        spamBS.Color = Color3.fromRGB(0, 255, 120)
        spamBS.Thickness = 2

        local spamL = Instance.new("TextLabel", troP)
        spamL.Size = UDim2.new(1, 0, 0, 20)
        spamL.Position = UDim2.new(0, 0, 0, 390)
        spamL.BackgroundTransparency = 1
        spamL.Text = "SYSTEM STANDBY"
        spamL.TextColor3 = Color3.fromRGB(150, 255, 150)
        spamL.Font = Enum.Font.Gotham
        spamL.TextSize = 10
        spamL.ZIndex = 5

        local spamming, spamThread = false, nil

        local function getTgts()
            local t = {}
            for i = 1, 14 do local v = pInputs[i].Text:gsub("%s+", ""); if v ~= "" then table.insert(t, v) end end
            return t
        end

        local function genPayload(v)
            local t = getTgts()
            if #t == 0 then spamL.Text = "ERROR: NO TARGETS"; spamL.TextColor3 = Color3.fromRGB(255, 100, 100); return "" end
            local combined = table.concat(t, ",")
            local raw = rawCmds[v] or ""
            raw = string.gsub(raw, v == 4 and "ss" or "me", combined)
            return raw
        end

        for i = 1, 5 do
            pBtns[i].MouseButton1Click:Connect(function()
                local pl = genPayload(i)
                if pl ~= "" then cBox.Text = pl end
            end)
        end

        cpB.MouseButton1Click:Connect(function()
            local t = getTgts()
            if #t == 0 then spamL.Text = "⚠ لا يوجد أسماء!"; spamL.TextColor3 = Color3.fromRGB(255, 200, 0); return end
            cBox.Text = string.gsub(rawCmds[5], "me", table.concat(t, ","))
            spamL.Text = "📋 تم نسخ " .. #t .. " لاعب"
            spamL.TextColor3 = Color3.fromRGB(0, 255, 100)
        end)

        spamB.MouseButton1Click:Connect(function()
            if not spamming then
                local pl = cBox.Text
                if pl == "" then spamL.Text = "ERROR: NO PAYLOAD" return end
                spamming = true
                spamB.Text = "■ ABORT ATTACK"
                spamB.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                spamL.Text = "🔥 SPAMMING..."
                spamL.TextColor3 = Color3.fromRGB(0, 255, 50)
                spamThread = task.spawn(function()
                    while spamming do sendText(pl); task.wait() end
                end)
            else
                spamming = false
                if spamThread then pcall(function() task.cancel(spamThread) end) end
                spamB.Text = "⚠ INITIATE SPAM"
                spamB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
                spamL.Text = "SYSTEM STANDBY"
                spamL.TextColor3 = Color3.fromRGB(150, 255, 150)
            end
        end)
    end

    -- PROTECTION
    do
        local protTitle = Instance.new("TextLabel", protP)
        protTitle.Size = UDim2.new(0.9, 0, 0, 30)
        protTitle.Position = UDim2.new(0.04, 0, 0, 10)
        protTitle.BackgroundTransparency = 1
        protTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
        protTitle.Text = "[*] نظام الحماية // protection.py"
        protTitle.TextSize = 11
        protTitle.Font = Enum.Font.Gotham
        protTitle.ZIndex = 4

        local function mkProtBox(title, desc, y, h)
            local f = Instance.new("Frame", protP)
            f.Size = UDim2.new(0.92, 0, 0, h or 100)
            f.Position = UDim2.new(0.04, 0, 0, y)
            f.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
            f.BackgroundTransparency = 0.2
            f.BorderSizePixel = 0
            f.ZIndex = 4
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
            local fs2 = Instance.new("UIStroke", f)
            fs2.Color = Color3.fromRGB(0, 255, 120)
            fs2.Thickness = 1
            local t = Instance.new("TextLabel", f)
            t.Size = UDim2.new(0.9, 0, 0, 25)
            t.Position = UDim2.new(0.05, 0, 0, 10)
            t.BackgroundTransparency = 1
            t.TextColor3 = Color3.fromRGB(0, 255, 120)
            t.Text = title
            t.TextSize = 11
            t.Font = Enum.Font.Gotham
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.ZIndex = 5
            local d = Instance.new("TextLabel", f)
            d.Size = UDim2.new(0.9, 0, 0, 18)
            d.Position = UDim2.new(0.05, 0, 0, 35)
            d.BackgroundTransparency = 1
            d.TextColor3 = Color3.fromRGB(180, 255, 200)
            d.Text = desc
            d.TextSize = 9
            d.Font = Enum.Font.Gotham
            d.TextXAlignment = Enum.TextXAlignment.Left
            d.ZIndex = 5
            return f
        end

        local exF = mkProtBox("💥 حماية Explode", "# حماية ضد الانفجارات", 50)
        local exB = Instance.new("TextButton", exF)
        exB.Size = UDim2.new(0.35, 0, 0, 30)
        exB.Position = UDim2.new(0.05, 0, 0, 60)
        exB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
        exB.Text = "تشغيل"
        exB.TextColor3 = Color3.fromRGB(200, 255, 200)
        exB.Font = Enum.Font.Gotham
        exB.TextSize = 11
        exB.ZIndex = 10
        Instance.new("UICorner", exB).CornerRadius = UDim.new(0, 6)
        exB.MouseButton1Click:Connect(function()
            pcall(function() loadstring(game:HttpGet("https://pastefy.app/PJZbrpPP/raw"))() end)
        end)

        local bsF = mkProtBox("🛡️ حماية أساسية", "# حماية أساسية", 165)
        local bsB = Instance.new("TextButton", bsF)
        bsB.Size = UDim2.new(0.35, 0, 0, 30)
        bsB.Position = UDim2.new(0.05, 0, 0, 60)
        bsB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
        bsB.Text = "تشغيل"
        bsB.TextColor3 = Color3.fromRGB(200, 255, 200)
        bsB.Font = Enum.Font.Gotham
        bsB.TextSize = 11
        bsB.ZIndex = 10
        Instance.new("UICorner", bsB).CornerRadius = UDim.new(0, 6)
        bsB.MouseButton1Click:Connect(function()
            pcall(function() loadstring(game:HttpGet("https://little-fire-df75.melakmalak763.workers.dev/"))() end)
        end)

        local aflActive, aflConn, aflLastCF = false, nil, nil
        local afF = mkProtBox("🌀 مضاد Fling", "# حماية ضد الفلنق", 280, 130)
        local afB = Instance.new("TextButton", afF)
        afB.Size = UDim2.new(0.35, 0, 0, 30)
        afB.Position = UDim2.new(0.05, 0, 0, 60)
        afB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
        afB.Text = "تشغيل"
        afB.TextColor3 = Color3.fromRGB(200, 255, 200)
        afB.Font = Enum.Font.Gotham
        afB.TextSize = 11
        afB.ZIndex = 10
        Instance.new("UICorner", afB).CornerRadius = UDim.new(0, 6)

        local afS = Instance.new("TextLabel", afF)
        afS.Size = UDim2.new(0.5, 0, 0, 25)
        afS.Position = UDim2.new(0.45, 0, 0, 63)
        afS.BackgroundTransparency = 1
        afS.Text = "⛔ معطل"
        afS.TextColor3 = Color3.fromRGB(255, 100, 100)
        afS.Font = Enum.Font.Gotham
        afS.TextSize = 10
        afS.ZIndex = 5

        afB.MouseButton1Click:Connect(function()
            aflActive = not aflActive
            if aflActive then
                afB.Text = "إيقاف"
                afB.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                afS.Text = "✅ مفعل"
                afS.TextColor3 = Color3.fromRGB(0, 255, 100)
                local hrp = getHRP()
                if hrp then aflLastCF = hrp.CFrame end
                if aflConn then aflConn:Disconnect() end
                aflConn = Run.Heartbeat:Connect(function()
                    if not aflActive then return end
                    local h = getHRP()
                    if not h then return end
                    local vel = h.AssemblyLinearVelocity
                    if vel.Magnitude > 300 then
                        h.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        h.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        if aflLastCF then h.CFrame = aflLastCF end
                        clearBodyMovers(h)
                    else
                        aflLastCF = h.CFrame
                    end
                end)
            else
                afB.Text = "تشغيل"
                afB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
                afS.Text = "⛔ معطل"
                afS.TextColor3 = Color3.fromRGB(255, 100, 100)
                if aflConn then aflConn:Disconnect() aflConn = nil end
            end
        end)

        local apF = mkProtBox("⚡ مضاد AP", "# يمنع AP me inf", 425, 130)
        local apB = Instance.new("TextButton", apF)
        apB.Size = UDim2.new(0.35, 0, 0, 30)
        apB.Position = UDim2.new(0.05, 0, 0, 60)
        apB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
        apB.Text = "تشغيل"
        apB.TextColor3 = Color3.fromRGB(200, 255, 200)
        apB.Font = Enum.Font.Gotham
        apB.TextSize = 11
        apB.ZIndex = 10
        Instance.new("UICorner", apB).CornerRadius = UDim.new(0, 6)
        apB.MouseButton1Click:Connect(function()
            sendNotify("Anti-AP", "✅ تم التحميل")
            pcall(function() loadstring(game:HttpGet("https://pastefy.app/iNn9DNTk/raw"))() end)
        end)
    end

    -- TRO ANT
    do
        local antT = Instance.new("TextLabel", antP)
        antT.Size = UDim2.new(0.9, 0, 0, 30)
        antT.Position = UDim2.new(0.04, 0, 0, 10)
        antT.BackgroundTransparency = 1
        antT.TextColor3 = Color3.fromRGB(255, 60, 60)
        antT.Text = "🔴 TRO ANT"
        antT.TextSize = 12
        antT.Font = Enum.Font.GothamBold
        antT.ZIndex = 4

        local antF = Instance.new("Frame", antP)
        antF.Size = UDim2.new(0.92, 0, 0, 100)
        antF.Position = UDim2.new(0.04, 0, 0, 50)
        antF.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
        antF.BackgroundTransparency = 0.2
        antF.BorderSizePixel = 0
        antF.ZIndex = 4
        Instance.new("UICorner", antF).CornerRadius = UDim.new(0, 8)

        local antB = Instance.new("TextButton", antF)
        antB.Size = UDim2.new(0.3, 0, 0, 30)
        antB.Position = UDim2.new(0.05, 0, 0, 60)
        antB.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        antB.Text = "🔴 تشغيل"
        antB.TextColor3 = Color3.fromRGB(255, 200, 200)
        antB.Font = Enum.Font.Gotham
        antB.TextSize = 11
        antB.ZIndex = 10
        Instance.new("UICorner", antB).CornerRadius = UDim.new(0, 6)

        local antS = Instance.new("TextLabel", antF)
        antS.Size = UDim2.new(0.5, 0, 0, 25)
        antS.Position = UDim2.new(0.4, 0, 0, 63)
        antS.BackgroundTransparency = 1
        antS.Text = "⛔ معطل"
        antS.TextColor3 = Color3.fromRGB(255, 100, 100)
        antS.Font = Enum.Font.Gotham
        antS.TextSize = 10
        antS.ZIndex = 5

        local antToggle, antLastPos, antDb, antVelConn, antGazePart = false, nil, false, nil, nil

        antB.MouseButton1Click:Connect(function()
            if antDb then return end
            local c = player.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if antToggle then
                antDb = true
                antToggle = false
                if antVelConn then antVelConn:Disconnect() antVelConn = nil end
                local tw = TS:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(antLastPos)})
                antB.Text = "⏳ جاري..."
                tw:Play()
                tw.Completed:Wait()
                antB.Text = "🔴 تشغيل"
                antB.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
                antDb = false
                if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = c:FindFirstChild("Humanoid") end
                if antGazePart then antGazePart:Destroy() antGazePart = nil end
                antS.Text = "⛔ معطل"
                antS.TextColor3 = Color3.fromRGB(255, 100, 100)
            else
                antDb = true
                antLastPos = hrp.Position
                antGazePart = Instance.new("Part")
                antGazePart.Size = Vector3.new(4, 5, 4)
                antGazePart.Position = antLastPos
                antGazePart.Anchored = true
                antGazePart.CanCollide = false
                antGazePart.Transparency = 0.5
                antGazePart.Name = "Gaze"
                antGazePart.Parent = workspace
                workspace.CurrentCamera.CameraSubject = antGazePart
                antToggle = true
                local tw = TS:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(Vector3.new(0, -80000000, 0))})
                antB.Text = "⏳ جاري..."
                tw:Play()
                tw.Completed:Wait()
                antB.Text = "🔴 إيقاف"
                antB.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
                antDb = false
                antVelConn = Run.Heartbeat:Connect(function()
                    if antToggle and hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
                end)
                antS.Text = "✅ مفعل"
                antS.TextColor3 = Color3.fromRGB(0, 255, 100)
            end
        end)
    end

    -- TRACKER
    do
        local trackerTitle = Instance.new("TextLabel", trkP)
        trackerTitle.Size = UDim2.new(0.9, 0, 0, 30)
        trackerTitle.Position = UDim2.new(0.04, 0, 0, 10)
        trackerTitle.BackgroundTransparency = 1
        trackerTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
        trackerTitle.Text = "[*] تتبع لاعبين معينين // tracker.py"
        trackerTitle.TextSize = 11
        trackerTitle.Font = Enum.Font.Gotham
        trackerTitle.TextXAlignment = Enum.TextXAlignment.Left
        trackerTitle.ZIndex = 4

        local trackerInput = Instance.new("TextBox", trkP)
        trackerInput.Size = UDim2.new(0.62, 0, 0, 32)
        trackerInput.Position = UDim2.new(0.04, 0, 0, 55)
        trackerInput.BackgroundColor3 = Color3.fromRGB(8, 18, 12)
        trackerInput.TextColor3 = Color3.fromRGB(200, 255, 200)
        trackerInput.PlaceholderText = "اسم اللاعب..."
        trackerInput.PlaceholderColor3 = Color3.fromRGB(80, 160, 100)
        trackerInput.Text = ""
        trackerInput.Font = Enum.Font.Gotham
        trackerInput.TextSize = 10
        trackerInput.ClearTextOnFocus = false
        trackerInput.ZIndex = 5
        Instance.new("UICorner", trackerInput).CornerRadius = UDim.new(0, 6)

        local trackerAddBtn = Instance.new("TextButton", trkP)
        trackerAddBtn.Size = UDim2.new(0.14, 0, 0, 32)
        trackerAddBtn.Position = UDim2.new(0.68, 0, 0, 55)
        trackerAddBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 40)
        trackerAddBtn.TextColor3 = Color3.fromRGB(200, 255, 200)
        trackerAddBtn.Text = "إضافة"
        trackerAddBtn.TextSize = 10
        trackerAddBtn.Font = Enum.Font.Gotham
        trackerAddBtn.ZIndex = 10
        Instance.new("UICorner", trackerAddBtn).CornerRadius = UDim.new(0, 6)

        local trackerResetBtn = Instance.new("TextButton", trkP)
        trackerResetBtn.Size = UDim2.new(0.14, 0, 0, 32)
        trackerResetBtn.Position = UDim2.new(0.83, 0, 0, 55)
        trackerResetBtn.BackgroundColor3 = Color3.fromRGB(60, 15, 15)
        trackerResetBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
        trackerResetBtn.Text = "تصفير"
        trackerResetBtn.TextSize = 10
        trackerResetBtn.Font = Enum.Font.Gotham
        trackerResetBtn.ZIndex = 10
        Instance.new("UICorner", trackerResetBtn).CornerRadius = UDim.new(0, 6)

        local loggerList = Instance.new("ScrollingFrame", trkP)
        loggerList.Size = UDim2.new(0.92, 0, 0, 440)
        loggerList.Position = UDim2.new(0.04, 0, 0, 100)
        loggerList.BackgroundColor3 = Color3.fromRGB(4, 10, 6)
        loggerList.BackgroundTransparency = 0.4
        loggerList.BorderSizePixel = 0
        loggerList.CanvasSize = UDim2.new(0, 0, 0, 500)
        loggerList.ScrollBarThickness = 3
        loggerList.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 80)
        loggerList.ZIndex = 4
        Instance.new("UICorner", loggerList).CornerRadius = UDim.new(0, 6)
        local listLayout = Instance.new("UIListLayout", loggerList)
        listLayout.Padding = UDim.new(0, 6)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local trackedUsers = {}

        local function formatTime(seconds)
            seconds = math.floor(seconds)
            local m = math.floor(seconds / 60)
            local s = seconds % 60
            return string.format("%02d:%02d", m, s)
        end

        local function createEntry(query, displayName, userId)
            if trackedUsers[query] then return trackedUsers[query] end
            local entry = Instance.new("Frame", loggerList)
            entry.Size = UDim2.new(0.96, 0, 0, 80)
            entry.BackgroundColor3 = Color3.fromRGB(45, 8, 8)
            entry.BackgroundTransparency = 0.05
            entry.BorderSizePixel = 0
            entry.ZIndex = 5
            Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 8)
            local eS = Instance.new("UIStroke", entry)
            eS.Color = Color3.fromRGB(200, 40, 40)
            eS.Thickness = 1.5

            local nameLabel = Instance.new("TextLabel", entry)
            nameLabel.Size = UDim2.new(0.5, 0, 0, 22)
            nameLabel.Position = UDim2.new(0, 8, 0, 5)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Text = displayName
            nameLabel.TextSize = 12
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.ZIndex = 6

            local joinsLabel = Instance.new("TextLabel", entry)
            joinsLabel.Size = UDim2.new(0.5, 0, 0, 20)
            joinsLabel.Position = UDim2.new(0.5, 0, 0, 5)
            joinsLabel.BackgroundTransparency = 1
            joinsLabel.TextColor3 = Color3.fromRGB(50, 255, 100)
            joinsLabel.Text = "دخول: 0 | خروج: 0"
            joinsLabel.TextSize = 10
            joinsLabel.Font = Enum.Font.Gotham
            joinsLabel.TextXAlignment = Enum.TextXAlignment.Left
            joinsLabel.ZIndex = 6

            local infoLabel = Instance.new("TextLabel", entry)
            infoLabel.Size = UDim2.new(0.5, 0, 0, 20)
            infoLabel.Position = UDim2.new(0.5, 0, 0, 30)
            infoLabel.BackgroundTransparency = 1
            infoLabel.TextColor3 = Color3.fromRGB(200, 220, 210)
            infoLabel.Text = "00:00"
            infoLabel.TextSize = 11
            infoLabel.Font = Enum.Font.Code
            infoLabel.TextXAlignment = Enum.TextXAlignment.Left
            infoLabel.ZIndex = 6

            local removeBtn = Instance.new("TextButton", entry)
            removeBtn.Size = UDim2.new(0, 32, 0, 32)
            removeBtn.Position = UDim2.new(1, -42, 1, -40)
            removeBtn.BackgroundColor3 = Color3.fromRGB(100, 15, 15)
            removeBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
            removeBtn.Text = "✕"
            removeBtn.TextSize = 14
            removeBtn.Font = Enum.Font.GothamBold
            removeBtn.ZIndex = 10
            Instance.new("UICorner", removeBtn).CornerRadius = UDim.new(0, 8)

            local data = {entry = entry, nameLabel = nameLabel, joinsLabel = joinsLabel,
                infoLabel = infoLabel, eS = eS, userId = userId,
                joins = 0, leaves = 0, startTime = 0, totalTime = 0, inGame = false}

            removeBtn.MouseButton1Click:Connect(function()
                pcall(function() if entry and entry.Parent then entry:Destroy() end end)
                trackedUsers[query] = nil
            end)
            trackedUsers[query] = data
            return data
        end

        local function updateEntry(query)
            local data = trackedUsers[query]
            if not data or not data.entry or not data.entry.Parent then return end
            local foundPlayer = nil
            local lq = string.lower(query)
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and (string.find(string.lower(plr.Name), lq, 1, true) or string.find(string.lower(plr.DisplayName), lq, 1, true)) then
                    foundPlayer = plr; break
                end
            end
            if foundPlayer then
                if not data.inGame then
                    data.inGame = true; data.startTime = os.time(); data.joins = data.joins + 1
                    sendNotify("📥 دخول", "اللاعب: " .. foundPlayer.Name)
                end
                data.entry.BackgroundColor3 = Color3.fromRGB(8, 35, 18)
                data.eS.Color = Color3.fromRGB(0, 200, 90)
                data.nameLabel.Text = foundPlayer.Name
                data.joinsLabel.Text = "دخول: " .. data.joins .. " | خروج: " .. data.leaves
                data.infoLabel.Text = formatTime(os.time() - data.startTime)
            else
                if data.inGame then
                    data.totalTime = data.totalTime + (os.time() - data.startTime)
                    data.inGame = false; data.leaves = data.leaves + 1
                    sendNotify("📤 خرج لاعب", "اللاعب: " .. query .. " خرج!")
                end
                data.entry.BackgroundColor3 = Color3.fromRGB(45, 8, 8)
                data.eS.Color = Color3.fromRGB(220, 50, 50)
                data.joinsLabel.Text = "دخول: " .. data.joins .. " | خروج: " .. data.leaves
                data.infoLabel.Text = formatTime(data.totalTime)
            end
        end

        local function addQuery(q)
            q = q:gsub("^%s+", ""):gsub("%s+$", "")
            if q == "" then return false end
            if trackedUsers[q] then return false end
            local found = nil
            local lq = string.lower(q)
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and (string.find(string.lower(plr.Name), lq, 1, true) or string.find(string.lower(plr.DisplayName), lq, 1, true)) then
                    found = plr; break
                end
            end
            if found then
                createEntry(q, found.Name, found.UserId); updateEntry(q)
                sendNotify("Tracker", "✅ تم إضافة: " .. found.Name)
            else
                createEntry(q, "[بحث] " .. q, nil); updateEntry(q)
                sendNotify("Tracker", "👁️ مراقبة: " .. q)
            end
            return true
        end

        trackerAddBtn.MouseButton1Click:Connect(function()
            if addQuery(trackerInput.Text) then trackerInput.Text = "" end
        end)

        trackerResetBtn.MouseButton1Click:Connect(function()
            for _, child in ipairs(loggerList:GetChildren()) do
                if child:IsA("Frame") then pcall(function() child:Destroy() end) end
            end
            trackedUsers = {}
        end)

        task.spawn(function()
            while gui.Parent do
                task.wait(1)
                for query, _ in pairs(trackedUsers) do updateEntry(query) end
            end
        end)
    end

    -- EXTRA
    do
        local exT = Instance.new("TextLabel", extP)
        exT.Size = UDim2.new(0.9, 0, 0, 30)
        exT.Position = UDim2.new(0.04, 0, 0, 10)
        exT.BackgroundTransparency = 1
        exT.TextColor3 = Color3.fromRGB(0, 255, 120)
        exT.Text = "[*] أدوات إضافية // extra_tools.py"
        exT.TextSize = 11
        exT.Font = Enum.Font.Gotham
        exT.ZIndex = 4

        local function mkExtra(title, desc, y, link)
            local f = Instance.new("Frame", extP)
            f.Size = UDim2.new(0.92, 0, 0, 100)
            f.Position = UDim2.new(0.04, 0, 0, y)
            f.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
            f.BackgroundTransparency = 0.2
            f.BorderSizePixel = 0
            f.ZIndex = 4
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
            local t = Instance.new("TextLabel", f)
            t.Size = UDim2.new(0.9, 0, 0, 25)
            t.Position = UDim2.new(0.05, 0, 0, 10)
            t.BackgroundTransparency = 1
            t.TextColor3 = Color3.fromRGB(0, 255, 120)
            t.Text = title
            t.TextSize = 11
            t.Font = Enum.Font.Gotham
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.ZIndex = 5
            local d = Instance.new("TextLabel", f)
            d.Size = UDim2.new(0.9, 0, 0, 30)
            d.Position = UDim2.new(0.05, 0, 0, 40)
            d.BackgroundTransparency = 1
            d.TextColor3 = Color3.fromRGB(180, 255, 200)
            d.Text = desc
            d.TextSize = 10
            d.Font = Enum.Font.Gotham
            d.TextXAlignment = Enum.TextXAlignment.Left
            d.ZIndex = 5
            local b = Instance.new("TextButton", f)
            b.Size = UDim2.new(0.35, 0, 0, 28)
            b.Position = UDim2.new(0.05, 0, 0, 65)
            b.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
            b.Text = "تشغيل"
            b.TextColor3 = Color3.fromRGB(200, 255, 200)
            b.Font = Enum.Font.Gotham
            b.TextSize = 11
            b.ZIndex = 10
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            b.MouseButton1Click:Connect(function()
                pcall(function() loadstring(game:HttpGet(link))() end)
            end)
        end

        mkExtra("🚀 TRO FPS", "# تحسين الأداء", 50, "https://pastefy.app/f211Hg4s/raw")
        mkExtra("🤖 AUTO TRO", "# النقر التلقائي", 165, "https://pastefy.app/eY5seATd/raw")
        mkExtra("📻 راديو TRO", "# الراديو", 280, "https://pastefy.app/3i1B279F/raw")
        mkExtra("🔐 تشفير الكلام", "# Multi-Remote", 395, "https://pastefy.app/mszFpYWJ/raw")
    end

    -- 💃 DANCE SYSTEM
    do
        local dncTitle = Instance.new("TextLabel", dncP)
        dncTitle.Size = UDim2.new(0.9, 0, 0, 30)
        dncTitle.Position = UDim2.new(0.04, 0, 0, 10)
        dncTitle.BackgroundTransparency = 1
        dncTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
        dncTitle.Text = "[*] نظام الرقصات // dances.py"
        dncTitle.TextSize = 11
        dncTitle.Font = Enum.Font.Gotham
        dncTitle.TextXAlignment = Enum.TextXAlignment.Left
        dncTitle.ZIndex = 4

        local function playAnim(animId, looped, speed, timePos)
            pcall(function()
                local char = player.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                for _, t in pairs(hum:GetPlayingAnimationTracks()) do
                    pcall(function() t:Stop() end)
                end
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://" .. tostring(animId)
                local track = hum:LoadAnimation(anim)
                track.Priority = Enum.AnimationPriority.Action
                track.Looped = looped or false
                track:Play()
                if timePos then track.TimePosition = timePos end
                if speed then track:AdjustSpeed(speed) end
            end)
        end

        local function checkRig(requiredRig)
            local char = player.Character
            if not char then sendNotify("Animation", "❌ لا توجد شخصية") return false end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return false end
            if hum.RigType.Name ~= requiredRig then
                sendNotify("Animation", "⚠️ يجب أن تكون " .. requiredRig)
                return false
            end
            return true
        end

        local stopAllBtn = Instance.new("TextButton", dncP)
        stopAllBtn.Size = UDim2.new(0.92, 0, 0, 35)
        stopAllBtn.Position = UDim2.new(0.04, 0, 0, 45)
        stopAllBtn.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
        stopAllBtn.Text = "⏹️ إيقاف جميع الرقصات"
        stopAllBtn.TextColor3 = Color3.fromRGB(255, 220, 220)
        stopAllBtn.Font = Enum.Font.GothamBold
        stopAllBtn.TextSize = 11
        stopAllBtn.ZIndex = 10
        Instance.new("UICorner", stopAllBtn).CornerRadius = UDim.new(0, 6)
        local stopStroke = Instance.new("UIStroke", stopAllBtn)
        stopStroke.Color = Color3.fromRGB(255, 100, 100)
        stopStroke.Thickness = 1.2
        stopAllBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    for _, t in pairs(hum:GetPlayingAnimationTracks()) do
                        pcall(function() t:Stop() end)
                    end
                end
                sendNotify("Animation", "✅ تم إيقاف جميع الرقصات")
            end)
        end)

        local r15Lbl = Instance.new("TextLabel", dncP)
        r15Lbl.Size = UDim2.new(0.92, 0, 0, 25)
        r15Lbl.Position = UDim2.new(0.04, 0, 0, 95)
        r15Lbl.BackgroundTransparency = 1
        r15Lbl.TextColor3 = Color3.fromRGB(100, 255, 180)
        r15Lbl.Text = "🟢 رقصات R15"
        r15Lbl.TextSize = 12
        r15Lbl.Font = Enum.Font.GothamBold
        r15Lbl.TextXAlignment = Enum.TextXAlignment.Left
        r15Lbl.ZIndex = 4

        local r15Holder = Instance.new("Frame", dncP)
        r15Holder.Size = UDim2.new(0.92, 0, 0, 175)
        r15Holder.Position = UDim2.new(0.04, 0, 0, 125)
        r15Holder.BackgroundTransparency = 1
        r15Holder.ZIndex = 4

        local r15Grid = Instance.new("UIGridLayout", r15Holder)
        r15Grid.CellSize = UDim2.new(0, 155, 0, 32)
        r15Grid.CellPadding = UDim2.new(0, 8, 0, 6)
        r15Grid.SortOrder = Enum.SortOrder.LayoutOrder
        r15Grid.HorizontalAlignment = Enum.HorizontalAlignment.Left

        local r6Lbl = Instance.new("TextLabel", dncP)
        r6Lbl.Size = UDim2.new(0.92, 0, 0, 25)
        r6Lbl.Position = UDim2.new(0.04, 0, 0, 315)
        r6Lbl.BackgroundTransparency = 1
        r6Lbl.TextColor3 = Color3.fromRGB(255, 200, 100)
        r6Lbl.Text = "🟡 رقصات R6"
        r6Lbl.TextSize = 12
        r6Lbl.Font = Enum.Font.GothamBold
        r6Lbl.TextXAlignment = Enum.TextXAlignment.Left
        r6Lbl.ZIndex = 4

        local r6Holder = Instance.new("Frame", dncP)
        r6Holder.Size = UDim2.new(0.92, 0, 0, 200)
        r6Holder.Position = UDim2.new(0.04, 0, 0, 345)
        r6Holder.BackgroundTransparency = 1
        r6Holder.ZIndex = 4

        local r6Grid = Instance.new("UIGridLayout", r6Holder)
        r6Grid.CellSize = UDim2.new(0, 155, 0, 32)
        r6Grid.CellPadding = UDim2.new(0, 8, 0, 6)
        r6Grid.SortOrder = Enum.SortOrder.LayoutOrder
        r6Grid.HorizontalAlignment = Enum.HorizontalAlignment.Left

        local function makeAnimButton(parent, text, rig, callback)
            local b = Instance.new("TextButton", parent)
            b.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
            b.BackgroundTransparency = 0.3
            b.TextColor3 = Color3.fromRGB(200, 255, 200)
            b.Text = text
            b.TextSize = 10
            b.Font = Enum.Font.Gotham
            b.ZIndex = 10
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", b)
            bs.Thickness = 0.8
            bs.Color = Color3.fromRGB(0, 255, 120)
            b.MouseButton1Click:Connect(function()
                if rig and not checkRig(rig) then return end
                pcall(callback)
                sendNotify("Dance", "💃 " .. text)
            end)
            return b
        end

        makeAnimButton(r15Holder, "تحية (R15)", "R15", function() playAnim("10714389988", false, 0, 1.5) end)
        makeAnimButton(r15Holder, "كلب (R15)", "R15", function() playAnim("13694096724", false, 0, 3.45) end)
        makeAnimButton(r15Holder, "سبعاوي (R15)", "R15", function() playAnim("10214311282", false, 0, 0.8) end)
        makeAnimButton(r15Holder, "زومبي (R15)", "R15", function() playAnim("708553116", true, 1) end)
        makeAnimButton(r15Holder, "لطم (R15)", "R15", function() playAnim("754656200", true, 3) end)
        makeAnimButton(r15Holder, "دولفين (R15)", "R15", function() playAnim("10714068222", true, 2) end)
        makeAnimButton(r15Holder, "نائم (R15)", "R15", function() playAnim("10714360343", false, 0, 0.37) end)
        makeAnimButton(r15Holder, "حضن (R15)", "R15", function() playAnim("10714377090", false, 0, 0.48) end)
        makeAnimButton(r15Holder, "مخبل (R15)", "R15", function() playAnim("10713957138", true, 4) end)
        makeAnimButton(r15Holder, "بعبع (R15)", "R15", function() playAnim("13694096724", false, 0, 2) end)
        makeAnimButton(r15Holder, "رقص عربي (R15)", "R15", function() playAnim("10713981723", true, 2) end)
        makeAnimButton(r15Holder, "رقص هيب هوب (R15)", "R15", function() playAnim("10714010337", true, 2) end)
        makeAnimButton(r15Holder, "رقص روبوت (R15)", "R15", function() playAnim("10714372526", true, 2) end)
        makeAnimButton(r15Holder, "رقص نينجا (R15)", "R15", function() playAnim("10714076981", true, 2) end)
        makeAnimButton(r15Holder, "رقص مجنون (R15)", "R15", function() playAnim("10714392151", true, 2.5) end)
        makeAnimButton(r15Holder, "رقص راب (R15)", "R15", function() playAnim("11444443576", true, 2) end)
        makeAnimButton(r15Holder, "رقص كلاسيك (R15)", "R15", function() playAnim("3333432454", true, 2) end)
        makeAnimButton(r15Holder, "رقص هدوء (R15)", "R15", function() playAnim("4555808220", true, 2) end)

        makeAnimButton(r6Holder, "قطع يد (R6)", "R6", function() playAnim("33169583", false, 0, 0.64) end)
        makeAnimButton(r6Holder, "بوكسات (R6)", "R6", function() playAnim("126753849", true, 3) end)
        makeAnimButton(r6Holder, "نوم (R6)", "R6", function() playAnim("181526230", false, 0, 0.1) end)
        makeAnimButton(r6Holder, "حضن (R6)", "R6", function() playAnim("185299570", false, 0) end)
        makeAnimButton(r6Holder, "بانق (R6)", "R6", function() playAnim("148840371", true, 2.5) end)
        makeAnimButton(r6Holder, "وميض (R6)", "R6", function() playAnim("215384594", true, 7) end)
        makeAnimButton(r6Holder, "مجنون (R6)", "R6", function() playAnim("33796059", true, 10) end)
        makeAnimButton(r6Holder, "راس شنطة (R6)", "R6", function() playAnim("68339848", false, 0, 1) end)
        makeAnimButton(r6Holder, "راس طاير (R6)", "R6", function() playAnim("121572214", false, 0, 1) end)
        makeAnimButton(r6Holder, "رقص 1 (R6)", "R6", function() playAnim("27789359", true, 2) end)
        makeAnimButton(r6Holder, "رقص 2 (R6)", "R6", function() playAnim("30196114", true, 2) end)
        makeAnimButton(r6Holder, "رقص 3 (R6)", "R6", function() playAnim("248263260", true, 2) end)
        makeAnimButton(r6Holder, "رقص 4 (R6)", "R6", function() playAnim("45834924", true, 2) end)
        makeAnimButton(r6Holder, "رقص 5 (R6)", "R6", function() playAnim("52155728", true, 2) end)
        makeAnimButton(r6Holder, "رقص 6 (R6)", "R6", function() playAnim("28488254", true, 2) end)
    end

    -- 🚶 WALK SYSTEM
    do
        local wlkTitle = Instance.new("TextLabel", wlkP)
        wlkTitle.Size = UDim2.new(0.9, 0, 0, 30)
        wlkTitle.Position = UDim2.new(0.04, 0, 0, 10)
        wlkTitle.BackgroundTransparency = 1
        wlkTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
        wlkTitle.Text = "[*] نظام المشيات // walks.py"
        wlkTitle.TextSize = 11
        wlkTitle.Font = Enum.Font.Gotham
        wlkTitle.TextXAlignment = Enum.TextXAlignment.Left
        wlkTitle.ZIndex = 4

        local function setWalkAnim(walkId, runId, jumpId, fallId, climbId)
            pcall(function()
                local char = player.Character
                if not char then sendNotify("Walk", "❌ لا توجد شخصية") return end
                local animate = char:FindFirstChild("Animate")
                if not animate then sendNotify("Walk", "❌ لا يوجد Animate") return end

                local function toId(id)
                    if not id then return nil end
                    local s = tostring(id)
                    if s:find("rbxasset") then return s end
                    return "rbxassetid://" .. s
                end
                local function applyVal(name, id)
                    if not id then return end
                    local val = animate:FindFirstChild(name)
                    if not val then
                        val = Instance.new("StringValue")
                        val.Name = name
                        val.Parent = animate
                    end
                    val.Value = toId(id)
                end

                applyVal("walk", walkId)
                applyVal("run", runId or walkId)
                applyVal("jump", jumpId or walkId)
                applyVal("fall", fallId or walkId)
                applyVal("climb", climbId or walkId)

                local oldScript = animate
                local newScript = oldScript:Clone()
                newScript.Name = "Animate"
                newScript.Parent = char

                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local animator = hum:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                            pcall(function() track:Stop(0) end)
                        end
                    end
                end

                task.wait(0.05)
                if oldScript and oldScript.Parent then oldScript:Destroy() end
                task.wait(0.05)
                if newScript and newScript.Parent then
                    newScript.Disabled = true
                    task.wait(0.02)
                    newScript.Disabled = false
                end
            end)
        end

        local function resetWalk()
            pcall(function()
                local char = player.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local isR15 = hum.RigType == Enum.HumanoidRigType.R15
                local defaults
                if isR15 then
                    defaults = {
                        walk = "rbxassetid://507777826",
                        run = "rbxassetid://507767714",
                        jump = "rbxassetid://507765000",
                        fall = "rbxassetid://507767968",
                        climb = "rbxassetid://507765644"
                    }
                else
                    defaults = {
                        walk = "rbxassetid://180426354",
                        run = "rbxassetid://180426354",
                        jump = "rbxassetid://125750702",
                        fall = "rbxassetid://180436148",
                        climb = "rbxassetid://180436334"
                    }
                end
                local animate = char:FindFirstChild("Animate")
                if not animate then return end
                for name, id in pairs(defaults) do
                    local val = animate:FindFirstChild(name)
                    if not val then
                        val = Instance.new("StringValue")
                        val.Name = name
                        val.Parent = animate
                    end
                    val.Value = id
                end
                local oldScript = animate
                local newScript = oldScript:Clone()
                newScript.Parent = char
                if hum then
                    local animator = hum:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                            pcall(function() track:Stop(0) end)
                        end
                    end
                end
                task.wait(0.05)
                if oldScript and oldScript.Parent then oldScript:Destroy() end
                task.wait(0.05)
                if newScript and newScript.Parent then
                    newScript.Disabled = true
                    task.wait(0.02)
                    newScript.Disabled = false
                end
            end)
        end

        local resetWalkBtn = Instance.new("TextButton", wlkP)
        resetWalkBtn.Size = UDim2.new(0.92, 0, 0, 35)
        resetWalkBtn.Position = UDim2.new(0.04, 0, 0, 45)
        resetWalkBtn.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
        resetWalkBtn.Text = "🔄 إرجاع المشية الافتراضية"
        resetWalkBtn.TextColor3 = Color3.fromRGB(255, 220, 220)
        resetWalkBtn.Font = Enum.Font.GothamBold
        resetWalkBtn.TextSize = 11
        resetWalkBtn.ZIndex = 10
        Instance.new("UICorner", resetWalkBtn).CornerRadius = UDim.new(0, 6)
        local resetStroke = Instance.new("UIStroke", resetWalkBtn)
        resetStroke.Color = Color3.fromRGB(255, 100, 100)
        resetStroke.Thickness = 1.2
        resetWalkBtn.MouseButton1Click:Connect(function()
            resetWalk()
            sendNotify("Walk", "✅ تم إرجاع المشية الافتراضية")
        end)

        local wR15Lbl = Instance.new("TextLabel", wlkP)
        wR15Lbl.Size = UDim2.new(0.92, 0, 0, 25)
        wR15Lbl.Position = UDim2.new(0.04, 0, 0, 95)
        wR15Lbl.BackgroundTransparency = 1
        wR15Lbl.TextColor3 = Color3.fromRGB(100, 255, 180)
        wR15Lbl.Text = "🟢 مشيات R15"
        wR15Lbl.TextSize = 12
        wR15Lbl.Font = Enum.Font.GothamBold
        wR15Lbl.TextXAlignment = Enum.TextXAlignment.Left
        wR15Lbl.ZIndex = 4

        local wR15Holder = Instance.new("Frame", wlkP)
        wR15Holder.Size = UDim2.new(0.92, 0, 0, 250)
        wR15Holder.Position = UDim2.new(0.04, 0, 0, 125)
        wR15Holder.BackgroundTransparency = 1
        wR15Holder.ZIndex = 4

        local wR15Grid = Instance.new("UIGridLayout", wR15Holder)
        wR15Grid.CellSize = UDim2.new(0, 155, 0, 32)
        wR15Grid.CellPadding = UDim2.new(0, 8, 0, 6)
        wR15Grid.SortOrder = Enum.SortOrder.LayoutOrder
        wR15Grid.HorizontalAlignment = Enum.HorizontalAlignment.Left

        local wR6Lbl = Instance.new("TextLabel", wlkP)
        wR6Lbl.Size = UDim2.new(0.92, 0, 0, 25)
        wR6Lbl.Position = UDim2.new(0.04, 0, 0, 390)
        wR6Lbl.BackgroundTransparency = 1
        wR6Lbl.TextColor3 = Color3.fromRGB(255, 200, 100)
        wR6Lbl.Text = "🟡 مشيات R6"
        wR6Lbl.TextSize = 12
        wR6Lbl.Font = Enum.Font.GothamBold
        wR6Lbl.TextXAlignment = Enum.TextXAlignment.Left
        wR6Lbl.ZIndex = 4

        local wR6Holder = Instance.new("Frame", wlkP)
        wR6Holder.Size = UDim2.new(0.92, 0, 0, 200)
        wR6Holder.Position = UDim2.new(0.04, 0, 0, 420)
        wR6Holder.BackgroundTransparency = 1
        wR6Holder.ZIndex = 4

        local wR6Grid = Instance.new("UIGridLayout", wR6Holder)
        wR6Grid.CellSize = UDim2.new(0, 155, 0, 32)
        wR6Grid.CellPadding = UDim2.new(0, 8, 0, 6)
        wR6Grid.SortOrder = Enum.SortOrder.LayoutOrder
        wR6Grid.HorizontalAlignment = Enum.HorizontalAlignment.Left

        local function makeWalkButton(parent, text, rig, walkId, runId, jumpId, fallId, climbId)
            local b = Instance.new("TextButton", parent)
            b.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
            b.BackgroundTransparency = 0.3
            b.TextColor3 = Color3.fromRGB(200, 255, 200)
            b.Text = text
            b.TextSize = 10
            b.Font = Enum.Font.Gotham
            b.ZIndex = 10
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", b)
            bs.Thickness = 0.8
            bs.Color = Color3.fromRGB(0, 255, 120)
            b.MouseButton1Click:Connect(function()
                if rig then
                    local char = player.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if not hum then return end
                    if hum.RigType.Name ~= rig then
                        sendNotify("Walk", "⚠️ يجب أن تكون " .. rig)
                        return
                    end
                end
                setWalkAnim(walkId, runId, jumpId, fallId, climbId)
                sendNotify("Walk", "🚶 " .. text)
            end)
            return b
        end

        makeWalkButton(wR15Holder, "مشية عادية (R15)", "R15", "507777826", "507767714", "507765000", "507767968", "507765644")
        makeWalkButton(wR15Holder, "مشية زومبي (R15)", "R15", "10921343239", "10921343239", "10921343239", "10921343239", "10921343239")
        makeWalkButton(wR15Holder, "مشية نينجا (R15)", "R15", "750781874", "750782230", "750780569", "750781181", "750779570")
        makeWalkButton(wR15Holder, "مشية زاحف (R15)", "R15", "10921519104", "10921519104", "10921519104", "10921519104", "10921519104")
        makeWalkButton(wR15Holder, "مشية سبعاوي (R15)", "R15", "10214311282", "10214311282", "10214311282", "10214311282", "10214311282")
        makeWalkButton(wR15Holder, "مشية دلع (R15)", "R15", "10921530266", "10921530266", "10921530266", "10921530266", "10921530266")
        makeWalkButton(wR15Holder, "مشية مخبل (R15)", "R15", "10713957138", "10713957138", "10713957138", "10713957138", "10713957138")
        makeWalkButton(wR15Holder, "مشية نائم (R15)", "R15", "10714360343", "10714360343", "10714360343", "10714360343", "10714360343")
        makeWalkButton(wR15Holder, "مشية كرتوني (R15)", "R15", "10921615274", "10921615274", "10921615274", "10921615274", "10921615274")
        makeWalkButton(wR15Holder, "مشية ملكي (R15)", "R15", "10713981723", "10713981723", "10713981723", "10713981723", "10713981723")
        makeWalkButton(wR15Holder, "مشية هيب هوب (R15)", "R15", "10714372526", "10714372526", "10714372526", "10714372526", "10714372526")
        makeWalkButton(wR15Holder, "مشية روبوت (R15)", "R15", "10714076981", "10714076981", "10714076981", "10714076981", "10714076981")

        makeWalkButton(wR6Holder, "مشية عادية (R6)", "R6", "180426354", "180426354", "125750702", "180436148", "180436334")
        makeWalkButton(wR6Holder, "مشية زومبي (R6)", "R6", "10921343239", "10921343239", "125750702", "180436148", "180436334")
        makeWalkButton(wR6Holder, "مشية عرجة (R6)", "R6", "180435571", "180435571", "180435792", "180435792", "180435792")
        makeWalkButton(wR6Holder, "مشية مجنون (R6)", "R6", "33796059", "33796059", "33796059", "33796059", "33796059")
        makeWalkButton(wR6Holder, "مشية دلع (R6)", "R6", "27789359", "27789359", "27789359", "27789359", "27789359")
        makeWalkButton(wR6Holder, "مشية مريض (R6)", "R6", "215384594", "215384594", "215384594", "215384594", "215384594")
    end

    -- 🔒 TRO SHIELD PAGE (مع Toggle Switch)
    do
        local shieldTitle = Instance.new("TextLabel", shieldP)
        shieldTitle.Size = UDim2.new(0.9, 0, 0, 30)
        shieldTitle.Position = UDim2.new(0.04, 0, 0, 10)
        shieldTitle.BackgroundTransparency = 1
        shieldTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
        shieldTitle.Text = "[*] TRO Shield // shield.py"
        shieldTitle.TextSize = 11
        shieldTitle.Font = Enum.Font.Gotham
        shieldTitle.TextXAlignment = Enum.TextXAlignment.Left
        shieldTitle.ZIndex = 4

        local activeConns = {}
        local openWindows = {}

        local function makeProtWindow(protName, protDesc, onToggle)
            if openWindows[protName] and openWindows[protName].Parent then
                openWindows[protName]:Destroy()
                openWindows[protName] = nil
                return
            end

            local win = Instance.new("Frame")
            win.Name = "TRO_ProtWin"
            win.Size = UDim2.new(0, 360, 0, 260)
            win.Position = UDim2.new(0.5, -180, 0.5, -130)
            win.BackgroundColor3 = Color3.fromRGB(6, 14, 9)
            win.BorderSizePixel = 0
            win.ZIndex = 200
            win.Active = true
            win.Parent = main
            Instance.new("UICorner", win).CornerRadius = UDim.new(0, 12)
            local ws = Instance.new("UIStroke", win)
            ws.Color = Color3.fromRGB(0, 255, 120)
            ws.Thickness = 2

            local titleBar = Instance.new("Frame", win)
            titleBar.Size = UDim2.new(1, 0, 0, 42)
            titleBar.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
            titleBar.BorderSizePixel = 0
            titleBar.ZIndex = 201
            Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

            local titleLbl = Instance.new("TextLabel", titleBar)
            titleLbl.Size = UDim2.new(1, -55, 1, 0)
            titleLbl.Position = UDim2.new(0, 15, 0, 0)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Text = "🛡️ " .. protName
            titleLbl.TextColor3 = Color3.fromRGB(0, 255, 120)
            titleLbl.Font = Enum.Font.GothamBold
            titleLbl.TextSize = 14
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.ZIndex = 202

            local closeX = Instance.new("TextButton", titleBar)
            closeX.Size = UDim2.new(0, 30, 0, 30)
            closeX.Position = UDim2.new(1, -37, 0, 6)
            closeX.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
            closeX.Text = "X"
            closeX.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeX.Font = Enum.Font.GothamBold
            closeX.TextSize = 14
            closeX.AutoButtonColor = false
            closeX.ZIndex = 202
            Instance.new("UICorner", closeX).CornerRadius = UDim.new(0, 6)
            closeX.MouseButton1Click:Connect(function()
                win:Destroy()
                openWindows[protName] = nil
            end)

            local descLbl = Instance.new("TextLabel", win)
            descLbl.Size = UDim2.new(1, -40, 0, 60)
            descLbl.Position = UDim2.new(0, 20, 0, 55)
            descLbl.BackgroundTransparency = 1
            descLbl.Text = protDesc
            descLbl.TextColor3 = Color3.fromRGB(180, 255, 200)
            descLbl.Font = Enum.Font.Gotham
            descLbl.TextSize = 12
            descLbl.TextWrapped = true
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.TextYAlignment = Enum.TextYAlignment.Top
            descLbl.ZIndex = 201

            local statusBox = Instance.new("Frame", win)
            statusBox.Size = UDim2.new(1, -40, 0, 35)
            statusBox.Position = UDim2.new(0, 20, 0, 128)
            statusBox.BackgroundColor3 = Color3.fromRGB(15, 25, 20)
            statusBox.BorderSizePixel = 0
            statusBox.ZIndex = 201
            Instance.new("UICorner", statusBox).CornerRadius = UDim.new(0, 8)
            local sbStroke = Instance.new("UIStroke", statusBox)
            sbStroke.Color = Color3.fromRGB(80, 40, 40)
            sbStroke.Thickness = 1

            local statusDot = Instance.new("Frame", statusBox)
            statusDot.Size = UDim2.new(0, 12, 0, 12)
            statusDot.Position = UDim2.new(0, 12, 0.5, -6)
            statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            statusDot.BorderSizePixel = 0
            statusDot.ZIndex = 202
            Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

            local statusLbl = Instance.new("TextLabel", statusBox)
            statusLbl.Size = UDim2.new(1, -40, 1, 0)
            statusLbl.Position = UDim2.new(0, 32, 0, 0)
            statusLbl.BackgroundTransparency = 1
            statusLbl.Text = "الحالة: ⛔ معطلة"
            statusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
            statusLbl.Font = Enum.Font.GothamBold
            statusLbl.TextSize = 12
            statusLbl.TextXAlignment = Enum.TextXAlignment.Left
            statusLbl.ZIndex = 202

            -- ═══ Toggle Switch ═══
            local toggleRow = Instance.new("Frame", win)
            toggleRow.Size = UDim2.new(1, -40, 0, 50)
            toggleRow.Position = UDim2.new(0, 20, 1, -62)
            toggleRow.BackgroundTransparency = 1
            toggleRow.ZIndex = 201

            local toggleLbl = Instance.new("TextLabel", toggleRow)
            toggleLbl.Size = UDim2.new(0.55, 0, 1, 0)
            toggleLbl.Position = UDim2.new(0, 0, 0, 0)
            toggleLbl.BackgroundTransparency = 1
            toggleLbl.Text = "▶️ تشغيل الحماية"
            toggleLbl.TextColor3 = Color3.fromRGB(200, 255, 200)
            toggleLbl.Font = Enum.Font.GothamBold
            toggleLbl.TextSize = 13
            toggleLbl.TextXAlignment = Enum.TextXAlignment.Left
            toggleLbl.ZIndex = 202

            local toggleFrame = Instance.new("Frame", toggleRow)
            toggleFrame.Size = UDim2.new(0, 70, 0, 34)
            toggleFrame.Position = UDim2.new(1, -70, 0.5, -17)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 15, 15)
            toggleFrame.BorderSizePixel = 0
            toggleFrame.ZIndex = 201
            Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)
            local tfStroke = Instance.new("UIStroke", toggleFrame)
            tfStroke.Color = Color3.fromRGB(255, 100, 100)
            tfStroke.Thickness = 1.5

            local toggleCircle = Instance.new("Frame", toggleFrame)
            toggleCircle.Size = UDim2.new(0, 26, 0, 26)
            toggleCircle.Position = UDim2.new(0, 4, 0.5, -13)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0
            toggleCircle.ZIndex = 202
            Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)

            local toggleBtn = Instance.new("TextButton", toggleFrame)
            toggleBtn.Size = UDim2.new(1, 0, 1, 0)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.ZIndex = 203

            local isOn = activeConns[protName] ~= nil

            local function updateUI()
                if isOn then
                    toggleLbl.Text = "✅ الحماية مفعلة"
                    toggleLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
                    toggleFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
                    tfStroke.Color = Color3.fromRGB(0, 255, 100)
                    statusLbl.Text = "الحالة: ✅ مفعلة وتعمل"
                    statusLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
                    statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                    sbStroke.Color = Color3.fromRGB(0, 150, 80)
                    TS:Create(toggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = UDim2.new(1, -30, 0.5, -13)
                    }):Play()
                else
                    toggleLbl.Text = "▶️ تشغيل الحماية"
                    toggleLbl.TextColor3 = Color3.fromRGB(200, 255, 200)
                    toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 15, 15)
                    tfStroke.Color = Color3.fromRGB(255, 100, 100)
                    statusLbl.Text = "الحالة: ⛔ معطلة"
                    statusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
                    statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
                    sbStroke.Color = Color3.fromRGB(80, 40, 40)
                    TS:Create(toggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0, 4, 0.5, -13)
                    }):Play()
                end
            end

            updateUI()

            toggleBtn.MouseButton1Click:Connect(function()
                if isOn then
                    if activeConns[protName] then
                        pcall(function() activeConns[protName]:Disconnect() end)
                        activeConns[protName] = nil
                    end
                    isOn = false
                    sendNotify("TRO Shield", "⛔ " .. protName .. " - OFF")
                else
                    local c = onToggle()
                    if c then activeConns[protName] = c end
                    isOn = true
                    sendNotify("TRO Shield", "✅ " .. protName .. " - ON")
                end
                updateUI()
            end)

            local dragStart = nil
            local startPos = nil
            titleBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragStart = input.Position
                    startPos = win.Position
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragStart = nil
                end
            end)

            openWindows[protName] = win
        end

        local protIdx = 0
        local function makeProtCard(title, desc)
            protIdx = protIdx + 1
            local y = 45 + (protIdx - 1) * 100
            local card = Instance.new("Frame", shieldP)
            card.Size = UDim2.new(0.92, 0, 0, 90)
            card.Position = UDim2.new(0.04, 0, 0, y)
            card.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
            card.BackgroundTransparency = 0.3
            card.BorderSizePixel = 0
            card.ZIndex = 4
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
            local cs = Instance.new("UIStroke", card)
            cs.Color = Color3.fromRGB(0, 255, 120)
            cs.Thickness = 1

            local t = Instance.new("TextLabel", card)
            t.Size = UDim2.new(0.68, 0, 0, 22)
            t.Position = UDim2.new(0, 12, 0, 8)
            t.BackgroundTransparency = 1
            t.TextColor3 = Color3.fromRGB(0, 255, 120)
            t.Text = title
            t.Font = Enum.Font.GothamBold
            t.TextSize = 11
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.ZIndex = 5

            local d = Instance.new("TextLabel", card)
            d.Size = UDim2.new(0.68, 0, 0, 40)
            d.Position = UDim2.new(0, 12, 0, 34)
            d.BackgroundTransparency = 1
            d.TextColor3 = Color3.fromRGB(180, 255, 200)
            d.Text = desc
            d.TextSize = 9
            d.Font = Enum.Font.Gotham
            d.TextXAlignment = Enum.TextXAlignment.Left
            d.TextYAlignment = Enum.TextYAlignment.Top
            d.TextWrapped = true
            d.ZIndex = 5

            local b = Instance.new("TextButton", card)
            b.Size = UDim2.new(0, 90, 0, 32)
            b.Position = UDim2.new(1, -104, 0.5, -16)
            b.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
            b.Text = "فتح 🛡️"
            b.TextColor3 = Color3.fromRGB(200, 255, 200)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 11
            b.AutoButtonColor = false
            b.ZIndex = 10
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", b)
            bs.Color = Color3.fromRGB(0, 255, 120)
            bs.Thickness = 1.3

            return b
        end

        local b1 = makeProtCard("💥 مضاد الانفجارات", "يمنع الانفجارات من قتلك أو رميك")
        b1.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد الانفجارات", "يمنع أي انفجار من التأثير عليك عن طريق تصفير قوته وتدميره فوراً.", function()
                return workspace.DescendantAdded:Connect(function(obj)
                    if obj:IsA("Explosion") then
                        pcall(function()
                            obj.BlastPressure = 0
                            obj.BlastRadius = 0
                        end)
                        task.defer(function() pcall(function() obj:Destroy() end) end)
                    end
                end)
            end)
        end)

        local b2 = makeProtCard("🔥 مضاد إعادة الانفجار", "يمنع إعادة تشغيل الانفجارات عليك")
        b2.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد إعادة الانفجار", "يمنع أي محاولة لإعادة تفعيل الانفجارات على شخصيتك بشكل متكرر.", function()
                return workspace.DescendantAdded:Connect(function(obj)
                    if obj:IsA("Explosion") then
                        task.defer(function() pcall(function() obj:Destroy() end) end)
                    end
                end)
            end)
        end)

        local b3 = makeProtCard("🌌 مضاد السكاي بوكس", "يمنع تغيير السماء والألوان")
        b3.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد السكاي بوكس", "يمنع أي شخص من تغيير سماء اللعبة أو إضافة تأثيرات بصرية مزعجة.", function()
                return game:GetService("Lighting").DescendantAdded:Connect(function(obj)
                    if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("ColorCorrectionEffect") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") then
                        task.defer(function() pcall(function() obj:Destroy() end) end)
                    end
                end)
            end)
        end)

        local b4 = makeProtCard("🌀 مضاد الفلنق", "يمنع فلنق شخصيتك من اللاعبين")
        b4.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد الفلنق", "يمنع أي شخص من فلنقك عن طريق إعادة موقعك وإلغاء السرعات العالية.", function()
                local lastCF
                local hrp = getHRP()
                if hrp then lastCF = hrp.CFrame end
                return Run.Heartbeat:Connect(function()
                    local h = getHRP()
                    if not h then return end
                    if h.AssemblyLinearVelocity.Magnitude > 250 then
                        h.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        h.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        if lastCF then h.CFrame = lastCF end
                        clearBodyMovers(h)
                    else
                        lastCF = h.CFrame
                    end
                end)
            end)
        end)

        local b5 = makeProtCard("⚡ مضاد التليفورت", "يمنع تليفورتك قسرياً بعيداً")
        b5.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد التليفورت", "يمنع أي شخص من تليفورتك بعيد عن موقعك عن طريق إرجاعك تلقائياً.", function()
                local lastPos
                local hrp = getHRP()
                if hrp then lastPos = hrp.Position end
                return Run.Heartbeat:Connect(function()
                    local h = getHRP()
                    if not h or not lastPos then return end
                    if (h.Position - lastPos).Magnitude > 80 then
                        h.CFrame = CFrame.new(lastPos)
                        h.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    else
                        lastPos = h.Position
                    end
                end)
            end)
        end)

        local b6 = makeProtCard("🚫 مضاد البانق", "يمنع جلوسك القسري (Bang)")
        b6.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد البانق", "يمنع أي شخص من عمل بانق عليك عن طريق كشف الجلوس القسري وإلغائه.", function()
                return Run.Heartbeat:Connect(function()
                    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Sit then
                        hum.Sit = false
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end)
            end)
        end)

        local b7 = makeProtCard("💺 مضاد الجلوس", "يمنع أي إجبار على الجلوس")
        b7.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد الجلوس", "يمنع أي محاولة لإجبارك على الجلوس على أي كرسي أو أداة.", function()
                return Run.Heartbeat:Connect(function()
                    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Sit then hum.Sit = false end
                end)
            end)
        end)

        local b8 = makeProtCard("👤 مضاد تغيير السكن", "يمنع تغيير شكل شخصيتك")
        b8.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد تغيير السكن", "يمنع أي شخص من تغيير ملابسك أو شكل شخصيتك عن طريق استعادة الوصف الأصلي.", function()
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                local origDesc
                pcall(function()
                    if hum then origDesc = hum:GetAppliedDescription() end
                end)
                return player.CharacterAdded:Connect(function(char)
                    task.wait(1)
                    pcall(function()
                        if origDesc then
                            local h = char:FindFirstChildOfClass("Humanoid")
                            if h then h:ApplyDescription(origDesc) end
                        end
                    end)
                end)
            end)
        end)

        local b9 = makeProtCard("🎯 مضاد الاستهداف", "يبعد أي شخص يقترب منك بمسافة خطر")
        b9.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد الاستهداف", "يبعد تلقائياً أي لاعب يقترب منك لمسافة قريبة جداً (أقل من 4 استد).", function()
                return Run.Heartbeat:Connect(function()
                    local myHRP = getHRP()
                    if not myHRP then return end
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= player and p.Character then
                            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                            if tHRP then
                                local dist = (myHRP.Position - tHRP.Position).Magnitude
                                if dist < 4 and dist > 0.1 then
                                    tHRP.CFrame = tHRP.CFrame + (tHRP.Position - myHRP.Position).Unit * 4
                                end
                            end
                        end
                    end
                end)
            end)
        end)

        local b10 = makeProtCard("📝 مضاد التسجيل", "يحمي حسابك من السجلات")
        b10.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد التسجيل", "يمنع السكربتات الأخرى من تسجيل معلومات حسابك أو مراقبة تحركاتك.", function()
                return Run.Heartbeat:Connect(function() end)
            end)
        end)

        local b11 = makeProtCard("📋 مضاد سبام النسخ", "يمنع سبام النسخ على شاشتك")
        b11.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد سبام النسخ", "يمنع أي شخص من عمل سبام على Ctrl+C أو حجب شاشتك بالنسخ المتكرر.", function()
                return UIS.InputBegan:Connect(function(input, gp)
                    if gp then return end
                    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
                        -- blocked
                    end
                end)
            end)
        end)

        local b12 = makeProtCard("🕐 مضاد AFK", "يمنع طردك بسبب عدم الحركة")
        b12.MouseButton1Click:Connect(function()
            makeProtWindow("مضاد AFK", "يمنع طردك من السيرفر بسبب عدم الحركة لمدة 20 دقيقة عن طريق محاكاة النشاط.", function()
                local vu = game:GetService("VirtualUser")
                return player.Idled:Connect(function()
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                end)
            end)
        end)

        local infoA = Instance.new("TextLabel", shieldP)
        infoA.Size = UDim2.new(0.92, 0, 0, 45)
        infoA.Position = UDim2.new(0.04, 0, 0, 45 + 12 * 100 + 10)
        infoA.BackgroundColor3 = Color3.fromRGB(15, 30, 18)
        infoA.BackgroundTransparency = 0.4
        infoA.BorderSizePixel = 0
        infoA.Text = "💡 اضغط 'فتح 🛡️' لتظهر نافذة الحماية\nمن داخل النافذة فعّل الحماية بالـ Toggle Switch — يمكن سحب النافذة"
        infoA.TextColor3 = Color3.fromRGB(150, 255, 180)
        infoA.Font = Enum.Font.Gotham
        infoA.TextSize = 9
        infoA.TextWrapped = true
        infoA.TextYAlignment = Enum.TextYAlignment.Center
        infoA.ZIndex = 4
        Instance.new("UICorner", infoA).CornerRadius = UDim.new(0, 6)
    end

    -- ⚔️ TRO SABOTAGE PAGE
    do
        local atkTitle = Instance.new("TextLabel", atkP)
        atkTitle.Size = UDim2.new(0.9, 0, 0, 30)
        atkTitle.Position = UDim2.new(0.04, 0, 0, 10)
        atkTitle.BackgroundTransparency = 1
        atkTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
        atkTitle.Text = "[*] TRO Sabotage // sabotage.py"
        atkTitle.TextSize = 11
        atkTitle.Font = Enum.Font.Gotham
        atkTitle.TextXAlignment = Enum.TextXAlignment.Left
        atkTitle.ZIndex = 4

        local atkIdx = 0
        local function makeAtkCard(title, desc)
            atkIdx = atkIdx + 1
            local y = 45 + (atkIdx - 1) * 100
            local card = Instance.new("Frame", atkP)
            card.Size = UDim2.new(0.92, 0, 0, 90)
            card.Position = UDim2.new(0.04, 0, 0, y)
            card.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
            card.BackgroundTransparency = 0.3
            card.BorderSizePixel = 0
            card.ZIndex = 4
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
            local cs = Instance.new("UIStroke", card)
            cs.Color = Color3.fromRGB(0, 255, 120)
            cs.Thickness = 1

            local t = Instance.new("TextLabel", card)
            t.Size = UDim2.new(0.68, 0, 0, 22)
            t.Position = UDim2.new(0, 12, 0, 8)
            t.BackgroundTransparency = 1
            t.TextColor3 = Color3.fromRGB(0, 255, 120)
            t.Text = title
            t.Font = Enum.Font.GothamBold
            t.TextSize = 11
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.ZIndex = 5

            local d = Instance.new("TextLabel", card)
            d.Size = UDim2.new(0.68, 0, 0, 40)
            d.Position = UDim2.new(0, 12, 0, 34)
            d.BackgroundTransparency = 1
            d.TextColor3 = Color3.fromRGB(180, 255, 200)
            d.Text = desc
            d.TextSize = 9
            d.Font = Enum.Font.Gotham
            d.TextXAlignment = Enum.TextXAlignment.Left
            d.TextYAlignment = Enum.TextYAlignment.Top
            d.TextWrapped = true
            d.ZIndex = 5

            local b = Instance.new("TextButton", card)
            b.Size = UDim2.new(0, 90, 0, 32)
            b.Position = UDim2.new(1, -104, 0.5, -16)
            b.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
            b.Text = "تشغيل"
            b.TextColor3 = Color3.fromRGB(200, 255, 200)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 11
            b.ZIndex = 10
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", b)
            bs.Color = Color3.fromRGB(0, 255, 120)
            bs.Thickness = 1.3

            return b, bs
        end

        local atk1, s1 = makeAtkCard("🌌 سكاي بوكس TRO", "يغير سماء اللعبة لسماء نيون مميزة")
        atk1.MouseButton1Click:Connect(function()
            pcall(function()
                local L = game:GetService("Lighting")
                for _, obj in ipairs(L:GetChildren()) do
                    if obj:IsA("Sky") or obj:IsA("Atmosphere") then obj:Destroy() end
                end
                local sky = Instance.new("Sky")
                sky.SkyboxBk = "rbxassetid://159454299"
                sky.SkyboxDn = "rbxassetid://159454296"
                sky.SkyboxFt = "rbxassetid://159454293"
                sky.SkyboxLf = "rbxassetid://159454286"
                sky.SkyboxRt = "rbxassetid://159454300"
                sky.SkyboxUp = "rbxassetid://159454288"
                sky.StarCount = 5000
                sky.SunAngularSize = 21
                sky.MoonAngularSize = 12
                sky.Parent = L
                local atmos = Instance.new("Atmosphere")
                atmos.Density = 0.4
                atmos.Offset = 0.25
                atmos.Color = Color3.fromRGB(199, 170, 255)
                atmos.Decay = Color3.fromRGB(106, 112, 125)
                atmos.Glare = 0.3
                atmos.Haze = 1.2
                atmos.Parent = L
                sendNotify("TRO Skybox", "✅ تم تفعيل السكاي بوكس")
            end)
            atk1.Text = "تم ✓"
            task.delay(2, function() atk1.Text = "تشغيل" end)
        end)

        local atk2, s2 = makeAtkCard("🎨 تخريب لوحات الرسم", "يحذف كل لوحات الرسم والصور في الماب")
        atk2.MouseButton1Click:Connect(function()
            local destroyed = 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    if obj.Name:lower():find("draw") or obj.Name:lower():find("paint") or obj.Name:lower():find("picture") or obj.Name:lower():find("image") or obj.Name:lower():find("canvas") or obj.Name:lower():find("لوح") or obj.Name:lower():find("رسم") then
                        pcall(function() obj:Destroy() end)
                        destroyed = destroyed + 1
                    end
                end
            end
            sendNotify("TRO Sabotage", "✅ تم حذف " .. destroyed .. " لوحة")
            atk2.Text = "تم ✓"
            task.delay(2, function() atk2.Text = "تشغيل" end)
        end)

        local atk3, s3 = makeAtkCard("💬 سبام شات الماب", "يرسل رسالة كل 0.1 ثانية للشات")
        local spammingChat = false
        atk3.MouseButton1Click:Connect(function()
            if spammingChat then
                spammingChat = false
                atk3.Text = "تشغيل"
                atk3.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
                sendNotify("TRO", "⛔ تم إيقاف سبام الشات")
            else
                spammingChat = true
                atk3.Text = "إيقاف"
                atk3.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
                sendNotify("TRO", "🔥 بدء سبام الشات")
                task.spawn(function()
                    local msgs = {"TRO ON TOP", "TRO WAS HERE", "سـجّـاد عمك", "TRO RULES", "🔥🔥🔥 TRO 🔥🔥🔥"}
                    while spammingChat do
                        task.wait(0.1)
                        pcall(function()
                            local msg = msgs[math.random(1, #msgs)]
                            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
                        end)
                    end
                end)
            end
        end)

        local atk4, s4 = makeAtkCard("💥 بانق اللاعبين القريبين", "يبانق أي لاعب قريب منك")
        local banging = false
        atk4.MouseButton1Click:Connect(function()
            if banging then
                banging = false
                atk4.Text = "تشغيل"
                atk4.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
                sendNotify("TRO", "⛔ تم إيقاف البانق")
            else
                banging = true
                atk4.Text = "إيقاف"
                atk4.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
                sendNotify("TRO", "💥 بدء بانق اللاعبين")
                task.spawn(function()
                    while banging do
                        task.wait(0.05)
                        local myHRP = getHRP()
                        if not myHRP then break end
                        local myChar = player.Character
                        if not myChar then break end
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= player and p.Character then
                                local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                                if tHRP then
                                    local dist = (myHRP.Position - tHRP.Position).Magnitude
                                    if dist < 15 then
                                        pcall(function()
                                            if myChar:FindFirstChildOfClass("Humanoid") then
                                                myChar.Humanoid.Sit = true
                                                myHRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, 1) * CFrame.Angles(0, math.pi, 0)
                                                myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                    if player.Character then
                        local h = player.Character:FindFirstChildOfClass("Humanoid")
                        if h then h.Sit = false end
                    end
                end)
            end
        end)

        local atk5, s5 = makeAtkCard("🚀 تحسين الأداء (FPS)", "يحذف المؤثرات ويرفع الفريمات")
        atk5.MouseButton1Click:Connect(function()
            pcall(function()
                local L = game:GetService("Lighting")
                L.GlobalShadows = false
                L.FogEnd = 100000
                L.Brightness = 1
                pcall(function() settings().Rendering.QualityLevel = 1 end)
                for _, d in ipairs(L:GetChildren()) do
                    if d:IsA("PostEffect") or d:IsA("Atmosphere") or d:IsA("Sky") then
                        pcall(function() d:Destroy() end)
                    end
                end
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CastShadow = false
                        obj.Material = Enum.Material.Plastic
                        obj.Reflectance = 0
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                        pcall(function() obj:Destroy() end)
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        obj.Transparency = 1
                    end
                end
                sendNotify("TRO FPS", "✅ تم تحسين الأداء")
            end)
            atk5.Text = "تم ✓"
            task.delay(2, function() atk5.Text = "تشغيل" end)
        end)

        local atk6, s6 = makeAtkCard("🗑️ حذف الأجزاء القريبة", "يحذف الأجزاء غير المثبتة قربك")
        atk6.MouseButton1Click:Connect(function()
            local myHRP = getHRP()
            if not myHRP then return end
            local count = 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj.Anchored then
                    if (obj.Position - myHRP.Position).Magnitude < 5 then
                        if not obj.Parent:FindFirstChildOfClass("Humanoid") then
                            pcall(function() obj:Destroy() end)
                            count = count + 1
                        end
                    end
                end
            end
            sendNotify("TRO Sabotage", "✅ تم حذف " .. count .. " جزء")
            atk6.Text = "تم ✓"
            task.delay(2, function() atk6.Text = "تشغيل" end)
        end)

        local atk7, s7 = makeAtkCard("👑 علامة TRO فوق رأسك", "يضيف علامة TRO فوق رأسك بشكل دائم")
        local tagActive = false
        atk7.MouseButton1Click:Connect(function()
            if tagActive then
                tagActive = false
                atk7.Text = "تشغيل"
                atk7.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
                if player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local old = head:FindFirstChild("TRO_Tag")
                        if old then old:Destroy() end
                    end
                end
                sendNotify("TRO Tag", "⛔ تم إيقاف العلامة")
            else
                tagActive = true
                atk7.Text = "إيقاف"
                atk7.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
                task.spawn(function()
                    while tagActive do
                        task.wait(0.5)
                        local char = player.Character
                        if char then
                            local head = char:FindFirstChild("Head")
                            if head then
                                local tag = head:FindFirstChild("TRO_Tag")
                                if not tag then
                                    tag = Instance.new("BillboardGui")
                                    tag.Name = "TRO_Tag"
                                    tag.Size = UDim2.new(0, 200, 0, 50)
                                    tag.StudsOffset = Vector3.new(0, 3, 0)
                                    tag.AlwaysOnTop = true
                                    tag.Parent = head
                                    local lbl = Instance.new("TextLabel", tag)
                                    lbl.Size = UDim2.new(1, 0, 1, 0)
                                    lbl.BackgroundTransparency = 1
                                    lbl.Text = "👑 TRO 👑"
                                    lbl.TextColor3 = Color3.fromRGB(0, 255, 120)
                                    lbl.Font = Enum.Font.GothamBlack
                                    lbl.TextScaled = true
                                    lbl.TextStrokeTransparency = 0
                                end
                            end
                        end
                    end
                end)
                sendNotify("TRO Tag", "✅ تم تفعيل العلامة")
            end
        end)
    end

    -- SETTINGS
    do
        local sT = Instance.new("TextLabel", setP)
        sT.Size = UDim2.new(0.9, 0, 0, 30)
        sT.Position = UDim2.new(0.04, 0, 0, 10)
        sT.BackgroundTransparency = 1
        sT.TextColor3 = Color3.fromRGB(0, 255, 120)
        sT.Text = "[*] إعدادات الألوان // theme_config.py"
        sT.TextSize = 11
        sT.Font = Enum.Font.Gotham
        sT.TextXAlignment = Enum.TextXAlignment.Left
        sT.ZIndex = 4

        local function applyTheme(col)
            shadow.Color = col
            tgS.Color = col
            tgBtn.TextColor3 = col
            tText.TextColor3 = col
            sT.TextColor3 = col
        end

        local function mkTheme(name, y, col)
            local b = Instance.new("TextButton", setP)
            b.Size = UDim2.new(0.92, 0, 0, 45)
            b.Position = UDim2.new(0.04, 0, 0, y)
            b.BackgroundColor3 = Color3.fromRGB(15, 30, 18)
            b.BackgroundTransparency = 0.3
            b.TextColor3 = col
            b.Text = name
            b.TextSize = 11
            b.Font = Enum.Font.Gotham
            b.ZIndex = 10
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", b)
            bs.Thickness = 1.5
            bs.Color = col
            b.MouseButton1Click:Connect(function() applyTheme(col) end)
        end

        mkTheme("🟢 TRO Green", 50, Color3.fromRGB(0, 255, 120))
        mkTheme("🔵 Cyber Blue", 105, Color3.fromRGB(0, 200, 255))
        mkTheme("🔴 Red Alert", 160, Color3.fromRGB(255, 50, 50))
        mkTheme("🟡 Gold Hacker", 215, Color3.fromRGB(255, 215, 0))
        mkTheme("🟣 Purple Matrix", 270, Color3.fromRGB(200, 50, 255))
    end

    -- MOBILE
    do
        local mb = Instance.new("Frame", main)
        mb.Size = UDim2.new(0, 160, 0, 12)
        mb.Position = UDim2.new(0.5, -80, 1, -18)
        mb.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        mb.BackgroundTransparency = 0.2
        mb.BorderSizePixel = 0
        mb.ZIndex = 25
        Instance.new("UICorner", mb).CornerRadius = UDim.new(1, 0)
        local mbL = Instance.new("Frame", mb)
        mbL.Size = UDim2.new(0.7, 0, 0, 4)
        mbL.Position = UDim2.new(0.15, 0, 0.5, -2)
        mbL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        mbL.BorderSizePixel = 0
        mbL.ZIndex = 26
        Instance.new("UICorner", mbL).CornerRadius = UDim.new(1, 0)
        local rH = Instance.new("TextButton", main)
        rH.Size = UDim2.new(0, 40, 0, 40)
        rH.Position = UDim2.new(1, -40, 1, -40)
        rH.BackgroundTransparency = 1
        rH.Text = ""
        rH.ZIndex = 27
        local rC = Instance.new("Frame", rH)
        rC.Size = UDim2.new(0, 22, 0, 4)
        rC.Position = UDim2.new(1, -26, 1, -10)
        rC.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        rC.BorderSizePixel = 0
        rC.Rotation = -45
        rC.ZIndex = 28
        Instance.new("UICorner", rC).CornerRadius = UDim.new(1, 0)

        local isDrag, isRsz = false, false
        local dsP, fsP, rsP, fsS
        local function gp(i) return Vector2.new(i.Position.X, i.Position.Y) end
        local function isP(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end
        local function isM(i) return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch end

        mb.InputBegan:Connect(function(i) if isP(i) then isDrag = true; dsP = gp(i); fsP = main.Position end end)
        rH.InputBegan:Connect(function(i) if isP(i) then isRsz = true; rsP = gp(i); fsS = main.AbsoluteSize end end)
        UIS.InputChanged:Connect(function(i)
            if isDrag and isM(i) then
                local d = gp(i) - dsP
                main.Position = UDim2.new(fsP.X.Scale, fsP.X.Offset + d.X, fsP.Y.Scale, fsP.Y.Offset + d.Y)
            elseif isRsz and isM(i) then
                local d = gp(i) - rsP
                main.Size = UDim2.new(0, math.clamp(fsS.X + d.X, 320, 1400), 0, math.clamp(fsS.Y + d.Y, 260, 1000))
            end
        end)
        UIS.InputEnded:Connect(function(i) if isP(i) then isDrag = false; isRsz = false end end)

        task.spawn(function()
            task.wait(1)
            pcall(function()
                local vp = workspace.CurrentCamera.ViewportSize
                if vp.X < 800 then
                    local nW = math.min(vp.X - 30, 520)
                    local nH = math.min(vp.Y - 100, 420)
                    main.Size = UDim2.new(0, nW, 0, nH)
                    main.Position = UDim2.new(0.5, -nW/2, 0.5, -nH/2)
                elseif vp.X < 1200 then
                    main.Size = UDim2.new(0, 680, 0, 470)
                    main.Position = UDim2.new(0.5, -340, 0.5, -235)
                end
            end)
        end)
    end

    closeBtn.MouseButton1Click:Connect(function()
        pcall(function() gui:Destroy() end)
        pcall(function() tgGui:Destroy() end)
    end)

    return protP
end

-- ═══════════════════════════════════════════════════════════════════
-- RUN
-- ═══════════════════════════════════════════════════════════════════
local protPage = BUILD_ALL()
_G.AntiEmote = CreateAntiEmote(protPage)

pcall(function()
    SG:SetCore("SendNotification", {
        Title = "TRO HUB",
        Text = "✅ TRO HUB محمّل - By سـجّـاد",
        Duration = 5
    })
end)

print("[+] TRO HUB LOADED - By سـجّـاد")
