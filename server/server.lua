lib.versionCheck('Sahapz/ss-coordsaver')

local currentsave = ''
local savedCoords = {}

local formatType = "vec4"

RegisterNetEvent("ss-coordsaver:server:setSaveName", function(saveName, format)

    if saveName then
        currentsave = saveName
        formatType = tostring(format)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Coords',
            description = 'Coords saving is started',
            type = 'success'
        })
    end
end)



RegisterNetEvent("ss-coordsaver:server:savePos", function()
    local plyPed = GetPlayerPed(source)
    local playerPos = GetEntityCoords(plyPed)
    local heading = GetEntityHeading(plyPed)

    local formattedPos

    if formatType == "vec4" then
        formattedPos = string.format("vec4(%.6f, %.6f, %.6f, %.6f),", playerPos.x, playerPos.y, playerPos.z, heading)
    else
        formattedPos = string.format("{ x = %.6f, y = %.6f, z = %.6f, h = %.6f },", playerPos.x, playerPos.y, playerPos.z, heading)
    end

    table.insert(savedCoords, formattedPos)

    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Coords',
        description = 'New coord saved',
        type = 'success'
    })

end)

RegisterNetEvent("ss-coordsaver:server:sendPosList", function()
    if currentsave == '' then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Coords',
            description = "The saving isn't started",
            icon = 'fa-solid fa-paper-plane',
            type = 'error'
        })
         return 
    end
    local formattedCoords = table.concat(savedCoords, "\n")

    local webhookData = {
        username = 'Saved coords',
        content = '**' .. currentsave .. '**\n ```\n' .. formattedCoords .. '\n```'
    }

    PerformHttpRequest(cfg.webhook, 
        function(err, text, headers) end, 
        'POST', json.encode(webhookData), 
        { ['Content-Type'] = 'application/json' }
    )

    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Coords',
        description = 'The list has been sent to discord',
        icon = 'fa-solid fa-paper-plane',
        type = 'success'
    })

    savedCoords = {}
    currentsave = ''
end)

lib.callback.register('ss-coordsaver:server:saveCoord', function(source, saveName)
    local plyPed = GetPlayerPed(source)
    local playerPos = GetEntityCoords(plyPed)
    local heading = GetEntityHeading(plyPed)


    local vecPos = string.format("vec4(%f, %f, %f, %f)", playerPos.x, playerPos.y, playerPos.z, heading)
    

    local tablePos = json.encode({ x = playerPos.x, y = playerPos.y, z = playerPos.z, h = heading })

    local message = tostring(saveName)


    MySQL.insert('INSERT INTO saved_coords (coords, coords_vector3, description) VALUES (?, ?, ?)', {tablePos, vecPos, message}, function(res)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Coords',
            description = 'New coord saved',
            icon = 'fa-solid fa-floppy-disk',
            type = 'success'
        })
        return true
    end)
end)



RegisterCommand('saveCoord', function(source, args)
    if args[1] then
        local plyPed = GetPlayerPed(source)
        local playerPos = GetEntityCoords(plyPed)
        local heading = GetEntityHeading(plyPed)
        local vecPos = 'vec4(' .. playerPos.x .. ', ' .. playerPos.y .. ', ' .. playerPos.z ..', ' .. heading ..'),'
        local tablePos = '{ x = ' .. playerPos.x .. ', y = ' .. playerPos.y .. ', z = ' .. playerPos.z .. ', h = ' .. heading .. '}'
        local message = ''

        for k,v in ipairs(args) do
            message = message .. " " .. v
        end

        MySQL.insert('INSERT INTO saved_coords (coords, coords_vector3, description) VALUES (?, ?, ?)', {tablePos, vecPos, message}, function(res)
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Coords',
                description = 'New coord saved to database',
                type = 'success'
            })
        end)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Coords',
            description = "U dont't have args filled.",
            type = 'error'
        })
    end
end)

