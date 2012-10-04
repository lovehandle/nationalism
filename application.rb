require "rubygems"

require "rack"
require "sinatra"
require "toto"
require "haml"


@site        = "Ryan Closner"
@title       = "Ryan Closner - Home"
@description = ""
@keywords    = ""
@domain      = "ryanclosner.com"

# Sinatra App

class SinatraApp < Sinatra::Base
  error do
    e = request.env["sinatra.error"]
    Kernel.puts e.backtrace.join("/n")
    "Application error"
  end

  not_found do
    File.read(File.join('public', '404.html'))
  end

  get "/" do
    haml :home
  end
end

