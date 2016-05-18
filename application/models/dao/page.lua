local db = LoadLibrary("mysql"):new()
local PageDao = {}

function PageDao:getItemList(item_id)
    --获取所有父目录id为0的页面
    local pages = db:select('SELECT page_id,author_uid,item_id,cat_id,page_title,`order` FROM `page` WHERE `cat_id`=0 AND `item_id`=? ORDER BY `order` ASC ',{tonumber(item_id)})
    local catalog = db:select('SELECT * FROM `catalog` WHERE `item_id`=? ORDER BY `order` ASC ',{tonumber(item_id)})

    for k, v in pairs(catalog) do
        local cat_page = db:select('SELECT page_id,author_uid,item_id,cat_id,page_title,`order` FROM `page` WHERE `cat_id`=? AND `item_id`=? ORDER BY `order` ASC ',{v.cat_id,tonumber(item_id)})
        catalog[k].pages = cat_page
    end

    return {pages=pages,catalog=catalog}
end

function PageDao:getCatalog(item_id)
    local res, err = db:select('SELECT * FROM `catalog` WHERE `item_id`=? ORDER BY `order` ASC ',{tonumber(item_id)})
    if not res or err or type(res) ~= "table" or #res <= 0 then
        return {}
    else
        return res
    end
end

function PageDao:getItem(uid)
    local res, err = db:query("select * from `item` where `uid`=?",{tonumber(uid)})

    if not res or err or type(res) ~= "table" or #res <= 0 then
        return {}
    else
        return res
    end
end
function PageDao:getPage(item_id)
    local res, err = db:query("select * from page where item_id=?",{tonumber(item_id)})

    if not res or err or type(res) ~= "table" or #res <= 0 then
        return {}
    else
        return res
    end
end

function PageDao:save(data)
    local sql = "insert into `apidoc`.`page` ( `cat_id`, `order`, `page_content`, `author_username`, `author_uid`, `item_id`, `page_title`) values ( ?, ?, ?, ?, ?, ?, ?)"
    local params = {tonumber(data.cat_id), tonumber(data.order), data.page_content,'admin',tonumber(data.author_uid),tonumber(data.item_id),data.page_title}
    local is_insert = true
    if data.page_id ~='0' then
        is_insert = false
        sql = "update `apidoc`.`page` set `order`=?,`page_title`=?,`page_content`=? where `page_id`=?"
        params = {tonumber(data.order), data.page_title,data.page_content,tonumber(data.page_id)}
    end
    local res, err = db:query(sql,params)
    if not res or err then
        return {
            success = false,
            is_insert = is_insert,
            msg = "error"
        }
    else
        return {
            success = true,
            is_insert = is_insert,
            msg = "success"
        }
    end
end

function PageDao:get(page_id)
    local res, err =  db:query("select * from page where page_id=?",{tonumber(page_id)})
    if not res or err or type(res) ~= "table" or #res <= 0 then
        return {}
    else
        return res[1]
    end
end

function PageDao:delete(page_id)
    local res, err = db:query("delete from page where page_id=?",{tonumber(page_id)})
    return res
end


function PageDao:new()
    local instance = {
        getPage = self.getPage,
        getItem = self.getItem,
        save = self.save,
        get = self.get,
        getItemList = self.getItemList,
        getCatalog = self.getCatalog,
        delete = self.delete,
        __cache = {}
    }
    setmetatable(instance, PageDao)
    return instance
end

function PageDao:__index(key)
    local out = rawget(rawget(self, '__cache'), key)
    if out then return out else return false end
end
return PageDao