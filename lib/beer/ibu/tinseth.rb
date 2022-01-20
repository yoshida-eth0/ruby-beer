require 'singleton'

module Beer
  module IBU
    # See also:
    #   https://homebrewacademy.com/ibu-calculator/
    class Tinseth
      include Singleton

      # IBU
      #
      # IBUs = decimal alpha acid utilization * mg/l of added alpha acids
      #
      # @param wort [Wort] ウォート
      # @param weight [Float] ホップ添加量
      # @param mins [Float] 煮沸時間(分)
      # @param hop [Float] ホップ
      def ibu(wort, weight, mins, hop, gallon: GALLON)
        aa_utilization(wort, mins) * added_aa(wort, weight, hop, gallon: gallon)
      end

      # mg/l of added alpha acids
      #
      # mg/l of added alpha acids = (decimal AA rating * ozs hops * 7490) / gallons of wort
      #
      # @param wort [Wort] ウォート
      # @param weight [Float] ホップ添加量
      # @param hop [Float] ホップ
      def added_aa(wort, weight, hop, gallon: GALLON)
         (hop.aa * weight / OZ * 7490) / (wort.batch_size / gallon)
      end

      # Decimal Alpha Acid Utilization
      #
      # Decimal Alpha Acid Utilization = Bigness Factor * Boil Time Factor
      #
      # @param wort [Wort] ウォート
      # @param mins [Float] 煮沸時間(分)
      def aa_utilization(wort, mins)
        bigness_factor(wort) * boil_time_factor(mins)
      end

      # Bigness factor
      #
      # Bigness factor = 1.65 * 0.000125^(wort gravity – 1)
      #
      # @param wort [Wort] ウォート
      def bigness_factor(wort)
        1.65 * (0.000125 ** (wort.og - 1))
      end

      # Boil Time factor
      #
      # Boil Time factor = (1 – e^(-0.04 * time in mins) )/4.15
      #
      # @param mins [Float] 煮沸時間(分)
      def boil_time_factor(mins)
        (1 - Math.exp(-0.04 * mins)) / 4.15
      end
    end
  end
end
