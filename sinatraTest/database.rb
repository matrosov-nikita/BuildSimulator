require 'pg'
class Database

  class << self
    def connect
      conn = PG.connect(
          :dbname => 'building_db',
          :user => 'db_admin',
          :password => 'qwerty',
          :host => 'localhost',
          :port => 5432)
      return conn
    end

    def get_all_buildings
      yield @@conn.exec("select * from buildings") if block_given?
    end

    def get_building id
      yield @@conn.exec("select * from buildings where build_id=#{id}") if block_given?
    end

    def add_building hash
      @@conn.exec("insert into buildings(type,x,y,contract,time)
                       values('#{hash["type"]}',#{hash["x"]},#{hash["y"]},#{hash["contract"]},'#{hash["time"]}') returning build_id;")
    end

    def get_contract id
      @@conn.exec("select contract from buildings where build_id=#{id}")
    end

    def exist_coordinates
      yield @@conn.exec("select x,y from buildings ") if block_given?
    end

    def exist_id id
      yield @@conn.exec("select count(build_id) from buildings where build_id=#{id}")
    end
    def get_coins
      @@conn.exec("select coins from fields")
    end

    def get_type id
      @@conn.exec("select type from buildings where build_id=#{id}")
    end

    def decrease_coins sum, coins
      @@conn.exec("update fields set coins=#{sum-coins}")
    end

    def increase_coins sum, coins
      @@conn.exec("update fields set coins=#{sum+coins}")
    end

    def remove_building id
      @@conn.exec("delete from buildings where build_id=#{id}")
    end

    def move_building id, new_x, new_y
      @@conn.exec("update buildings set x=#{new_x}, y=#{new_y} where build_id=#{id} ")
    end

    def start_contract id, contract
      @@conn.exec("update buildings set contract=#{contract}, time='#{Time.now}' where build_id=#{id} ")
    end

    def get_shop_income id
      @@conn.exec("update buildings set time='#{Time.now}' where build_id=#{id}")
    end

    def get_factory_income id
      @@conn.exec("update buildings set contract=#{0} where build_id=#{id}")
    end

    def get_time id
      @@conn.exec("select time from buildings where build_id=#{id}")
    end
  end
  @@conn = connect
end

