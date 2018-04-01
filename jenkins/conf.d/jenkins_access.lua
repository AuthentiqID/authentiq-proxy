local whitelisted_domain = "@yourdomain.tld"

local oidc_options = {
    discovery = "https://connect.authentiq.io/.well-known/openid-configuration",
    client_id = "CLIENT_ID",
    client_secret = "CLIENT_SECRET",
    scope = "openid email~rs aq:push",
    redirect_uri_path = "/authentiq/authorized",
    session_contents = { id_token=true },
}

-- Authenticate via OpenID Connect
local res, err = require("resty.openidc").authenticate(oidc_options)

if err then
    ngx.status = 500
    ngx.say(err)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

if whitelisted_domain then
    if not res.id_token.email_verified then
        ngx.status = 403
        ngx.say("Please provide a verified email address.")
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end

    local domain = string.match(res.id_token.email, "@[%w%p]+$")
    if domain ~= whitelisted_domain then
        ngx.status = 403
        ngx.say("Please provide a whitelisted email address.")
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
end

ngx.req.set_header("X-Forwarded-User", res.id_token.email)
