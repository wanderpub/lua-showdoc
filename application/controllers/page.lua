local json = require 'cjson'
local PageController = Class('controllers.page', LoadApplication('controllers.base'))
local page_service = LoadModel('service.page')

function PageController:__construct()
    self.parent:__construct()
end

-- function PageController:index()
-- 	local uid = self.session.data['uid']
-- 	local username = self.session.data['username']
-- 	if not uid then
-- 		return ngx.redirect("/user/login")
-- 	else
-- 		local view = self:getView()
-- 		local p = {}
-- 		p['uid'] = uid
-- 		p['username'] = username
-- 		p['data'] = page_service:getItem(uid)
-- 		view:assign(p)
-- 		return view:display()
-- 	end
-- end
-- function PageController:page()
-- 	local view = self:getView()
-- 	local p = {}
-- 	p['data'] = page_service:getPage(1)
-- 	view:assign(p)
-- 	return view:display()
-- end

function PageController:delete()
	local page_id = self:getRequest():getParam('id')
	local res = page_service:delete(page_id)
	return json.encode({code=200,message="成功"})
end

function PageController:edit()
	local item_id = self:getRequest():getParam('item_id')
	local page_id = self:getRequest():getParam('id')
	local page = page_service:get(page_id)
	local view = self:getView()
	local p = {}
	p['item_id'] = item_id
	p['catalog'] = page_service:getCatalog(item_id)
	p['page'] = page
    view:assign(p)
	return view:display()
end

function PageController:save()
	local post = self:getRequest():POST()
    local res = page_service:save(post)
    return json.encode(res)
end

function PageController:show()
	local page_id = self:getRequest():getParam('page_id')
	page_id = tonumber(page_id)
	--判断参数是否是数字，不是数值404
    if page_id == nil then
        error({ code = 201, msg = {info = 'id不存在'}})
    end

	local page = page_service:get(page_id)

	if not page then
        error({ code = 201, msg = {info = '====='}})
	end

	local view = self:getView()
	local p = {}
    p['page'] = page
    view:assign(p)
  	return view:display()
end

return PageController