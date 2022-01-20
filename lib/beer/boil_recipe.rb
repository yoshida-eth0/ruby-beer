require 'singleton'

module Beer
  class BoilRecipe
    attr_reader :hops

    def initialize
      @hops = []
    end

    def add(weight, mins, hop)
      @hops << [weight, mins, hop]
      self
    end

    # @prram evaporation_rate = [Float] 推定蒸発率 (ex: 0.10)
    def boil(wort, evaporation_rate=0.0, algorithm=nil, gallon: GALLON)
      algorithm ||= IBU::Average.new(1.0 - evaporation_rate)
      hops.map {|weight, mins, hop|
        algorithm.ibu(wort, weight, mins, hop, gallon: gallon)
      }.sum || 0.0
    end

  end
end
