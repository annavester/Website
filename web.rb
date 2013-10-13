require 'rubygems'
require 'compass'
require 'sinatra'
require 'haml'
require 'net/http'
require 'open-uri'
require 'json'

set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :public_folder, 'static'

configure do
  set :haml, {:format => :html5}
  set :views, "#{File.dirname(__FILE__)}/views"
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.config'))
  SiteConfig = OpenStruct.new(
    :title => 'Web Developer',
    :author => 'Anna Vester',
    :url_base => 'http://annavester.com/'
  )
end

module ConditionalHtmlHelper
  # Implements the Paul Irish IE conditional comments HTML tag--in HAML.
  # http://paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/
  def cc_html(options={}, &blk)
    attrs = options.map { |(k, v)| " #{h k}='#{h v}'" }.join('')
    [ "<!--[if lt IE 7]><html#{attrs} class='no-js lt-ie9 lt-ie8 lt-ie7 ie'> <![endif]-->",
      "<!--[if IE 7]><html#{attrs} class='no-js lt-ie9 lt-ie8 ie'> <![endif]-->",
      "<!--[if IE 8]><html#{attrs} class='no-js lt-ie9 ie'> <![endif]-->",
      "<!--[if gt IE 8]><html#{attrs} class='no-js ie'> <![endif]-->",
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
  begin
    query = '/1/statuses/user_timeline.json?include_rts=true&screen_name=annavester&count=5'
    uri = URI.parse('https://api.twitter.com/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(query)
    response = http.request(request)
    @tweets = JSON.parse(response.body)
  rescue StandardError, Timeout::Error => e
    @tweets = []
  end

  begin
    query = '/api/v1/latest_read/10/'
    uri = URI.parse('http://books.annavester.com/')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(query)
    response = http.request(request)
    @latest_reads = JSON.parse(response.body)
  rescue StadardError, Timeout::Error => e
    @latest_reads = []
  end

  begin
    query = '/api/v1/reading_now/5/'
    uri = URI.parse('http://books.annavester.com/')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(query)
    response = http.request(request)
    @reading_now = JSON.parse(response.body)
  rescue
    @reading_now = []
  end
  
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

post '/contact/' do  
  "You said '#{params[:message]}'"  
end  
