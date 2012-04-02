require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  haml :index
  #'This Website is being upgraded'
end
