require 'active_support/core_ext'
require 'webrick'
require_relative 'rails_lite'

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go

    # case @req.path
    # when "/redirect"
    #   redirect_to('http://www.google.com')
    # when "/render"
    #   render_content(@req.query["content"], "text/text")
    # end

    # after you have template rendering, uncomment:
   render :show

    # after you have sessions going, uncomment:
#    session["count"] ||= 0
#    session["count"] += 1
#    render :counting_show
  end
end

server.mount_proc '/' do |req, res|
  MyController.new(req, res).go
end

server.start
