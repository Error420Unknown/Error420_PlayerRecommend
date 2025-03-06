local Qbox = exports.qbx_core
local DISCORD_WEBHOOK = ''

local function GetDiscordNameFromId(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, 'discord:') then
            local discordId = identifier:gsub('discord:', '')
            return ('<@%s>'):format(discordId)
        end
    end
    return 'Unknown'
end

local function sendToDiscord(playerName, targetDiscordName, targetName, recommendation)
    if not DISCORD_WEBHOOK or DISCORD_WEBHOOK == '' then
        print('^1[ERROR] Webhook URL is missing! Set it in recommend_sv.lua.^0')
        return
    end

    local embed = {
        {
            title = '**New Player Recommendation**',
            description = ('**From:** %s\n**To:** %s (%s)\n\n**Message:**\n%s'):format(playerName, targetName, targetDiscordName, recommendation),
            color = 4377586,
            footer = {text = os.date('Date: %Y-%m-%d %H:%M:%S')}
        }
    }

    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
end

RegisterNetEvent('Error420_PlayerRecommend:send', function(targetId, recommendation)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    local Target = exports.qbx_core:GetPlayer(targetId)

    if not Player then
        print('[DEBUG] Player not found in qbx_core!')
        return
    end

    if not Target then
        TriggerClientEvent('ox_lib:notify', src, {title = 'Error', description = 'Invalid player.', type = 'error'})
        return
    end

    local playerName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    local targetName = Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname
    local targetDiscordName = GetDiscordNameFromId(targetId)

    sendToDiscord(playerName, targetDiscordName, targetName, recommendation)
end)

lib.versionCheck('Error420Unknown/Error420_PlayerRecommend')
