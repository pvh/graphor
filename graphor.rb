require 'sinatra'

require 'sequel'
require 'json'

Sequel.connect(ENV["DATABASE_URL"])

require './lib/graphor/query'

class Graphor < Sinatra::Base

set :public, File.dirname(__FILE__) + '/public'

get '/' do
    File.read(File.join('public', 'index.html'))
end

get "/data" do
  grab_the_data(params["database_url"], params["query"])
end

delete "/:id" do
  q = Query[:alias => params["id"]]
  q.destroy
end

get "/:id/data" do
  q = Query[:alias => params["id"]]
  grab_the_data(q[:database_url], q[:query])
end

post "/" do
  q = Query.create(
    :alias => (0...8).map{ ('a'..'z').to_a[rand(26)] }.join,
    :database_url => params["database_url"],
    :query => params["query"])
  q[:alias]
end

get '/:alias' do
  File.read(File.join('public', 'index.html'))
end


helpers do
  def grab_the_data(database_url, query)
    db = Sequel.connect(database_url)
    x = []; y = []
    xlabels = [];
    db.fetch(query).each do |row|
      if row[:x].instance_of? Time
        xlabels << row[:x].to_s
        x << row[:x].to_i
      else
        x << row[:x]
      end
      y << row[:y]
    end
    {:x => x, :xlabels => xlabels, :y => y, :query => query}.to_json
  end
end

end
