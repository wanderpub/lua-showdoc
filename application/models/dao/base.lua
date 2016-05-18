local db = LoadLibrary("mysql"):new()

local BaseDao = Class("base")

function BaseDao:__construct()
	print_r('----------------BaseDao:init----------------')
	self.db = db
end

return BaseDao