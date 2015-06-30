class Conf
  @@contract = {
      nil => {"profit"=>10, "time_work"=>300 },
      1 =>{"cost"=>5, "profit"=>30, "time_work"=>300 },
      2 => {"cost"=>10, "profit"=>50, "time_work"=>900 }
  }
  @@buildings = {
      "auto_workshop"=>20,
      "factory"=>30
  }
  @@horizontalRange = Range.new(0,10)
  @@verticalRange = Range.new(0,6)
end
