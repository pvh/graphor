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

delete "/:id" do
  q = Query[:alias => params["id"]]
  q.destroy
end

get "/:id/data" do
  grab_the_data(Query[:alias => params["id"]])
end

post "/" do
  p = Query[params["parent"]]

  puts params.inspect
  puts p.inspect

  q = Query.create(
    :created_at => Time.now(),
    :alias => (0...8).map{ ('a'..'z').to_a[rand(26)] }.join,
    :database_url => params["database_url"] || p[:database_url],
    :query => params["query"],
    :parent_alias => params["parent"])
  redirect q[:alias]
end

get '/:id' do
  erb :query
end

helpers do
  def grab_the_data(query)
    {:data => query.execute,
     :query => query[:query],
     :alias => query[:alias]
    }.to_json
  end
end

end
