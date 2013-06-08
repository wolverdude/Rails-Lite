require 'active_support/core_ext'
require 'webrick'
require_relative 'rails_lite'

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go
    return if @req.path == '/favicon.ico'

    case @req.path
    when "/redirect"
      redirect_to('http://www.google.com')
    when "/render"
      render_content(@req.query["content"], "text/text")
    when "/show"
      render :show
    when "/count"
      session["count"] ||= 0
      session["count"] += 1
      render :counting_show
    when '/params'
      render_content(params.to_json, "text/json")
    end
  end
end

server.mount_proc '/' do |req, res|
  MyController.new(req, res).go
end

server.start
