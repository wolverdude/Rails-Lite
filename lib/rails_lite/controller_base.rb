require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
  end

  def session
  end

  def already_rendered?
    !!@response_built
  end

  def redirect_to(url)
    raise "Can't respond twice" if already_rendered?

    @res.set_redirect(WEBrick::HTTPStatus::Found, url)
    @response_built = true
  end

  def render_content(content, type)
    raise "Can't respond twice" if already_rendered?

    @res.body = content
    @res.content_type = type
    @response_built = true
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
end
