local redis = require "resty.redis"

local function is_blocked(token)
    local red = redis:new()  -- Cria uma nova instância do Redis
    red:set_timeout(1000)  -- 1 segundo de timeout

    -- Conecta ao Redis
    local ok, err = red:connect("redis", 6379)
    if not ok then
        ngx.log(ngx.ERR, "Failed to connect to Redis: ", err)
        return false
    end

    -- Busca se o token está bloqueado
    local res, err = red:get("blocked:" .. token)
    if not res then
        ngx.log(ngx.ERR, "Redis get error: ", err)
        return false
    end

    return res == "1"
end

-- Obtém o cabeçalho da requisição
local headers = ngx.req.get_headers()
local token = headers["X-Token"]

-- Se não houver token, bloqueia a requisição
if not token then
    ngx.status = ngx.HTTP_FORBIDDEN
    ngx.say('{"message":"Token não fornecido"}')
    return ngx.exit(ngx.HTTP_FORBIDDEN)
end

-- Se o token estiver bloqueado, bloqueia a requisição
if is_blocked(token) then
    ngx.status = ngx.HTTP_FORBIDDEN
    ngx.say('{"message":"Token bloqueado"}')
    return ngx.exit(ngx.HTTP_FORBIDDEN)
end

