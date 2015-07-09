require_relative 'database'
require_relative 'conf'

class Building
  @@contracts=Conf.class_variable_get(:@@contract)
  @@buildings = Conf.class_variable_get(:@@buildings)
  @@horizRange = Conf.class_variable_get(:@@horizontalRange)
  @@verticalRange = Conf.class_variable_get(:@@verticalRange)
  class << self

    def getAllTypes
      @@buildings.keys
    end

    def getHorizontalRange
      @@horizRange
    end

    def getVerticalRange
      @@verticalRange
    end

    def existBuildingByCoordinates? x, y
      Database.exist_coordinates do |res|
        res.each do |result|
          return true if result['x']==x.to_s && result['y']==y.to_s
        end
        false
      end
    end

    def existBuildingById? id
      Database.exist_id(id) do |res|
        return false if res[0]['count'].to_i==0
      end
      true
    end

    def getCoins
      Database.get_coins[0]['coins'].to_i
    end

    def checkCoins coins
      getCoins>=coins
    end

    def increaseCoins coins
      Database.increase_coins getCoins, coins
    end

    def decreaseCoins coins
      Database.decrease_coins getCoins, coins
    end

    def getContract id
      Database.get_contract(id)[0]['contract']
    end

    def existContract id
      (@@contracts.keys[1]..@@contracts.keys[2]).include?(getContract(id).to_i)
    end

    def getShopCost
      @@buildings[:auto_workshop]
    end

    def getFactoryCost
      @@buildings[:factory]
    end

    def getTypeBuilding id
      Database.get_type(id)[0]['type']
    end

    def getCostByContract contract
      @@contracts[contract][:cost]
    end

    def getProfitByContract contract
      @@contracts[contract][:profit]
    end

    def getTimeWorkByContract contract
      @@contracts[contract][:time_work]
    end

    def getTime id
      Database.get_time(id)[0]['time']
    end

    def addBuidling x, y, type
      contract = 'null'
      coins=getShopCost
      if type=="factory"
        contract = 0
        coins=getFactoryCost
      end
      time=Time.now
      if (!existBuildingByCoordinates?(x, y) && checkCoins(coins))
        id = Database.add_building({"x" => x, "y" => y, "type" => type, "contract" => contract, "time" => time})
        decreaseCoins coins
        return id[0]["build_id"].to_i
      end
      "false"
    end

    def remove id
      if existBuildingById?(id)
        coins = @@buildings[getTypeBuilding(id).intern]/2
        increaseCoins(coins)
        Database.remove_building(id)
        return true
      end
      generateXMLByBuilding id
    end

    def move id, new_x, new_y
      if !existBuildingByCoordinates?(new_x, new_y)
        Database.move_building id, new_x, new_y
        return true
      end
      generateXMLByBuilding id
    end

    def startContract id, contract
      cost = getCostByContract(contract.to_i)
      if checkCoins(cost) && !existContract(id)
        Database.start_contract(id, contract)
        decreaseCoins cost
        return true
      end
      generateXMLByBuilding id
    end

    def isBuildComplete id
      time = Time.now - Time.parse(getTime(id))
      time+1 >= getWorkTime(getContract(id))
    end

    def getShopIncome id
      if isBuildComplete(id)
        Database.get_shop_income(id)
        increaseCoins @@contracts[nil][:profit]
        return true
      end
      generateXMLByBuilding id
    end

    def getFactoryIncome id
      if existContract(id) && isBuildComplete(id)
        contract = getContract(id).to_i
        profit = getProfitByContract(contract)
        increaseCoins profit
        Database.get_factory_income(id)
        return true
      end
      generateXMLByBuilding id
    end

    def getWorkTime contract
      return @@contracts[nil][:time_work] if (contract==nil)
      getTimeWorkByContract contract.to_i
    end

    def getState building
      contract = building['contract']
      return 'stand' if contract == "0"
      if Time.now - Time.parse(building['time']) < getWorkTime(contract)
        return (getWorkTime(contract) - (Time.now - Time.parse(building['time']))).to_s
      else
        'collect'
      end
    end

    def generateXMLByBuilding id
      Database.get_building(id.to_i) do |result|
        return generateXMLByRow result
      end
    end

    def generateXMLByTable
      coins = getCoins
      resultString = "<field coins='#{coins}'>"
      Database.get_all_buildings do |result|
        resultString<< generateXMLByRow(result)
      end
      resultString<<"</field>"
      resultString
    end


    def generateXMLByRow rows
      result_str=""
      rows.each do |r|
        if (r['type']!="factory")
          result_str<<"<#{r["type"]} id='#{r["build_id"]}' x='#{r["x"]}' y='#{r["y"]}' state='#{getState(r)}'/>"
        else
          result_str<<"<#{r["type"]} id='#{r["build_id"]}' x='#{r["x"]}' y='#{r["y"]}' contract='#{r["contract"]}' state='#{getState(r)}'/>"
        end
      end
      result_str
    end
  end
end




