local function rconsoleprint(...)
    getgenv().rconsoleprint(`{os.date("%I:%M:%S %p")} | {...}`)
end
rconsoleprint("Checkpoint 1 - Script ran")

local placeId = game.PlaceId
if placeId == 8448881160 then
    rconsoleprint("Debug - Player is in plaza, initiating teleportation to park")
    return game:GetService("ReplicatedStorage").Remotes.Teleport:InvokeServer("Park"), queue_on_teleport([[loadstring(request({Url = "https://raw.githubusercontent.com/danaewgg/ball-game/main/Park.lua"}).Body)()]])
end
if placeId ~= 10107441386 then return rconsoleprint("Debug - Returning script, the player wasn't in plaza or park") end
rconsoleprint("Checkpoint 2 - Park matched, running code")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playersInServer = Players:GetPlayers()

if #playersInServer <= 1 then -- '<=' is faster than just '<' from my testing
    rconsoleprint("Debug - Identified fresh park, performing safety checks")
    local elapsedTime = 0
    repeat
        task.wait(1)
        elapsedTime += 1
    until elapsedTime >= 15 or LocalPlayer.Character
    if LocalPlayer.Character then return rconsoleprint("Debug - All checks passed, returning script") end

    -- I don't think this fixes it, might try going to Main Menu and then continuing from there
    rconsoleprint("Debug - The game seems to have loaded, but the player hasn't spawned in?")
    rconsoleprint("Debug - Initiating teleport back to plaza in order to try park again")
    return game:GetService("ReplicatedStorage").Remotes.Teleport:InvokeServer("Plaza"), queue_on_teleport([[loadstring(request({Url = "https://raw.githubusercontent.com/danaewgg/ball-game/main/Park.lua"}).Body)()]])
end

LocalPlayer.OnTeleport:Connect(function(teleportState)
    rconsoleprint(`Debug - OnTeleport triggered with state "{teleportState}"`)
    if teleportState ~= Enum.TeleportState.InProgress then return end

    rconsoleprint("Debug - Queueing script execution")
    queue_on_teleport([[loadstring(request({Url = "https://raw.githubusercontent.com/danaewgg/ball-game/main/Park.lua"}).Body)()]])
    rconsoleprint("Debug - OnTeleport function finished running")
end)
rconsoleprint("Debug - OnTeleport connection initialized")
rconsoleprint("Checkpoint 3 - Ready for main loop")

local URL = "https://discord.com/api/webhooks/1229721351124942941/OciXX8P6Bky_yp4T9LHSaUClTOuhFVEDyGUHvfCQvrq2zYa8Ory-HepwWGKIn38o5KKy" -- I know
local METHOD = "POST"
local HEADERS = {["Content-Type"] = "application/json"}
for _, player in next, playersInServer do
    if player ~= LocalPlayer then -- Faster than a guard clause with continue
        task.spawn(function() -- Because request yields, I didn't know
            request({
                Url = URL,
                Method = METHOD,
                Body = HttpService:JSONEncode({content = `block {player.UserId}`}),
                Headers = HEADERS
            })
        end)
    end
end

game:GetService("ReplicatedStorage").Remotes.Teleport:InvokeServer("Plaza") -- If we aren't teleported out ourselves (presumably in a big park)

rconsoleprint("Debug - Main loop done")
rconsoleprint("Debug - Script finished executing")
