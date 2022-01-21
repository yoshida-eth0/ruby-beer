module Beer
  module Malt
    class PPG
      include Base

      def initialize(ppg)
        @ppg = ppg
      end

      # Brewhouse Yield. 糖化量
      #
      # @param brewhouse_efficiency [Float] Brewhouse Efficiency. 醸造所効率 (ex: 0.90)
      def brewhouse_yield(brewhouse_efficiency=1.0)
        (sg(brewhouse_efficiency) - 1.0) / 46.214 / 0.001
      end

      # Plato
      #
      # @param brewhouse_efficiency [Float] Brewhouse Efficiency. 醸造所効率 (ex: 0.90)
      def plato(brewhouse_efficiency=1.0)
        brewhouse_yield(brewhouse_efficiency) * 11.486
      end

      # Specific Gravity
      #
      # @param brewhouse_efficiency [Float] Brewhouse Efficiency. 醸造所効率 (ex: 0.90)
      def sg(brewhouse_efficiency=1.0)
        ppg(brewhouse_efficiency) * 0.001 + 1.0
      end

      # PPG
      #
      # @param brewhouse_efficiency [Float] Brewhouse Efficiency. 醸造所効率 (ex: 0.90)
      def ppg(brewhouse_efficiency=1.0)
        @ppg * brewhouse_efficiency
      end
    end
  end
end

