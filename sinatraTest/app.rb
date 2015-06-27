require 'sinatra'
require_relative 'database'
require_relative 'building'

def valid_numbers(*array_of_numbers)
  array_of_numbers.each do |el|
    elem = Integer(el) rescue false
    return false if  elem<0
  end
  true
end

def valid_string(*array_of_string)
  array_of_string.each{ |el| return false if !check_type(el)}
  true
end

get '/addBuilding' do
  x = params['x']
  y = params['y']
  type=params['type']
  if (valid_numbers(x,y) && valid_string(type))
     return (Building.instance.addBuidling(x,y,type)!=nil).to_s
  end
  "false"
end

get '/removeBuilding' do
  x = params['x']
  y = params['y']
  if valid_numbers(x,y)
    return Building.instance.remove(x,y).to_s
  end
  "false"
end

get '/moveBuilding' do
  x = params['x']
  y = params['y']
  new_x = params['new_x']
  new_y = params['new_y']
  if valid_numbers(x,y)
    return Building.instance.move(x,y,new_x,new_y).to_s
  end
  "false"
end


get '/startContract' do
  x = params['x']
  y = params['y']
  contract = params['contract']
  if valid_numbers(x,y) && (1..2).include?(contract.to_i)
    return Building.instance.startContract(x,y,contract).to_s
  end
  "false"
end

get '/getField' do
  Building.instance.generateXMLByTable
end


get '/isBuildComplete' do
  x = params['x']
  y = params['y']
  if valid_numbers(x,y)
    p Building.instance.isBuildComplete(x,y).to_s
    return Building.instance.isBuildComplete(x,y).to_s
  end
  "false"
end



get '/getShopIncome' do
  x = params['x']
  y = params['y']
  if valid_numbers(x,y)
    return Building.instance.getShopIncome(x,y).to_s
  end
  "false"
end


get '/getFactoryIncome' do
  x = params['x']
  y = params['y']
  if valid_numbers(x,y)
    return Building.instance.getFactoryIncome(x,y).to_s
  end
  "false"
end



