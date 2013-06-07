require 'json'
require 'webrick'

class Session
  def initialize(req)
    cookie = req.cookies.select do |cookie|
      cookie.name == '_rails_lite_app'
    end.first

    @session = (cookie) ? JSON.parse(cookie.value) : {}
  end

  def [](key)
    @session[key.to_s]
  end

  def []=(key, val)
    @session[key.to_s] = val
  end

  def store_session(res)
    value = JSON.generate(@session).to_s

    cookie = WEBrick::Cookie.new('_rails_lite_app', value)

    res.cookies << cookie
  end
end
