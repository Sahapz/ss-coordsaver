fx_version 'adamant'
game 'gta5'

name 'ss-coordsaver'
author 'Sahap'
description 'A simple coord saver script.'

shared_scripts {
	'@ox_lib/init.lua'
} 

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

client_scripts {
    'client/client.lua',
}

dependencies {
    'oxmysql',
    'ox_lib'
}


lua54 'yes'