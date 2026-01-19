local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ALTURA = 10
local RADIO = 80

-- buscar npc cercano
local function buscarNPC()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local mejor, dist = nil, math.huge

    for _, m in pairs(workspace:GetDescendants()) do
        if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(m) then
                local d = (hrp.Position - m.HumanoidRootPart.Position).Magnitude
                if d < dist and d < RADIO then
                    mejor = m
                    dist = d
                end
            end
        end
    end

    return mejor
end

-- seguir desde arriba
local function seguir(npc)
    local char = player.Character
    if not char then return end

    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    hum:ChangeState(Enum.HumanoidStateType.Physics)

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = hrp

    task.spawn(function()
        while npc.Parent and char.Parent do
            local pos = npc.HumanoidRootPart.Position + Vector3.new(0, ALTURA, 0)
            local dir = (pos - hrp.Position)
            bv.Velocity = dir * 6
            task.wait(0.03)
        end
    end)
end

task.wait(2)
local npc = buscarNPC()
if npc then
    seguir(npc)
else
    warn("No se encontro NPC")
end
