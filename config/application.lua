local APP_ROOT = Registry['APP_ROOT']
local Appconf={}
Appconf.vanilla_root = '/usr/local/vanilla/framework'
Appconf.vanilla_version = '0_1_0_rc6'
Appconf.name = 'van16'

Appconf.route='vanilla.v.routes.simple'
Appconf.bootstrap='application.bootstrap'

Appconf.app={}
Appconf.app.root=APP_ROOT

Appconf.controller={}
Appconf.controller.path=Appconf.app.root .. '/application/controllers/'

Appconf.view={}
Appconf.view.path=Appconf.app.root .. '/application/views/'
Appconf.view.suffix='.html'
Appconf.view.auto_render=true

Appconf.mysql = {
	timeout = 5000,
	connect_config = {
		host = "192.168.1.155",
        port = 3306,
        database = "apidoc",
        user = "root",
        password = "123456",
        max_packet_size = 1024 * 1024
	},
	pool_config = {
		max_idle_timeout = 20000, -- 20s
    	pool_size = 50 -- connection pool size
	}
}
Appconf.redis = {
	host = "192.168.1.155",
	port = 6379
}
return Appconf
