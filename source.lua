--<>----<>----<>----<>----<>----<>----<>--
repeat wait() until game:IsLoaded() wait()
    game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new());
end);
--<>----<>----<>----<>----<>----<>----<>--
--<>----<>----<>----<>----<>----<>----<>--
pcall(function()
    for i, v in pairs(getconnections(game:GetService("ScriptContext").Error)) do
        v:Disable();
    end;
end);
--<>----<>----<>----<>----<>----<>----<>--

--<>----<>----<>----<>----<>----<>----<>--
local Workspace = game:GetService('Workspace');
local ReplicatedStorage = game:GetService('ReplicatedStorage');
local Players = game:GetService('Players');
local Client = Players.LocalPlayer;
local RunService = game:GetService('RunService');
local Workspace = game:GetService("Workspace");
local Lighting = game:GetService("Lighting");
local UIS = game:GetService("UserInputService");
local Teams = game:GetService("Teams");
local ScriptContext = game:GetService("ScriptContext");
local CoreGui = game:GetService("CoreGui");
local Camera = Workspace.CurrentCamera;
local Mouse = Client:GetMouse();
local Terrain = Workspace.Terrain;
local VirtualUser = game:GetService("VirtualUser");
--<>----<>----<>----<>----<>----<>----<>--

local Character = nil;
local RootPart = nil;
local Humanoid = nil;

getgenv().WS = 16
getgenv().JP = 50
function SetCharVars()
	Character = Client.Character;
	Humanoid = Character:FindFirstChild("Humanoid") or Character:WaitForChild("Humanoid");
	RootPart = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart");
	if getgenv().Speed then
		Humanoid.WalkSpeed = getgenv().WS;
	end;
	Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if getgenv().Speed then
			Humanoid.WalkSpeed = getgenv().WS;
		end;
	end);
    if getgenv().Jump then
		Humanoid.WalkSpeed = getgenv().JP;
	end;
	Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if getgenv().Jump then
			Humanoid.WalkSpeed = getgenv().JP;
		end;
	end);
end;
SetCharVars();
Client.CharacterAdded:Connect(SetCharVars);

local Ws;
Ws = hookmetamethod(game, "__index", function(self, Value)
    if tostring(self) == "Humanoid" and tostring(Value) == "WalkSpeed" then
        return 16;
    end;
    return Ws(self, Value);
end);

local Jp;
Jp = hookmetamethod(game, "__index", function(self, Value)
    if tostring(self) == "Humanoid" and tostring(Value) == "WalkSpeed" then
        return 16;
    end;
    return Jp(self, Value);
end);



local c;
local h;
local bv;
local bav;
local cam;
local flying;
local p = Client;
local buttons = {W = false, S = false, A = false, D = false, Moving = false};

local StartFly = function ()
    if not Client.Character or not Character.Head or flying then return end;
    c = Character;
    h = Humanoid;
    h.PlatformStand = true;
    cam = workspace:WaitForChild('Camera');
    bv = Instance.new("BodyVelocity");
    bav = Instance.new("BodyAngularVelocity");
    bv.Velocity, bv.MaxForce, bv.P = Vector3.new(0, 0, 0), Vector3.new(10000, 10000, 10000), 1000;
    bav.AngularVelocity, bav.MaxTorque, bav.P = Vector3.new(0, 0, 0), Vector3.new(10000, 10000, 10000), 1000;
    bv.Parent = c.Head;
    bav.Parent = c.Head;
    flying = true;
    h.Died:connect(function() flying = false end);
end;

local EndFly = function ()
    if not p.Character or not flying then return end
    h.PlatformStand = false;
    bv:Destroy();
    bav:Destroy();
    flying = false;
end;

game:GetService("UserInputService").InputBegan:connect(function (input, GPE) 
    if GPE then return end;
    for i, e in pairs(buttons) do
        if i ~= "Moving" and input.KeyCode == Enum.KeyCode[i] then
            buttons[i] = true;
            buttons.Moving = true;
        end;
    end;
end);

