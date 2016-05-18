local db = LoadLibrary("mysql"):new()
local ItemDao = {}

function ItemDao:getItem(uid)
    local res, err = db:query("select * from `item` where `uid`=?",{tonumber(uid)})

    if not res or err or type(res) ~= "table" or #res <= 0 then
        return {}
    else
        return res
    end
end
function ItemDao:getPage(item_id)
    local res, err = db:query("select * from item where item_id=?",{tonumber(item_id)})

    if not res or err or type(res) ~= "table" or #res <= 0 then
        return {}
    else
        return res[1]
    end
end

function ItemDao:save(data)
    local sql = "INSERT INTO `item` (`item_name`, `item_description`, `uid`, `username`, `password`, `addtime`) VALUES ( ?,?,?,?,?,?)"
    local params = {data.item_name, data.item_description, tonumber(data.uid),data.username,data.password,ngx.now()}
    local res, err = db:query(sql,params)
    if not res or err then
        return {
            code = 400,
            success = false,
            message = "添加项目失败。"
        }
    else
        return {
            success = true,
            code = 200,
            message = "成功"
        }
    end
end

function ItemDao:get(page_id)
    local res, err =  db:query("select * from `page` where page_id=?",{tonumber(page_id)})
    if not res or err or type(res) ~= "table" or #res <= 0 then
        return nil
    else
        return res[1]
    end
end

function ItemDao:catList( item_id )
    local res, err = db:query("select * from `catalog` where `item_id`=?",{tonumber(item_id)})

    if not res or err or type(res) ~= "table" or #res <= 0 then
        return {}
    else
        return res
    end
end
function ItemDao:cat(cat_id)
    local res, err =  db:query("select * from `catalog` where cat_id=?",{tonumber(cat_id)})
    if not res or err or type(res) ~= "table" or #res <= 0 then
        return {}
    else
        return res[1]
    end
end
function ItemDao:savecat(data)
    local sql = "insert into `catalog` (`cat_name`, `item_id`, `order`,`addtime`) VALUES (?,?,?,?)"
    local params = {data.cat_name, tonumber(data.item_id), tonumber(data.order),ngx.now()}
    local is_insert = true
    if data.cat_id ~='0' then
        is_insert = false
        sql = "update `catalog` set `cat_name`=?,`order`=? where `cat_id`=?"
        params = {data.cat_name,tonumber(data.order),tonumber(data.cat_id)}
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

function ItemDao:delcat(cat_id)
    local res, err = db:query("delete from catalog where cat_id=?",{tonumber(cat_id)})
    return res
end

function ItemDao:new()
    local instance = {
        getPage = self.getPage,
        getItem = self.getItem,
        save = self.save,
        get = self.get,
        catList = self.catList,
        cat = self.cat,
        savecat = self.savecat,
        delcat = self.delcat,
        __cache = {}
    }
    setmetatable(instance, ItemDao)
    return instance
end

function ItemDao:__index(key)
    local out = rawget(rawget(self, '__cache'), key)
    if out then return out else return false end
end
return ItemDao