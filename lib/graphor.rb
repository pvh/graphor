require 'sinatra'

require 'sequel'
require 'json'

Sequel.connect(ENV["DATABASE_URL"])

require './lib/graphor/query'

