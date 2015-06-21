require   'pg'
require 'nokogiri'
require 'singleton'

class Database
  include Singleton
def connect
  @conn = PG.connect(
      :dbname => 'building_db',
      :user => 'db_admin',
      :password => 'qwerty',
      :host => 'localhost',
      :port => 5432)
end


def insert id,type,x,y,contract,time
if (type=='auto_workshop')
  @conn.exec("insert into buildings(build_id,type,x,y,contract,time)
                       values(#{id},'#{type}',#{x},#{y},null,#{time});")
else
  @conn.exec("insert into buildings(build_id,type,x,y,contract,time)
                       values(#{id},'#{type}',#{x},#{y},#{contract},#{time});")
end
end

def remove id
  @conn.exec("delete from buildings where build_id = #{id}")
end

def update id,x,y
  @conn.exec("update buildings set x=#{x}, y=#{y} where build_id = #{id}")
end

def resetTime id
  @conn.exec("update buildings set time=0 where build_id = #{id}")
end

def updateContract id,contract
  @conn.exec("update buildings set contract=#{contract} where build_id = #{id}")
end

  def updateField xmlStr

  xml_doc = Nokogiri::XML(xmlStr)
  xml_doc.xpath("//field").map { |child|
   @conn.exec("update fields set coins=#{child["coins"]}")
   child.children.map { |n|
     if n.elem?
       id=n["id"]
       type=n.name
       x=n["x"]
       y=n["y"]
       if (n["contract"]!=nil)
         contract = n["contract"]
       else
         contract = 'NULL'
       end

       time = n["time"]
       @conn.exec("update buildings set
                                  type='#{type}',
                                  x=#{x},
                                  y=#{y},
                                  time=#{time},
                                   contract = #{contract}
                     where build_id=#{id}")
end
  }
  }
  end


def generate_xml_by_table
  builder = Nokogiri::XML::Builder.new do |xml|
coins = 0
    @conn.exec("select coins from fields") do |res|
     res.each do |c|
       coins = c["coins"]
     end
    end
  xml.field('coins'=>coins) {
   @conn.exec("select * from buildings") do |result|
    result.each do |row|
      if (row['type']=='factory')
      xml.factory("id"=>row['build_id'],"x"=>row['x'],"y"=>row['y'],"contract"=>row['contract'],"time"=>row['time'])
      else
        xml.auto_workshop("id"=>row['build_id'],"x"=>row['x'],"y"=>row['y'],"time"=>row['time'])
      end
    end
    end
  }
   end
  builder.doc.root.to_s
end




  def create_table_buildings
    @conn.exec("CREATE TABLE buildings(
	build_id  PRIMARY KEY,
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

 def drop_table
   @conn.exec("DROP TABLE buildings;")
   @conn.exec("drop table fields;")
 end

  def disconnet
    @conn.close
  end

  end