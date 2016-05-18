init_vanilla()
--+--------------------------------------------------------------------------------+--


-- if Registry['VA_ENV'] == nil then
    local helpers = LoadV "vanilla.v.libs.utils"
    function sprint_r( ... )
        return helpers.sprint_r(...)
    end

    function lprint_r( ... )
        local rs = sprint_r(...)
        print(rs)
    end

    function print_r( ... )
        local rs = sprint_r(...)
        ngx.say(rs)
    end

    function err_log(msg)
        ngx.log(ngx.ERR, "===zjdebug" .. msg .. "===")
    end
-- end
--+--------------------------------------------------------------------------------+--


local vanilla_application = LoadV 'vanilla.v.application'
local application_config = LoadApp 'config.application'
local boots = LoadApp 'application.bootstrap'
vanilla_application:new(ngx, application_config):bootstrap(boots):run()
