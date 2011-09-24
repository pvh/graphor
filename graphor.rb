require 'sinatra'

require 'sequel'
require 'json'

class Graphor < Sinatra::Base

get '/' do
    File.read(File.join('public', 'index.html'))
end

get "/data" do
  db = Sequel.connect(params["database_url"])
  x = []; y = []
  xlabels = [];
  db.fetch(params["query"]).each do |row|
    if row[:x].instance_of? Time
      xlabels << row[:x].to_s
      x << row[:x].to_i
    else
      x << row[:x]
    end
    y << row[:y]
  end
  {:x => x, :xlabels => xlabels, :y => y}.to_json
end

end
