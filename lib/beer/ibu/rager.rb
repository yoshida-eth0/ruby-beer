require 'singleton'

module Beer
  module IBU
    # See also:
    #   https://homebrewacademy.com/ibu-calculator/
    class Rager
      include Singleton

      # IBU
      #
      # IBU = (OUNCES OF HOPS * %UTILIZATION * %ALPHA * 7462) / (Batch Volume* (1 + GA))
      #
      # @param wort [Wort] ウォート
      # @param weight [Float] ホップ添加量
      # @param mins [Float] 煮沸時間(分)
      # @param hop [Float] ホップ
      def ibu(wort, weight, mins, hop, gallon: GALLON)
        (weight / OZ * utilization(mins) * 0.01 * hop.aa * 7462) / (wort.batch_size / GALLON * (1 + ga(wort)))
      end

      # GA
      #
      # GA = (BOIL_GRAVITY – 1.050) / 0.2
      # If Boil Gravity is less than 1.050 GA = 0.
      #
      # @param wort [Wort] ウォート
      def ga(wort)
        if wort.og<1.050
          0.0
        else
          (wort.og - 1.050) / 0.2
        end
      end

      # UTILIZATION
      #
      # %UTILIZATION = 18.11 + (13.86 * hyptan[(MINUTES – 31.32) / 18.27] )
      #
      # @param mins [Float] 煮沸時間(分)
      def utilization(mins)
        18.11 + (13.86 * Math.tanh((mins - 31.32) / 18.27))
      end

    end
  end
end
