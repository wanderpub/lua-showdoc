local db = LoadLibrary("mysql"):new()
local TableDao = {}
-- local TableDao = Class("table", LoadModel('dao.base'))
-- function TableDao:__construct()
--     self.parent:__construct()
-- end

function TableDao:getPage()
    local res, err = db:query("select * from page")

    if not res or err or type(res) ~= "table" or #res <= 0 then
        return {}
    else
        return res
    end
end

function TableDao:save(data)
    return db:query("insert into `apidoc`.`page` ( `cat_id`, `order`, `page_content`, `author_username`, `author_uid`, `item_id`, `page_title`) values ( ?, ?, ?, ?, ?, ?, ?)",
            {tonumber(data.cat_id), tonumber(data.order), data.page_content,'admin',tonumber(data.author_uid),tonumber(data.item_id),data.page_title})
end

function TableDao:get(page_id)
    local result, err =  db:query("select * from page where page_id=?",{tonumber(page_id)})
    if not result or err or type(result) ~= "table" or #result ~=1 then
        return nil, err
    else
        return result[1], err
    end
end

function TableDao:set(key, value)
    self.__cache[key] = value
    return true
end

function TableDao:new()
    local instance = {
        getPage = self.getPage,
        set = self.set,
        save = self.save,
        get = self.get,
        __cache = {}
    }
    setmetatable(instance, TableDao)
    return instance
end

function TableDao:__index(key)
    local out = rawget(rawget(self, '__cache'), key)
    if out then return out else return false end
end
return TableDao
