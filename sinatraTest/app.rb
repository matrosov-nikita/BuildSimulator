require 'sinatra'
require_relative 'database'
require_relative 'building'

def valid_numbers(*array)
  array.each do |e|
    el = Integer(e) rescue false
    return false if !el
  end
  true
end

def valid_string(*array_of_string)
  types = Building.getAllTypes
  array_of_string.each do |el|
    return false unless types.include? el.intern
  end
  true
end

def valid_coordinates(x, y)
  hRange = Building.getHorizontalRange
  vRange = Building.getVerticalRange
  hRange.include?(x) && vRange.include?(y)
end

get '/addBuilding' do
  x = params['x']
  y = params['y']
  type=params['type']
  if valid_coordinates(x.to_i, y.to_i) && valid_string(type)
    return Building.addBuidling(x, y, type).to_s
  end
  "false"
end

get '/removeBuilding' do
  id = params['id']
  return Building.remove(id).to_s if valid_numbers(id)
  Building.generateXMLByBuilding id
end

get '/generateXMLByBuilding' do
  id = params['id']
  return Building.generateXMLByBuilding(id.to_i) if valid_numbers(id)
end

get '/moveBuilding' do
  id = params['id']
  new_x = params['new_x']
  new_y = params['new_y']
  if valid_numbers(id) && valid_coordinates(new_x.to_i, new_y.to_i)
    return Building.move(id, new_x, new_y).to_s
  end
  Building.generateXMLByBuilding(id)
end

get '/startContract' do
  id = params['id']
  contract = params['contract']
  if valid_numbers(id) && !Building.existContract(id)
    return Building.startContract(id, contract).to_s
  end
  Building.generateXMLByBuilding id
end

get '/getField' do
  Building.generateXMLByTable
end

get '/isBuildComplete' do
  id = params['id']
  return Building.isBuildComplete(id).to_s if valid_numbers(id)
end

get '/getShopIncome' do
  id = params['id']
  return Building.getShopIncome(id).to_s if valid_numbers(id)
  Building.generateXMLByBuilding id
end

get '/getFactoryIncome' do
  id = params['id']
  return Building.getFactoryIncome(id).to_s if valid_numbers(id)
  Building.generateXMLByBuilding id
end



