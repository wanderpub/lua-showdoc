local db = LoadLibrary("mysql"):new()
local UserDao = {}

function UserDao:login(username,password)
    local res, err, errno, sqlstate = db:query("SELECT * FROM `user` WHERE `username`=? AND `password`=?",{username,password})
    if not res or errno or type(res) ~= "table" or #res <= 0 then
        return nil
    else
        db:update('UPDATE `user` SET `last_login_time`=? WHERE `username`=?',{ngx.now()*1000,username})
        return res[1]
    end
end

function UserDao:reg(username,password)
    local result = {success = false,message='注册失败'}
    local res, err = db:query("SELECT * FROM `user` WHERE `username`=?",{username})
    if not res or err or type(res) ~= "table" or #res <= 0 then
        --先判断是否已经有这个用户了。
        local sql = "INSERT INTO `user` (`username`,`password`,`reg_time`) values (?,?,?)"
        local ins_res,ins_err = db:insert(sql,{username,password,ngx.now()*1000})
        if not ins_res or ins_err then
            result.message = '注册错误，请重试。'
        else
            result.uid = ins_res
            result.message = '注册成功。'
            result.success = true
        end
    else
        result.message = '用户名已经存在，请换一个试试。'
    end
    return result
end

function UserDao:new()
    local instance = {
        login = self.login,
        reg = self.reg,
        __cache = {}
    }
    setmetatable(instance, UserDao)
    return instance
end

function UserDao:__index(key)
    local out = rawget(rawget(self, '__cache'), key)
    if out then return out else return false end
end
return UserDao