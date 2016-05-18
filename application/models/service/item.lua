local item_dao = LoadApplication('models.dao.item'):new()
local page_dao = LoadApplication('models.dao.page'):new()
local ItemService = {}

function ItemService:getItem(uid)
	return item_dao:getItem(uid)
end
function ItemService:save(data)
	return item_dao:save(data)
end

function ItemService:getPage(item_id)
	return item_dao:getPage(item_id)
end

function ItemService:getItemList(item_id)
	return page_dao:getItemList(item_id)
end

function ItemService:catList(item_id)
	return item_dao:catList(item_id)
end

function ItemService:cat(cat_id)
	return item_dao:cat(cat_id)
end

function ItemService:savecat(data)
	return item_dao:savecat(data)
end
function ItemService:delcat(cat_id)
	return item_dao:delcat(cat_id)
end

return ItemService