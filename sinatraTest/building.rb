require 'singleton'
require_relative 'database'
require_relative 'conf'


class Building
  include Singleton

  @@config=Conf.class_variable_get(:@@contract)

    def existBuilding x,y
      exist do |res|
        res.each do |result|
          return true if result['x']==x.to_s && result['y']==y.to_s
        end
        false
      end
    end

    def getCoins
       get_coins[0]['coins'].to_i
    end

    def checkCoins coins
       getCoins>=coins
    end

    def increaseCoins coins
      increase_coins getCoins,coins
    end
    def decreaseCoins coins
      decrease_coins getCoins,coins
    end

    def getContract x,y
      get_contract(x,y)[0]['contract']
    end

    def existContract x,y
      (@@config.keys[1]..@@config.keys[2]).include?(getContract(x,y).to_i)
    end

    def getShopCost
      Conf.class_variable_get(:@@buildings)["auto_workshop"]
    end

    def getFactoryCost
      Conf.class_variable_get(:@@buildings)["factory"]
    end

    def getTypeBuilding x,y
       get_type(x,y)[0]['type']
    end

    def getCostByContract contract
      @@config[contract]["cost"]
    end

    def getProfitByContract contract
      @@config[contract]["profit"]
    end

    def getTimeWorkByContract contract
      @@config[contract]["time_work"]
    end

    def getTime x,y
      get_time(x,y)[0]['time']
    end

  def addBuidling x,y,type
    contract = 'null'
    coins=getShopCost
    if type=="factory"
      contract = 0
      coins=getFactoryCost
    end
    time=Time.now
    if (!existBuilding(x,y) && checkCoins(coins))
      update_building({"x"=>x,"y"=>y,"type"=>type,"contract"=>contract,"time"=>time})
      decreaseCoins coins
    end
  end

  def remove x,y
    if existBuilding(x,y)
      coins =  getTypeBuilding(x,y)=="factory"?getFactoryCost/2:getShopCost/2
      increaseCoins(coins)
      remove_building(x,y)
      return true
      end
    false
  end

  def move x,y,new_x,new_y
    if !existBuilding(new_x,new_y)
      move_building x,y,new_x,new_y
      return true
    end
    false
  end

  def startContract x,y,contract
   cost = getCostByContract(contract.to_i)
  if  checkCoins(cost) && !existContract(x,y)
    start_contract(x,y,contract)
    decreaseCoins cost
    return true
  end
  false
  end

  def isBuildComplete x,y
      time = Time.now - Time.parse(getTime(x,y))
      time+1 >= getWorkTime(getContract(x,y))
  end

  def getShopIncome x,y
    if  existBuilding(x,y) && isBuildComplete(x,y)
      get_shop_income(x,y)
      increaseCoins @@config[nil]["profit"]
      return true
    end
    false
  end

  def getFactoryIncome x,y
    if existContract(x,y) && isBuildComplete(x,y)
      contract = getContract(x,y).to_i
      profit = getProfitByContract(contract)
      increaseCoins profit
      get_factory_income(x,y)
      return true
    end
    false
  end

  def getWorkTime contract
    return @@config[nil]["time_work"] if (contract==nil)
    getTimeWorkByContract contract.to_i
  end


  def getState building
    contract = building['contract']
    return 'stand' if contract == "0"
    if Time.now - Time.parse(building['time']) < getWorkTime(contract)
      return (getWorkTime(contract) - (Time.now - Time.parse(building['time'])) ).to_s
    else
      'collect'
    end
  end

  def generateXMLByTable
    coins = getCoins
    resultString = "<field coins='#{coins}'>"
    get_all_buildings do |result|
      result.each do |r|
        if (r['type']!="factory")
          resultString<<"<#{r["type"]} x='#{r["x"]}' y='#{r["y"]}' state='#{getState(r)}'/>"
        else
          resultString<<"<#{r["type"]} x='#{r["x"]}' y='#{r["y"]}' contract='#{r["contract"]}' state='#{getState(r)}'/>"
        end
      end
      resultString<<"</field>"
      resultString
    end
    end
end

