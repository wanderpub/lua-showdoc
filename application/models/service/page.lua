local page_dao = LoadApplication('models.dao.page'):new()
local PageService = {}

function PageService:getItem(uid)
	return page_dao:getItem(uid)
end
function PageService:getPage(item_id)
	return page_dao:getPage(item_id)
end
function PageService:save(data)
	return page_dao:save(data)
end
function PageService:get(page_id)
	return page_dao:get(page_id)
end

function PageService:getCatalog(item_id)
	return page_dao:getCatalog(item_id)
end

function PageService:delete(page_id)
	return page_dao:delete(page_id)
end

return PageService