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

def generateXMLByTable(conn)
  coins = 0
   conn.exec("select coins from fields") do |result|
  result.each do |r|
    coins = r["coins"]
  end
   end
  resultString = "<field coins='#{coins}'>"
conn.exec("select * from buildings ") do |result|
  result.each do |r|
    if (r["type"]!="factory")
    resultString+="<#{r["type"]} x='#{r["x"]}' y='#{r["y"]}' state='#{getState(r)}'/>"
    else
      resultString+="<#{r["type"]} x='#{r["x"]}' y='#{r["y"]}' contract='#{r["contract"]}' state='#{getState(r)}'/>"
  end
end
  resultString+="</field>"
   resultString
end
  end



def create_table_buildings conn
  conn.exec("create table buildings(
	build_id serial primary key,
	type VARCHAR (20)  not null,
  x int not null,
  y int not null,
  contract int,
  time_start timestamp
);")

end

