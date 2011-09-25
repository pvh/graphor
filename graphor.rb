class Graphor < Sinatra::Base
  set :public, File.dirname(__FILE__) + '/public'

  get '/' do
      File.read(File.join('public', 'index.html'))
  end

  get '/:id' do
    erb :query
  end

  post "/" do
    p = Query[params["parent"]]
    q = Query.create(
      :created_at => Time.now(),
      :alias => (0...8).map{ ('a'..'z').to_a[rand(26)] }.join,
      :database_url => params["database_url"] || p[:database_url],
      :query => params["query"],
      :parent_alias => params["parent"])
    redirect q[:alias]
  end

  delete "/:id" do
    q = Query[:alias => params["id"]]
    q.destroy
  end

  get "/:id/data" do
    query = Query[:alias => params["id"]]
    {:data => query.execute,
     :query => query[:query],
     :alias => query[:alias]
    }.to_json
  end
end
