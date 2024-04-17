rconsoleprint("Checkpoint 1 - Script ran")

if game.PlaceId == 8448881160 then
    rconsoleprint("Debug - Player is in plaza, teleporting to park")
    return game:GetService("ReplicatedStorage").Remotes.Teleport:InvokeServer("Park"), queue_on_teleport([[loadstring(request({Url = "https://raw.githubusercontent.com/danaewgg/ball-game/main/Park.lua"}).Body)()]])
end

rconsoleprint("Checkpoint 2 - Park matched, running code")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playersInServer = Players:GetPlayers()

local URL = "https://discord.com/api/webhooks/1229721351124942941/OciXX8P6Bky_yp4T9LHSaUClTOuhFVEDyGUHvfCQvrq2zYa8Ory-HepwWGKIn38o5KKy" -- I know
local METHOD = "POST"
local HEADERS = {["Content-Type"] = "application/json"}
local function SendMessageToWebhook(message)
    request({
        Url = URL,
        Method = METHOD,
        Body = HttpService:JSONEncode({content = message}),
        Headers = HEADERS
    })
end

LocalPlayer.OnTeleport:Connect(function(teleportState)
    rconsoleprint(`Debug - OnTeleport triggered with state "{teleportState}"`)
    if teleportState ~= Enum.TeleportState.InProgress or #playersInServer <= 1 then return end -- '<=' is slightly faster than just '<' from my testing

    rconsoleprint("Debug - Queueing script execution")
    queue_on_teleport([[loadstring(request({Url = "https://raw.githubusercontent.com/danaewgg/ball-game/main/Park.lua"}).Body)()]])
    rconsoleprint("Debug - OnTeleport function finished running")
end)

rconsoleprint("Checkpoint 3 - Ready for main loop")

if #playersInServer <= 1 then return end -- Stop the script if the park is fresh, so we don't teleport back when we choose to leave

for _, player in next, playersInServer do
    if player ~= LocalPlayer then -- Faster than a guard clause with continue
        SendMessageToWebhook(`block {player.UserId}`) -- Thought of using task.spawn, but it's just an unnecessary function call, as I won't be checking the response after the request
    end
end

game:GetService("ReplicatedStorage").Remotes.Teleport:InvokeServer("Plaza") -- If we aren't teleported out ourselves (presumably in a big park)

rconsoleprint("Debug - Main loop done")
rconsoleprint("Debug - Script finished executing")
