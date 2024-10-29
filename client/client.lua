local keybind = lib.addKeybind({
    name = 'savePos',
    description = 'Add coord to list',
    defaultKey = '',
    onPressed = function(self)
       TriggerServerEvent('ss-coordsaver:server:savePos')
    end
})

RegisterCommand("coords", function(source, args, rawCommand)
    lib.registerContext({
        id = 'coordssaver',
        title = 'Coords saver',
        options = {
          {
            title = 'Start recording',
            icon = 'fa-solid fa-play', 
            onSelect = function()
                local input = lib.inputDialog('Coords table name', {
                    {type = 'input', label = 'Name'},
                    { type = 'select', label = 'Type', options = {
                        { value = 'vec4', label = 'vec4(0.0, 0.0, 0.0, 0.0)' },
                        { value = 'table', label = '{ x = 0.0, y = 0.0, z = 0.0, h = 0.0}' },
                    }, default = 'vec4' }
                  })
                if input then
                    TriggerServerEvent('ss-coordsaver:server:setSaveName', input[1],  input[2])
                end
            end,
          },
          {
            title = 'Send list to discord',
            icon = 'fa-solid fa-paper-plane',
            onSelect = function()
                TriggerServerEvent('ss-coordsaver:server:sendPosList')
            end,
          },
          {
            title = 'Save position',
            icon = 'fa-solid fa-floppy-disk',
            onSelect = function()
                local input = lib.inputDialog('Coord name', {
                    {type = 'input', label = 'Name'},
                })

                if input then
                    lib.callback('ss-coordsaver:server:saveCoord', false, function(retrunable)
                    end, input[1])
                end
            end,
          },
        }
      })
     
      lib.showContext('coordssaver')
end, false)
