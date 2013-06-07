require 'json'
require 'webrick'

class Session
  def initialize(req)
    @index = req.cookies.index { |cookie| cookie.name == '_rails_lite_app' }

    @session = (@index.nil?) ? {} : JSON.parse(req.cookies[@index].value)

    @domain = "#{req.host}:#{req.port}"
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @index ||= store_session(res)
    cookie = Webrick::Cookie.new

    cookie.domain = @domain
    cookie.name = key
    cookie.value = val

    @cookies
  end

  def store_session(res)
    cookie = Webrick::Cookie.new
    cookie.domain = @domain
    cookie.name = '_rails_lite_app'
    @res.cookies <<
  end
end
