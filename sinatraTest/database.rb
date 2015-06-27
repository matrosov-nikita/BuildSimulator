require 'pg'

def connect
  conn = PG.connect(
      :dbname => 'building_db',
      :user => 'db_admin',
      :password => 'qwerty',
      :host => 'localhost',
      :port => 5432)
  return conn
end
@@conn = connect

def get_all_buildings
  @@conn.exec("select * from buildings")
end

def update_building hash
 @@conn.exec("insert into buildings(type,x,y,contract,time)
                       values('#{hash["type"]}',#{hash["x"]},#{hash["y"]},#{hash["contract"]},'#{hash["time"]}');")
end


def get_contract x,y
  @@conn.exec("select contract from buildings where x=#{x} and y=#{y}")
end


def get_cost_contract contract
  @@conn.exec("select cost from contracts where contract_id=#{contract}")
end
def get_profit_contract contract
  @@conn.exec("select profit from contracts where contract_id=#{contract}")
end
def get_timework_contract contract
  @@conn.exec("select time_work from contracts where contract_id=#{contract}")
end

def exist x,y
  @@conn.exec("select x,y from buildings ")
end


def get_coins
  p @@conn.exec("select coins from fields")
  @@conn.exec("select coins from fields")
end


def check_type type
  @@conn.exec("select type from build_cost") do |result|
    result.each do |r|
      return true if r["type"]==type
    end
    end
    false
end

def get_type x,y
  @@conn.exec("select type from buildings where x=#{x} and y=#{y}")
end

def decrease_coins sum,coins
@@conn.exec("update fields set coins=#{sum-coins}")
end

def increase_coins sum,coins
  @@conn.exec("update fields set coins=#{sum+coins}")
end

def remove_building x,y
  @@conn.exec("delete from buildings where x=#{x} and y=#{y}")
end

def move_building x,y,new_x,new_y
  @@conn.exec("update buildings set x=#{new_x}, y=#{new_y} where x=#{x} and y=#{y} ")
end

def start_contract x,y,contract
  @@conn.exec("update buildings set contract=#{contract}, time='#{Time.now}' where x=#{x} and y=#{y} ")
end

def get_shop_income x,y
  @@conn.exec("update buildings set time='#{Time.now}' where x=#{x} and y=#{y}")
end
def get_factory_income x,y
  @@conn.exec("update buildings set contract=#{0} where x=#{x} and y=#{y}")
end

def get_factory_cost
 @@conn.exec("select cost from build_cost where type='factory'")
end
def get_shop_cost
@@conn.exec("select cost from build_cost where type='auto_workshop'")
end

def get_time x,y
  @@conn.exec("select time from buildings where x=#{x} and y=#{y}")
end


