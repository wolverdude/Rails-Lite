require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @params = Params::parse(@req, route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    !!@response_built
  end

  def redirect_to(url)
    raise "Can't respond twice" if already_rendered?

    @res.set_redirect(WEBrick::HTTPStatus::Found, url)
    after_respond
  end

  def render_content(content, type)
    raise "Can't respond twice" if already_rendered?

    @res.body = content
    @res.content_type = type
    after_respond
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore.sub(/_controller$/, '')

    filename = "views/#{controller_name}/#{template_name}.html.erb"

    template = ERB.new(File.read(filename))
    content = template.result(binding)

    render_content(content, 'text/html')
  end

  def invoke_action(name)
  end

  private
  def after_respond
    @session and @session.store_session(@res)
    @response_built = true
  end
end
