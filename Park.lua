rconsoleprint("Checkpoint 1 - Executed")

if game.PlaceId == 8448881160 then
    return game:GetService("ReplicatedStorage").Remotes.Teleport:InvokeServer("Park"), queue_on_teleport([[loadstring(request({Url = "https://raw.githubusercontent.com/danaewgg/ball-game/main/Park.lua"}).Body)()]])
end

rconsoleprint("Checkpoint 2 - Not in plaza, running code")

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- I've thought about caching the request arguments, but looking at my code above makes me think it won't make sense, it's already having to get game.PlaceId, and I can't cache that, so it'll slow down execution anyway
local function SendMessageToWebhook(message)
    local response = request({
        Url = "https://discord.com/api/webhooks/1229721351124942941/OciXX8P6Bky_yp4T9LHSaUClTOuhFVEDyGUHvfCQvrq2zYa8Ory-HepwWGKIn38o5KKy", -- I know
        Method = "POST",
        Body = HttpService:JSONEncode({content = message}),
        Headers = {["Content-Type"] = "application/json"}
    })
end

Players.LocalPlayer.OnTeleport:Connect(function()
    rconsoleprint("Debug - OnTeleport connection triggered")
    clear_teleport_queue()
    queue_on_teleport([[loadstring(request({Url = "https://raw.githubusercontent.com/danaewgg/ball-game/main/Park.lua"}).Body)()]])
    rconsoleprint("Debug - End of function connected to OnTeleport")
end)

rconsoleprint("Checkpoint 3 - Ready for main loop")

for _, player in next, Players:GetPlayers() do
    if player ~= Players.LocalPlayer then -- Faster than a guard clause with continue
        SendMessageToWebhook(`block {player.UserId}`) -- Thought of using task.spawn, but it's just an unnecessary function call, as I won't be checking the response after the request
    end
end

rconsoleprint("Debug - Finished executing script")
