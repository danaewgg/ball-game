if game.PlaceId == 8448881160 then
    game:GetService("ReplicatedStorage").Remotes.Teleport:InvokeServer("Park")
    queue_on_teleport('loadstring(request(Url = "https://raw.githubusercontent.com/danaewgg/ball-game/main/Park.lua").Body)()')
    return
end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local function SendMessageToWebhook(message)
    local response = request({
        Url = "https://discord.com/api/webhooks/1229721351124942941/OciXX8P6Bky_yp4T9LHSaUClTOuhFVEDyGUHvfCQvrq2zYa8Ory-HepwWGKIn38o5KKy",
        Method = "POST",
        Body = HttpService:JSONEncode({content = message}),
        Headers = {["Content-Type"] = "application/json"}
    })
end

Players.LocalPlayer.OnTeleport:Connect(function()
    clear_teleport_queue()
    queue_on_teleport('loadstring(request(Url = "https://raw.githubusercontent.com/danaewgg/ball-game/main/Park.lua").Body)()')
end)

for _, player in next, Players:GetPlayers() do
    if player ~= Players.LocalPlayer then
        SendMessageToWebhook(`block {player.UserId}`)
    end
end
