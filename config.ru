require "rubygems"
require "toto"
require "./application"

use Rack::ShowExceptions
use Rack::CommonLogger

# Toto App for Blog

toto = Toto::Server.new do
  set :prefix, "/blog"
  set :title, @title 
  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
  set :summary,   :max => 500
  set :root, "home"
  set :url, "#{@domain}/blog/"
end

# Rack App to coordinate navigation between Sinatra and Toto

app = Rack::Builder.new do
  use Rack::CommonLogger

  map "/" do
    run SinatraApp
  end

  map "/blog" do
    run toto 
  end
end

run app 
