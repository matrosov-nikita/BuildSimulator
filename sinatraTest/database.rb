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
  yield @@conn.exec("select * from buildings") if block_given?
end

def update_building hash
 @@conn.exec("insert into buildings(type,x,y,contract,time)
                       values('#{hash["type"]}',#{hash["x"]},#{hash["y"]},#{hash["contract"]},'#{hash["time"]}');")
end

def get_contract x,y
  @@conn.exec("select contract from buildings where x=#{x} and y=#{y}")
end

def exist
 yield @@conn.exec("select x,y from buildings ") if block_given?
end

def get_coins
  @@conn.exec("select coins from fields")
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

def get_time x,y
  @@conn.exec("select time from buildings where x=#{x} and y=#{y}")
end