game:GetService("UserInputService").InputEnded:connect(function (input, GPE) 
    if GPE then return end;
    local a = false;
    for i, e in pairs(buttons) do
        if i ~= "Moving" then
            if input.KeyCode == Enum.KeyCode[i] then
                buttons[i] = false;
            end;
            if buttons[i] then a = true end;
        end;
    end;
    buttons.Moving = a;
end);

local setVec = function (vec)
    return vec * ((getgenv().FlySpeed or 50) / vec.Magnitude);
end;

game:GetService("RunService").Heartbeat:connect(function (step) -- The actual fly function, called every frame
    if flying and c and c.PrimaryPart then
        local p = c.PrimaryPart.Position;
        local cf = cam.CFrame;
        local ax, ay, az = cf:toEulerAnglesXYZ();
        c:SetPrimaryPartCFrame(CFrame.new(p.x, p.y, p.z) * CFrame.Angles(ax, ay, az));
        if buttons.Moving then
            local t = Vector3.new();
            if buttons.W then t = t + (setVec(cf.lookVector)) end;
            if buttons.S then t = t - (setVec(cf.lookVector)) end;
            if buttons.A then t = t - (setVec(cf.rightVector)) end;
            if buttons.D then t = t + (setVec(cf.rightVector)) end;
            c:TranslateBy(t * step);
        end;
    end;
end);

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Fuzki-UI-Library/main/FuzkiLibrary.lua"))()
local Main = Library:Create("NexusX - natrual disasters", "made by flames")

local Preview = Main:CreateSection("Main")

Preview:CreateToggle("Fly", function(state)
    getgenv().Flying = state
        if getgenv().Flying then
            StartFly()
        else
            EndFly()
        end
end)

Preview:CreateSlider(16, 100, "Fly Speed", function(val)
    getgenv().FlySpeed = tonumber(val) or 50
end)

-- Firstly, create the textbox for inputting the player's name
Preview:CreateTextBox("Fling Player", "PlayerName", function(PlayerName)
    -- The function to find players
    local function gplr(String)
        local Found = {}
        local strl = String:lower()
        if strl == "all" then
            for i,v in pairs(game:FindService("Players"):GetPlayers()) do
                table.insert(Found,v)
            end
        elseif strl == "others" then
            for i,v in pairs(game:FindService("Players"):GetPlayers()) do
                if v.Name ~= game.Players.LocalPlayer.Name then
                    table.insert(Found,v)
                end
            end 
        elseif strl == "me" then
            for i,v in pairs(game:FindService("Players"):GetPlayers()) do
                if v.Name == game.Players.LocalPlayer.Name then
                    table.insert(Found,v)
                end
            end 
        else
            for i,v in pairs(game:FindService("Players"):GetPlayers()) do
                if v.Name:lower():sub(1, #String) == String:lower() then
                    table.insert(Found,v)
                end
            end 
        end
        return Found 
    end

    -- Function to execute when a valid player name is entered
    local Target = gplr(PlayerName)
    if Target[1] then
        Target = Target[1]
        local Thrust = Instance.new('BodyThrust', game.Players.LocalPlayer.Character.HumanoidRootPart)
        Thrust.Force = Vector3.new(9999,9999,9999)
        Thrust.Name = "YeetForce"
        repeat
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
            Thrust.Location = Target.Character.HumanoidRootPart.Position
            game:FindService("RunService").Heartbeat:wait()
        until not Target.Character:FindFirstChild("Head")
    else
        -- Assume you have a notification function similar to notif(str,dur)
        -- notif("Invalid player")
    end
 
end)
Preview:CreateSlider(16, 100, "Walkspeed", function(val)
    getgenv().WS = tonumber(val)
    Humanoid.WalkSpeed = val;
end)

Preview:CreateSlider(50, 250, "Jump Power", function(val)
    getgenv().JP = tonumber(val)
        Humanoid.JumpPower = val;
end)
