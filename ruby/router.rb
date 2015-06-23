require_relative 'database'
def route query,id,type,x,y,contract,time

d = Database.instance
# d.connect
  case query
    when '/add'
         d.insert id,type,x,y,contract,time
    when '/remove'
      d.remove id
    when '/move'
      d.update id,x,y
    when '/getShopIncome'
      d.resetTime id
    when '/startContract'
      d.updateContract id, contract
    when '/getFactoryIncome'
      d.resetTime id
      d.updateContract id,contract
  end


end
