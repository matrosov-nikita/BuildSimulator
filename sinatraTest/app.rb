require 'sinatra'
require_relative 'database'
require_relative 'manager'
conn = connect

get '/addBuilding' do
  x = params['x']
  y = params['y']
  type=params['type']
  contract = 'null'
  coins=20
  if type=="factory"
    contract = 0
    coins=30
  end
  time=Time.now
  if !existBuilding(conn,x,y) && checkCoins(conn,coins)
    conn.exec("insert into buildings(type,x,y,contract,time)
                       values('#{type}',#{x},#{y},#{contract},'#{time}');")
  decreaseCoins conn,coins
    return "true"
  end
  "false"
end

get '/removeBuilding' do
  x = params['x']
  y = params['y']
  if existBuilding conn,x,y
    conn.exec("delete from buildings where x=#{x} and y=#{y}")
    return "true"
  end
  "false"
end

get '/moveBuilding' do
  x = params['x']
  y = params['y']
  new_x = params['new_x']
  new_y = params['new_y']
  if !existBuilding conn,new_x,new_y
    conn.exec("update buildings set x=#{new_x}, y=#{new_y} where x=#{x} and y=#{y} ")
    return "true"
  end
  "false"
end

get '/startContract' do
  contract = params['contract']
  x=params['x']
  y=params['y']

  if existBuilding(conn,x,y) && !existContract(conn,x,y)
  conn.exec("update buildings set contract=#{contract}, time='#{Time.now}' where x=#{x} and y=#{y} ")
    return "true"
  end
    "false"
end

get '/getField' do
  generateXMLByTable conn
end


get '/isBuildComplete' do
  time = nil
  contract=nil
  conn.exec("select time,contract from buildings where x=#{params['x']} and y=#{params['y']}") do |result|
    contract = result[0]['contract']
    time =  Time.parse(result[0]['time'])
  end
  time = Time.now - time

  if time >= getWorkTime(contract)
    return "true"
  end
  "false"
end


get '/getShopIncome' do
x = params['x']
y = params['y']
if existBuilding(conn,x,y)

  conn.exec("update buildings set time='#{Time.now}' where x=#{x} and y=#{y}")
return "true"
end
  "false"
end

get '/getFactoryIncome' do
x = params['x']
y = params['y']
if existBuilding(conn,x,y) && existContract(conn,x,y)
  conn.exec("update buildings set contract=#{0} where x=#{x} and y=#{y}")
  return "true"
end
"false"
end

