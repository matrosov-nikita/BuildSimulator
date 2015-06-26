require_relative 'database'

def existBuilding conn,x,y
  conn.exec("select x,y from buildings ") do |result|
    result.each do |r|
     if r['x']==x && r['y']==y
       return true
     end
    end
  end
  false
end

def existContract conn,x,y
  contract = 0
  conn.exec("select contract from buildings where x=#{x} and y=#{y}") do |result|
    contract = result[0]['contract']
  end
  return contract!="0"
end

def checkCoins conn,coins
  t_coins=0
  conn.exec("select coins from fields") do |result|
    t_coins= result[0]['coins']
  end
 return t_coins.to_i>=coins
end
def decreaseCoins conn,coins
  t_coins=0
  conn.exec("select coins from fields") do |result|
    t_coins= result[0]['coins']
  end
  conn.exec("update fields set coins=#{t_coins.to_i-coins}")
end

def getWorkTime contract
  (contract=="1" || contract==nil)?300:900
end


def getState building

  contract = building['contract']
  return 'stand' if contract.to_i == 0 && contract!=nil

  if Time.now - Time.parse(building['time']) < getWorkTime(building['contract'])
    return (getWorkTime(building['contract']) - (Time.now - Time.parse(building['time'])) ).to_s
  else
    'collect'
  end

end
