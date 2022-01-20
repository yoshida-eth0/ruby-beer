module Beer
  module IBU
    # See also:
    #   https://homebrewacademy.com/ibu-calculator/
    class Average

      # @param cf [Float] 濃度係数、concentration factor (Final Volume / Pre-Boil Volume)
      # @param desired_ibu [Float] Target IBU
      # @param elevation [Float] 標高(メートル)
      def initialize(cf, desired_ibu=25, elevation=40)
        @algorithms = [
          Tinseth.instance,
          Rager.instance,
          Garetz.new(cf, desired_ibu, elevation),
        ]
      end

      # IBU
      #
      # @param wort [Wort] ウォート
      # @param weight [Float] ホップ添加量
      # @param mins [Float] 煮沸時間(分)
      # @param hop [Float] ホップ
      def ibu(wort, weight, mins, hop, gallon: GALLON)
        @algorithms.map {|algo|
          algo.ibu(wort, weight, mins, hop, gallon: gallon)
        }.sum / @algorithms.length
      end

    end
  end
end
