rconsoleprint("Checkpoint 1 - Script ran")

local placeId = game.PlaceId
if placeId == 8448881160 then
    rconsoleprint("Debug - Player is in plaza, teleporting to park")
    return game:GetService("ReplicatedStorage").Remotes.Teleport:InvokeServer("Park"), queue_on_teleport([[loadstring(request({Url = "https://raw.githubusercontent.com/danaewgg/ball-game/main/Park.lua"}).Body)()]])
end
if placeId ~= 10107441386 then return rconsoleprint("Debug - Returning script, the player wasn't in plaza or park") end
rconsoleprint("Checkpoint 2 - Park matched, running code")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playersInServer = Players:GetPlayers()

if #playersInServer <= 1 then return rconsoleprint("Debug - Returning script, identified fresh park") end -- '<=' is faster than just '<' from my testing

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
