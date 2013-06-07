require 'json'
require 'webrick'

class Session
  def initialize(req)
    @session = req.cookies['_rails_lite_app']
    @domain = "#{req.host}:#{req.port}"
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    cookie = Webrick::Cookie.new

    cookie.domain = @domain
    cookie.name = key
    cookie.value = val

    @cookies << cookie
    @res.cookies << cookie
  end

  def store_session(res)
    cookie = Webrick::Cookie.new
    cookie.name = '_rails_lite_app'
  end
end
