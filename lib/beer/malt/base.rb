module Beer
  module Malt
    module Base
      # 原料へ変換
      #
      # MEMO:
      #   水を使わずにモルトのみをマッシングした場合のSGの理論値へ変換する。
      #   そのままabv等への変換は出来ない。
      #   to_ppgするか、Wortにaddして使う。
      #   モルトの比重は1.0と仮定する
      #
      # @param brewhouse_efficiency [Float] Brewhouse Efficiency. 醸造所効率 (ex: 0.90)
      # @param gallon [Float] ガロンからリットルへの変換係数
      def to_ingredient(brewhouse_efficiency=1.0, gallon: GALLON)
        sg = ppg(brewhouse_efficiency) * 0.001 * (POUND + gallon) / POUND + 1.0
        Ingredient.sg(sg)
      end
    end
  end
end
