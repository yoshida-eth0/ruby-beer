module Beer
  class Wort
    attr_reader :batch_size
    attr_reader :abs_gravity
    attr_reader :abs_ibu

    def initialize
      @batch_size = 0.0
      @abs_gravity = 0.0
      @abs_ibu = 0.0
    end

    # 原料追加
    #
    # @param weight [Float] 重量(g)
    # @param ingredient [Ingredient] 原材料
    def add(weight, ingredient)
      if ingredient.respond_to?(:to_ingredient)
        ingredient = ingredient.to_ingredient
      end
      @batch_size += weight
      @abs_gravity += (ingredient.sg - 1.0) * weight
      self
    end

    # Wort追加
    #
    # @param wort [Wort] Wort
    def merge(wort)
      @batch_size += wort.weight
      @abs_gravity += wort.gravity
      @abs_ibu += wort.ibu
      self
    end

    # 比率を保ったまま総容量を変更
    #
    # @param to_batch_size [Float] 変更後総容量
    def scale(to_batch_size)
      to_batch_size = to_batch_size.to_f
      @abs_gravity = abs_gravity * to_batch_size / batch_size
      @abs_ibu = abs_ibu * to_batch_size / batch_size
      @batch_size = to_batch_size
      self
    end

    # 水を入れて総容量を合わせる
    #
    # @param to_batch_size [Float] 変更後総容量
    def fit(to_batch_size)
      diff = to_batch_size - batch_size
      add(diff, Ingredient::WATER)
    end

    # 煮沸で蒸発した分の水を減らす
    #
    # @param rate [Float] 蒸発率 (ex: 0.10)
    def evaporate(rate)
      to_batch_size = batch_size * (1 - rate)
      fit(to_batch_size)
    end

    # 指定容量を減らして新たなWortオブジェクトを返す
    # タンクの分割など
    #
    # @param weight [Float] 取り出す容量
    def shift(weight)
      sub = dup.scale(weight)
      remove(weight)
      sub
    end

    # 指定容量を減らす
    # 澱引きや試飲など
    #
    # @param weight [Float] 取り除く容量
    def remove(weight)
      scale(batch_size - weight)
    end

    # 煮沸してホップから苦味を抽出する
    #
    # @oaram boil_recipe [BoilRecipe]
    # @prram evaporation_rate [Float] 推定蒸発率 (ex: 0.10)
    def boil(boil_recipe, evaporation_rate=0.0, algorithm=nil, gallon: GALLON)
      ibu = boil_recipe.boil(self, evaporation_rate, algorithm, gallon: gallon)
      evaporate(evaporation_rate)
      @abs_ibu += ibu * batch_size
      self
    end


    # 初期比重
    def original_gravity
      abs_gravity / batch_size + 1.0
    end
    alias_method :og, :original_gravity

    # 最終比重
    #
    # @param attenuation [Float] 発酵率 (ex: 0.75)
    def final_gravity(attenuation=0.75)
      original_gravity - (original_gravity - 1.0) * attenuation
    end
    alias_method :fg, :final_gravity

    # 予想アルコール度数
    #
    # @param attenuation [Float] 発酵率 (ex: 0.75)
    def alcohol_by_volume(attenuation=0.75)
      (original_gravity - final_gravity(attenuation)) / 0.738
      #fg = final_gravity(attenuation)
      #(og - fg) * 1.05 / fg / 0.79
    end
    alias_method :abv, :alcohol_by_volume

    # IBU
    def ibu
      if 0.0<abs_ibu && 0.0<batch_size
        abs_ibu / batch_size
      else
        0.0
      end
    end

    def to_ingredient
      Ingredient.sg(og)
    end
  end
end
