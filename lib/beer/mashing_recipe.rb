module Beer
  class MashingRecipe
    attr_reader :malts

    def initialize
      @malts = []
    end

    def add(weight, malt)
      @malts << [weight, malt]
      self
    end

    def weight
      malts.map(&:first).sum || 0.0
    end

    def gravity(brewhouse_efficiency=1.0)
      malts.map {|weight, malt|
        (malt.sg(brewhouse_efficiency) - 1) * weight
      }.sum || 0.0
    end

    def to_malt
      ppg = gravity(1.0) / weight * 1000
      Malt::PPG.new(ppg)
    end

    def to_ingredient(brewhouse_efficiency=1.0)
      to_malt.to_ingredient(brewhouse_efficiency)
    end

    # マッシング
    #
    # マッシング開始時の水の量を指定し、スパージングをしない場合
    #   water_weight: マッシング開始時の水の量
    #   evaporation_rate: 推定蒸発率 (ex: 0.10)
    #
    # マッシング開始時の水の量を指定し、分量外の水を使ってスパージングをする場合
    #   water_weight: マッシング開始時の水の量
    #   evaporation_rate: 推定蒸発率 (ex: 0.10)
    #
    #   > mashing
    #   >   .mash(water_weight, brewhouse_efficiency, evaporation_rate)
    #   >   .add(スパージングに使う水の量, Ingredient::WATER)
    #
    # マッシングからスパージングまでを行った最終麦汁量を指定する場合
    #   water_weight: 最終麦汁量
    #   evaporation_rate: 0.0
    #
    # @param water_weight [Float] 煮出す水の量
    # @param brewhouse_efficiency [Float] 醸造効率 (ex: 0.80)
    # @prram evaporation_rate = [Float] 推定蒸発率 (ex: 0.10)
    def mash(water_weight, brewhouse_efficiency=1.0, evaporation_rate=0.0)
      # モルトと水を足してマッシング
      # モルトを取り出す、比重は変わらず容量のみが変わるのでscale
      # 煮出して蒸発した分は水を減らす、fitで水を減らす
      # 残ったものが麦汁
      Wort.new
        .add(weight, to_ingredient(brewhouse_efficiency))
        .add(water_weight, Ingredient::WATER)
        .scale(water_weight)
        .fit(water_weight * (1.0 - evaporation_rate))
    end
  end
end
