# See also:
#   https://www.probrewer.com/library/malt/understanding-malt-analysis-sheets/
module Beer
  module Malt

    def self.spec(dbfg: nil, dbcg: nil, mc:)
      Spec.new(dbfg: dbfg, dbcg: dbcg, mc: mc)
    end

    def self.ppg(ppg)
      PPG.new(ppg)
    end


    module Base
      # MEMO:
      #   水を使わずにモルトのみをマッシングした場合のSGの理論値へ変換する。
      #   そのままabv等への変換は出来ない。
      #   to_ppgするか、Wortにaddして使う。
      #   モルトの比重は1.0と仮定する
      def to_ingredient(brewhouse_efficiency=1.0, gallon: GALLON)
        sg = ppg(brewhouse_efficiency) * 0.001 * (POUND + gallon) / POUND + 1.0
        Ingredient.sg(sg)
      end
    end
  
    class Spec
      include Base
  
      attr_reader :dbfg
      attr_reader :mc
  
      # @param dbfg [Float] Extract Yield Dry Basis Fine Grind. モルトを細挽きした場合のエキス含有率 (ex: 0.83)
      # @param dbcg [Float] Extract Yield Dry Basis Coarse Grind. モルトを粗挽きした場合のエキス含有率、DBCG値よりも5〜15％減る (ex: 0.73)
      # @param mc [Float] Moisture Content. 含水率 (ex: 0.04)
      def initialize(dbfg: nil, dbcg: nil, mc:)
        @dbfg = dbfg
        @dbcg = dbcg
        @mc = mc
      end
  
      # Extract Yield Dry Basis Coarse Grind.
      # モルトを粗挽きした場合のエキス含有率
      # コンストラクタで指定されなかった場合はDBFGからの推定値を返す
      def dbcg
        @dbcg || @dbfg * 0.9
      end
  
      # Brewhouse Yield. 糖化量
      #
      # @param brewhouse_efficiency [Float] Brewhouse Efficiency. 醸造所効率 (ex: 0.90)
      def brewhouse_yield(brewhouse_efficiency=1.0)
        (dbcg - mc - 0.002) * brewhouse_efficiency
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
        1.0 + (brewhouse_yield(brewhouse_efficiency) * 46.214) * 0.001
      end
  
      def ppg(brewhouse_efficiency=1.0)
        (sg(brewhouse_efficiency) - 1.0) * 1000
      end
    end
  
    class PPG
      include Base
  
      def initialize(ppg)
        @ppg = ppg
      end
  
      def brewhouse_yield(brewhouse_efficiency=1.0)
        (sg(brewhouse_efficiency) - 1.0) / 46.214 / 0.001
      end
  
      def plato(brewhouse_efficiency=1.0)
        brewhouse_yield(brewhouse_efficiency) * 11.486
      end
  
      def sg(brewhouse_efficiency=1.0)
        ppg(brewhouse_efficiency) * 0.001 + 1.0
      end
  
      def ppg(brewhouse_efficiency=1.0)
        @ppg * brewhouse_efficiency
      end
    end
  end
end
