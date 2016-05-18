local BaseController = Class('controllers.base')
local session = require "resty.session".start({secret = "623q4hR325t36VsCD3g567922IC0073T"})

function BaseController:__construct()
	self.session = session
    -- print_r('----------------BaseController:init----------------')
    -- local get = self:getRequest():getParams()
    -- self.d = '----------------base----------------' .. get.act
    -- self.d = '========'
    -- self.get = self:getRequest():getParams()
end

return BaseController
