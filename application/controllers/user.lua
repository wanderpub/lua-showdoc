local json = require 'cjson'
local UserController = Class('controllers.user', LoadApplication('controllers.base'))
local user_service = LoadModel('service.user')

function UserController:__construct()
    self.parent:__construct()
end

function UserController:login()
	local result = self.session.data['username']
	-- print_r(result)
	if result then
		return ngx.redirect("/")
    end
	local view = self:getView()
	local p = {}
	return view:display()
end
function UserController:logout()
	self.session:destroy()
    ngx.redirect("login")
end

function UserController:login_form()
	--得到请求的参数
    local req = self:getRequest()
    local username = req:getParam('username')
    local password = req:getParam('password')
    local res = {code=400,message='错误'}
    if username ==nil then
    	res.message = '用户名不能为空'
    	return json.encode(res)
    end

    if password ==nil  then
    	res.message = '密码不能为空'
    	return json.encode(res)
    end

    password = ngx.md5(ngx.encode_base64(ngx.md5(password))..'576hbgh6');
    -- res.password = password
    local user = user_service:login(username,password)
    if user ~=nil then
    	--开始设置session
	    self.session.data.username = username
        self.session.data.uid = user.uid
	    self.session:save()
    	res.code = 200
    	res.message = 'login success'
    else
    	res.message = '帐号或者密码不正确！'
    end
    return json.encode(res)
end

function UserController:register()
	local view = self:getView()
	local p = {}
	return view:display()
end

function UserController:register_form()
	--得到请求的参数
    local req = self:getRequest()
    local username = req:getParam('username')
    local password = req:getParam('password')
    local res = {code=400,message='错误'}
    if username ==nil then
    	res.message = '用户名不能为空'
    	return json.encode(res)
    end

    if password ==nil  then
    	res.message = '密码不能为空'
    	return json.encode(res)
    end

    password = ngx.md5(ngx.encode_base64(ngx.md5(password))..'576hbgh6');
    -- res.password = password
    local result = user_service:reg(username,password)
    if result.success then
    	result.code = 200
    	self.session.data.username = username
        self.session.data.uid = result.uid
	    self.session:save()
    else
    	result.code = 400
    end
    return json.encode(result)
end

return UserController