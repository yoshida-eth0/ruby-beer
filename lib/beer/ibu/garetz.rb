module Beer
  module IBU
    # See also:
    #   https://homebrewacademy.com/ibu-calculator/
    class Garetz

      # @param cf [Float] 濃度係数、concentration factor (Final Volume / Pre-Boil Volume)
      # @param desired_ibu [Float] Target IBU
      # @param elevation [Float] 標高(メートル)
      def initialize(cf, desired_ibu=25, elevation=40)
        @cf = cf
        @desired_ibu = desired_ibu
        @elevation = elevation
      end

      # IBU
      #
      # IBU = (%Utilization * %Alpha * Hop weight(oz) * 0.749) / (Volume in gallons * CA)
      #
      # @param wort [Wort] ウォート
      # @param weight [Float] ホップ添加量
      # @param mins [Float] 煮沸時間(分)
      # @param hop [Float] ホップ
      def ibu(wort, weight, mins, hop, gallon: GALLON)
        (utilization(mins) * hop.aa * 100 * weight / OZ * 0.749) / (wort.batch_size / GALLON * ca(wort))
      end

      # Utilization % = 7.2994 + (15.0746 * tanh((minutes – 21.86) / 24.71))
      def utilization(mins)
        7.2994 + (15.0746 * Math.tanh((mins - 21.86) / 24.71))
      end

      # Concentration Factor
      # CA = GF * HF * TF
      def ca(wort)
        gf(wort) * hf * tf
      end

      # Boil Gravity
      # BG = (CF * (Starting Gravity - 1)) + 1
      def bg(wort)
        (@cf * (wort.og - 1)) + 1
      end

      # Gravity Factor
      # GF = (BG - 1.050)/.2 +1
      def gf(wort)
        (bg(wort) - 1.050) / 0.2 + 1
      end

      # hopping factor
      # HF = ((CF * Desired IBUs)/260) + 1
      def hf
        (@cf * @desired_ibu / 260) + 1
      end

      # temperature factor
      # TF = ((Elevation in feet) / 550) * 0.02) + 1
      def tf
        (@elevation / FEET / 550 * 0.02) + 1
      end
    end
  end
end
