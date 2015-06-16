require   'pg'
require 'nokogiri'

class Database
def connect
  @conn = PG.connect(
      :dbname => 'building_db',
      :user => 'db_admin',
      :password => 'qwerty',
      :host => 'localhost',
      :port => 5432)
end

  def saveBuilding xmlStr
     drop_table
    create_table_buildings
    create_table_field
    reset_building_seq
  xml_doc = Nokogiri::XML(xmlStr)
  xml_doc.xpath("//field").map { |child|
    puts child
    @conn.exec("insert into fields(coins)
                 values(#{child["coins"]});")
   child.children.map { |n|
     if n.elem?
    x = n["x"]
    y = n["y"]
    time = n["time"]
    contract =n["contract"]
  if (contract==nil)
    @conn.exec("insert into buildings(type,x,y,contract,time)
                 values('auto_workship',#{x},#{y},null,#{time});")
    else
    @conn.exec("insert into buildings(type,x,y,contract,time)
                 values('factory',#{x},#{y},#{contract},#{time});")
  end

end
  }
  }
  generate_xml_by_table
  end

  # def removeBuilding xmlStr
  #   xml_doc = Nokogiri::XML(xmlStr)
  #   xml_doc.xpath("//field").map { |child|
  #     child.children.map { |n|
  #       if n.elem?
  #         x = n["x"]
  #         y = n["y"]
  #         time = n["time"]
  #         contract =n["contract"]
  #         @conn.exec("delete from buildings where x=#{x} and y=#{y}")
  #       end
  #     }
  #   }
  #   generate_xml_by_table
  # end


def generate_xml_by_table

  builder = Nokogiri::XML::Builder.new do |xml|
coins = 0
    @conn.exec("select coins from fields") do |res|
     res.each do |c|
       coins = c["coins"]
     end
    end
puts coins
  xml.field('coins'=>coins) {
   @conn.exec("select * from buildings") do |result|
    result.each do |row|
      if (row['type']=='factory')
      xml.factory("x"=>row['x'],"y"=>row['y'],"contract"=>row['contract'],"time"=>row['time'])
      else
        xml.auto_workshop("x"=>row['x'],"y"=>row['y'],"time"=>row['time'])
      end
    end
    end
  }

   end


  puts builder.doc.root.to_s
  builder.doc.root.to_s
end




  def create_table_buildings
    @conn.exec("CREATE TABLE buildings(
	build_id serial PRIMARY KEY,
	type VARCHAR (20)  NOT NULL,
  x int not null,
  y int not null,
  contract int,
  time int not null
);")
  end

def create_table_field
  @conn.exec("create table fields(
field_id serial PRIMARY KEY,
coins int not null);")
end

def reset_building_seq
  @conn.exec("alter sequence buildings_build_id_seq restart with 1")
end

 def drop_table
   puts "drop building"
   @conn.exec("DROP TABLE buildings;")
   puts "drop fields"
   @conn.exec("drop table fields;")
 end

  def disconnet
    @conn.close
  end

  end