local json = require 'cjson'
local ItemController = Class('controllers.item', LoadApplication('controllers.base'))
local item_service = LoadModel('service.item')

function ItemController:__construct()
    self.parent:__construct()
end

function ItemController:index()
	local uid = self.session.data['uid']
	local username = self.session.data['username']
	if not uid then
		return ngx.redirect("/user/login")
	else
		local view = self:getView()
		local p = {}
		p['uid'] = uid
		p['username'] = username
		p['data'] = item_service:getItem(uid)
		view:assign(p)
		return view:display()
	end
end

function ItemController:add()
	local uid = self.session.data['uid']
	if not uid then
		return ngx.redirect("/user/login")
	else
		local view = self:getView()
		return view:display()
	end
end

function ItemController:save()
	local result = {code=400,message="请先登录"}
	local uid = self.session.data['uid']
	local username = self.session.data['username']
	if not uid then
		code = 503
		message = '请先登录'
		return json.encode(result)
	end
	--得到提交表单参数
    local req = self:getRequest()
    --栏目名称
    local item_name = req:getParam("item_name")
    --栏目描述
    local item_description = req:getParam("item_description")
    local password = req:getParam("password")
    local data = {item_name=item_name,
    				item_description=item_description,
    				password=password,
    				uid = uid,
    				username = username
    			}
    local res = item_service:save(data)
    return json.encode(res)
end

function ItemController:show()


	local page_id = self:getRequest():getParam('id')
	page_id = tonumber(page_id)
	--判断参数是否是数字，不是数值404
    if page_id == nil then
        error({ code = 201, msg = {info = 'llkfj'}})
    end

	local page = item_service:getPage(page_id)

	if not page then
        error({ code = 201, msg = {info = '====='}})
	end

	local item = item_service:getItemList(page_id)
	local view = self:getView()
	local p = {}
	local uid = self.session.data['uid']
	if not uid then
		p['is_show'] = false
	else
		if page.uid == uid then p['is_show'] = true end
	end
    p['page'] = page
    p['item'] = item
    view:assign(p)
  	return view:display()
end

function ItemController:catalog()
	local id = self:getRequest():getParam('item_id')
	local view = self:getView()

	local cat_id = self:getRequest():getParam('cat_id')
	cat_id = tonumber(cat_id) or 0

	local p = {}
	p['cat_id'] = cat_id

    if cat_id ~= nil then
    	local cat = item_service:cat(cat_id)
    	p['cat_name'] = cat.cat_name
    	p['order'] = cat.order
    end
	p['item_id'] = id
	view:assign(p)
  	return view:display()
end

function ItemController:catlist()
	local id = self:getRequest():getParam('item_id')
	local res = item_service:catList(id)
	return json.encode({code=200,data=res})
end

function ItemController:savecat()
	local post = self:getRequest():POST()
    local res = item_service:savecat(post)
    return json.encode(res)
end
function ItemController:delcat()
	local cat_id = self:getRequest():getParam('cat_id')
	cat_id = tonumber(cat_id)
	local res = item_service:delcat(cat_id)
    return json.encode({code=200,data=res})
end

return ItemController