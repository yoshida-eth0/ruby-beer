require 'beer/ingredient'
require 'beer/malt'
require 'beer/mashing_recipe'
require 'beer/wort'
require 'beer/hop'
require 'beer/ibu'
require 'beer/boil_recipe'

module Beer
  # litre = gallon / UK_GALLON
  # gallon = litre * UK_GALLON
  # kg = pound / POUND
  # pound = kg * POUND
  UK_GALLON = 4.54609     # 英ガロン (Imperial gallon)
  US_GALLON = 3.785411784 # 米国液量ガロン (U.S. fluid gallon)
  GALLON = UK_GALLON
  POUND = 0.45359237

  OZ = 0.028349523125
  FEET = 0.3048
  
end
