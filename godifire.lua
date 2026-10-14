-- Punch attack script for a Roblox character
-- Place this in a Tool or LocalScript inside the player

local tool = script.Parent
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local COOLDOWN = 0.5
local DAMAGE = 20
local HITBOX_SIZE = Vector3.new(4, 5, 4)
local lastPunch = 0

local function punch()
    local now = tick()
    if now - lastPunch < COOLDOWN then
        return
    end

    lastPunch = now

    if humanoid.Health <= 0 then
        return
    end

    local hitbox = Instance.new("Part")
    hitbox.Anchored = true
    hitbox.CanCollide = false
    hitbox.Transparency = 0.6
    hitbox.Material = Enum.Material.Neon
    hitbox.Color = Color3.fromRGB(255, 140, 0)
    hitbox.Size = HITBOX_SIZE
    hitbox.CFrame = rootPart.CFrame * CFrame.new(0, 0, -3)
    hitbox.Parent = workspace

    task.delay(0.12, function()
        if hitbox and hitbox.Parent then
            hitbox:Destroy()
        end
    end)

    local hitTargets = {}

    for _, part in ipairs(workspace:GetPartBoundsInBox(hitbox.CFrame, hitbox.Size)) do
        local model = part.Parent
        if model and model ~= character then
            local targetHumanoid = model:FindFirstChildOfClass("Humanoid")
            if targetHumanoid and targetHumanoid.Health > 0 and not hitTargets[targetHumanoid] then
                hitTargets[targetHumanoid] = true
                targetHumanoid:TakeDamage(DAMAGE)

                local tag = Instance.new("BoolValue")
                tag.Name = "WasHitByPunch"
                tag.Parent = targetHumanoid
                task.delay(0.2, function()
                    if tag.Parent then
                        tag:Destroy()
                    end
                end)
            end
        end
    end
end

if tool and tool:IsA("Tool") then
    tool.Activated:Connect(punch)
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.F then
        punch()
    end
end)

print("Punch script loaded.")
