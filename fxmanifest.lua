fx_version 'cerulean'
author 'Maxos'
version '1.1.0'
description 'Most incredible FiveM elevator script'
lua54 'yes'
game 'gta5'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}
server_scripts {
    'server.lua'
}

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
    'web/build/assets/*.*'
}
