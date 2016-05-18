local json = require 'cjson'

local IndexController = Class('controllers.index', LoadApplication('controllers.base'))

function IndexController:__construct()
    self.parent:__construct()
end

function IndexController:index()
    local view = self:getView()
    local username = self.session.data['username']
    local uid = self.session.data['uid']
    if uid then
        local p = {}
        p['username'] = username
        p['uid'] = uid
        view:assign(p)
    end
    return view:display()
end

-- curl http://localhost:9110/get?ok=yes
function IndexController:get()
    local get = self:getRequest():getParams()
    print_r(get)
    do return 'get' end
end

-- curl -X POST http://localhost:9110/post -d '{"ok"="yes"}'
function IndexController:post()
    local _, post = self:getRequest():getParams()
    print_r(post)
    do return 'post' end
end

-- curl -H 'accept: application/vnd.YOUR_APP_NAME.v1.json' http://localhost:9110/api?ok=yes
function IndexController:api_get()
    local api_get = self:getRequest():getParams()
    print_r(api_get)
    do return 'api_get' end
end

return IndexController
