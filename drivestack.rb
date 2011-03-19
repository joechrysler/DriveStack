require 'rubygems'
require 'sinatra'
require 'haml'
require 'sqlite3'
require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-types'
require 'ccsv'

configure :development do
    DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/_drives2.db")
end

require 'models/drive'

configure :development do
  DataMapper.auto_migrate!
end

# set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
  "Hello World!"
end

get '/parse' do
  result = ""
  counter = 0

  Ccsv.foreach('data.csv') do |row|
    counter += 1
    
    @models = DriveModel.get(:model_number => row[1])
    if (@models == nil)
      newModel = {:model_number => row[1],
                  :brand        => row[2],
                  :size         => row[3],
                  :speed        => row[4],
                  :interface    => row[5]}
      @model = DriveModel.new(newModel)
      @model.save
    end
    newdrive = {:bn => row[0]}
    @drive = Drive.new(newdrive)
    unless (@drive.save)
      result = :failure
    end
      


    File.open('models.txt', 'a') { |f| f.puts @models }

    #@drive = Drive.new(newdrive)
    #if @drive.save
      #line = "#{row[0]},#{row[1]},#{row[2]},#{row[3]},#{row[4]},#{row[5]}"
      #result += "drive #{counter} saved as ##{@drive.bn}<br />\n"
      #File.open('done.csv', 'a') { |f| f.puts line }
    #else
      #result = "failure"
    #end
  end

  if result == :failure
    result
  else
    redirect('/list')
  end
end

get '/list' do
  @title = 'List Drives'
  @drives = Drive.all()
  haml :list
end
get '/forget/:bn' do
  drive = Drive.get(params[:bn])
  drive.destroy unless drive.nil?
  redirect('/list')
end
