require 'sinatra'
require_relative 'database'
require_relative 'building'
require_relative 'conf'

def valid_numbers(*array)
  array.each do |e|
    el = Integer(e) rescue false
    return false if !el
  end
  true
end

def valid_string(*array_of_string)
  types = Conf.class_variable_get(:@@buildings).keys
  array_of_string.each do |el|
     return false unless types.include? el
    end
  true
end

def valid_coordinates(x,y)
  hRange = Conf.class_variable_get(:@@horizontalRange)
  vRange = Conf.class_variable_get(:@@verticalRange)
  hRange.include?(x) && vRange.include?(y)
end

get '/addBuilding' do
  x = params['x']
  y = params['y']
  type=params['type']
  if (valid_numbers(x,y) && valid_string(type) && valid_coordinates(x.to_i,y.to_i))
     return (Building.instance.addBuidling(x,y,type)!=nil).to_s
  end
  "false"
end

get '/removeBuilding' do
  x = params['x']
  y = params['y']
   return Building.instance.remove(x,y).to_s if valid_numbers(x,y)
  Building.instance.generateXMLByBuilding x,y
end

get '/generateXMLByBuilding' do
  return Building.instance.generateXMLByBuilding(params['x'].to_i,params['y'].to_i)
end

get '/moveBuilding' do
  x = params['x']
  y = params['y']
  new_x = params['new_x']
  new_y = params['new_y']
  if valid_numbers(x,y,new_x,new_y) && valid_coordinates(new_x.to_i,new_y.to_i)
    return Building.instance.move(x,y,new_x,new_y).to_s
  end
  Building.instance.generateXMLByBuilding(x,y)
end

get '/startContract' do
  config=Conf.class_variable_get(:@@contract)
  x = params['x']
  y = params['y']
  contract = params['contract']
   if valid_numbers(x,y) && (config.keys[1]..config.keys[2]).include?(contract.to_i)
     return Building.instance.startContract(x,y,contract).to_s
   end
  Building.instance.generateXMLByBuilding x,y
end

get '/getField' do
  Building.instance.generateXMLByTable
end

get '/isBuildComplete' do
  x = params['x']
  y = params['y']
  return Building.instance.isBuildComplete(x,y).to_s  if valid_numbers(x,y)
end

get '/getShopIncome' do
  x = params['x']
  y = params['y']
  return Building.instance.getShopIncome(x,y).to_s if valid_numbers(x,y)
  Building.instance.generateXMLByBuilding x,y
end

get '/getFactoryIncome' do
  x = params['x']
  y = params['y']
   return Building.instance.getFactoryIncome(x,y).to_s if valid_numbers(x,y)
  Building.instance.generateXMLByBuilding x,y
end



