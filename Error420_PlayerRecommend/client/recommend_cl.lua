local Qbox = exports.qbx_core

local function openRecommendationMenu(targetId)
    local input = lib.inputDialog('Player Recommendation', {
        {type = 'textarea', label = 'Write your recommendation', required = true}
    })

    if input and input[1] then
        local recommendation = input[1]
        TriggerServerEvent('Error420_PlayerRecommend:send', targetId, recommendation)
        lib.notify({title = 'Recommendations', description = 'Recommendation sent!', type = 'success'})
    else
        lib.notify({title = 'Error', description = 'You must write something.', type = 'error'})
    end
end

exports.ox_target:addGlobalPlayer({
    name = 'recommend_player',
    icon = 'fas fa-comment',
    label = 'Give Recommendation',
    distance = 2.5,
    onSelect = function(data)
        if data.entity and DoesEntityExist(data.entity) then
            local playerIndex = NetworkGetPlayerIndexFromPed(data.entity)
            if playerIndex ~= -1 then
                local targetId = GetPlayerServerId(playerIndex)
                local myId = GetPlayerServerId(PlayerId())

                if targetId and targetId ~= myId then
                    openRecommendationMenu(targetId)
                else
                    lib.notify({title = 'Error', description = 'You cannot recommend yourself!', type = 'error'})
                end
            else
                lib.notify({title = 'Error', description = 'Invalid player selected.', type = 'error'})
            end
        end
    end
})