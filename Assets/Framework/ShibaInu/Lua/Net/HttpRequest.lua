--
-- 发送 HTTP 请求
-- 2018/1/22
-- Author LOLO
--

local type = type
local error = error
local pairs = pairs
local concat = table.concat


--
---@class HttpRequest : EventDispatcher
---@field New fun():HttpRequest
---
---@field url string @ 网络地址
---@field timeout number @ 超时时间，默认值：5秒
---@field method string @ 请求方式，默认：如果有设置 post 数据，值为"POST"。否则"GET"
---@field postData table @ 要发送的 post 数据
---@field callback Handler @ 请求结束时的回调 callback(successful, content)
---
---@field statusCode number @ 请求结束时的状态码
---@field successful boolean @ 请求是否成功（statusCode 介于 200 - 299 之间）
---@field content string @ 返回的内容
---
---@field protected _proxyHost string @ 代理地址
---@field protected _proxyPort number @ 代理端口
---@field protected _request ShibaInu.HttpRequest
---@field protected _handler Handler
---
local HttpRequest = class("HttpRequest", EventDispatcher)

local event = HttpEvent.New(HttpEvent.ENDED)


--
--- 构造函数
function HttpRequest:Ctor()
    HttpRequest.super.Ctor(self)
end


--
--- 发送请求
---@param url string @ -可选- 网络地址
---@param callback Handler @ -可选- 请求结束时的回调 callback(successful, content)
---@param postData table<string, string> @ -可选- 要发送的 post 数据列表
function HttpRequest:Send(url, callback, postData)
    if callback ~= nil then
        self.callback = callback
    end
    self.statusCode = nil
    self.content = nil
    self.successful = false


    -- 取消正在发送的请求
    if self._handler ~= nil then
        self._handler:Recycle()
        self._handler = nil
    end
    local request = self._request --- @type ShibaInu.HttpRequest
    if request ~= nil then
        request:Abort()
        self._request = nil
    end


    -- url 验证
    if url ~= nil then
        self.url = url
    end
    if self.url == nil then
        error(Constants.E3003)
    end


    -- 创建 ShibaInu.HttpRequest
    request = ShibaInu.HttpRequest.New()
    self._request = request
    request.url = self.url


    -- 添加 post 数据
    local method
    if postData ~= nil then
        self.postData = postData
    end
    if self.postData ~= nil then
        method = Constants.HTTP_METHOD_POST
        if type(self.postData) == "string" then
            request.postData = self.postData
        else
            local pd = {}
            for k, v in pairs(self.postData) do
                --request:AppedPostData(k, v)
                if #pd > 0 then
                    pd[#pd + 1] = "&"
                end
                pd[#pd + 1] = k
                pd[#pd + 1] = "="
                pd[#pd + 1] = StringUtil.EncodeURI(v)
            end
            local str = concat(pd, "")
            request.postData = str
        end
    else
        method = Constants.HTTP_METHOD_GET
    end


    -- 有指定 method
    request.method = self.method or method

    -- 有指定超时时间
    if self.timeout ~= nil then
        request.timeout = self.timeout
    end

    -- 有设置代理
    if self._proxyHost ~= nil then
        request:SetProxy(self._proxyHost, self._proxyPort)
    end

    -- 发送请求
    self._handler = handler(self.EndedHandler, self)
    request:SetLuaCallback(self._handler.lambda)
    request:Send()
end


--
--- HTTP 请求已结束
---@param statusCode number
---@param content string
function HttpRequest:EndedHandler(statusCode, content)
    self._handler = nil
    self._request = nil

    self.statusCode = statusCode
    self.content = content
    self.successful = statusCode > 199 and statusCode < 300

    -- 抛出 HttpRequestEvent.ENDED 事件
    self:DispatchEvent(event, false, false)

    -- 执行 callback
    local callback = self.callback
    if callback ~= nil then
        self.callback = nil
        callback:Execute(self.successful, content)
    end
end


--
--- 取消正在发送的请求
function HttpRequest:Abort()
    if self._request ~= nil then
        self._request:Abort()
    end
end


--
--- 设置代理
---@param host string @ 代理地址
---@param port number @ -可选- 代理端口，默认：80
function HttpRequest:SetProxy(host, port)
    self._proxyHost = host
    self._proxyPort = port or 80
end


--
--- 是否正在请求中
---@return boolean
function HttpRequest:IsRequesting()
    return self._request ~= nil
end



--
return HttpRequest