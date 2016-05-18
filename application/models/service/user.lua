local user_dao = LoadApplication('models.dao.user'):new()
local UserService = {}

function UserService:login(username,password)
    return user_dao:login(username,password)
end

function UserService:reg(username,password)
    return user_dao:reg(username,password)
end

return UserService