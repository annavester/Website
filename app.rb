require 'rubygems'
require 'compass'
require 'sinatra'
require 'haml'

set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :public_folder, 'static'
set :views, "views"

configure do
  set :haml, {:format => :html5, :escape_html => true}
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.config'))
end

module ConditionalHtmlHelper
  # Implements the Paul Irish IE conditional comments HTML tag--in HAML.
  # http://paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/
  def cc_html(options={}, &blk)
    attrs = options.map { |(k, v)| " #{h k}='#{h v}'" }.join('')
    [ "<!--[if lt IE 7 ]> <html#{attrs} class='ie6'> <![endif]-->",
      "<!--[if IE 7 ]>    <html#{attrs} class='ie7'> <![endif]-->",
      "<!--[if IE 8 ]>    <html#{attrs} class='ie8'> <![endif]-->",
      "<!--[if IE 9 ]>    <html#{attrs} class='ie9'> <![endif]-->",
      "<!--[if (gt IE 9)|!(IE)]><!--> <html#{attrs}> <!--<![endif]-->",
      capture_haml(&blk).strip,
      "</html>"
    ].join("\n")
  end

  def h(str); Rack::Utils.escape_html(str); end
end

helpers ConditionalHtmlHelper

get '/css/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass(:"stylesheets/#{params[:name]}", Compass.sass_engine_options )
end

get '/' do
  haml :index
end

get '/projects/' do
  haml :projects
end

get '/resume/' do
  haml :resume
end

get '/contact/' do
  haml :contact
end