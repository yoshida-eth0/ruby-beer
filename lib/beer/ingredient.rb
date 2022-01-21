module Beer
  class Ingredient
    attr_reader :sg
    alias_method :specific_gravity, :sg

    def initialize(sg)
      @sg = sg
    end

    # Brixに換算する
    #
    # https://en.wikipedia.org/wiki/Brix#Specific_gravity_2
    def brix
      182.4601 * sg**3 - 775.6821 * sg**2 + 1262.7794 * sg - 669.5622
    end

    # Platoに換算する
    #
    # https://en.wikipedia.org/wiki/Brix#Specific_gravity_2
    def plato
      135.997 * sg**3 - 630.272 * sg**2 + 1111.14 * sg - 616.868
    end

    # PPGに換算する
    def ppg
      (sg - 1.0) * 1000
    end

    # self 1ポンドあたり水1ガロンを合わせたIngredientを返す
    #
    # @param gallon [Float] ガロンからリットルへの変換係数
    def to_ppg(gallon: GALLON)
      self.class.sg(POUND * (sg - 1.0) / (gallon + POUND) + 1.0)
    end

    # 予想アルコール度数に換算する
    #
    # https://en.wikipedia.org/wiki/Gravity_(alcoholic_beverage)
    def abv(attenuation=0.75)
      og = sg
      fg = og - (og - 1) * attenuation
      (og - fg) / 0.738
    end
    alias_method :alcohol_by_volume, :abv


    class << self
      # Brix値からインスタンス生成
      #
      # @param brix [Float] brix値 (ex: 12.5)
      def brix(brix)
        tmp = (-0.0122763465915632*brix + ((1 - 0.0122763465915632*brix)**2 + 0.535573458227407)**0.5 + 1)**(1.0/3.0)
        sg = -0.606611982692257*tmp + 1.41708077546817 + 0.492626004727696/tmp
        new(sg)
      end

      # Plato値からインスタンス生成
      #
      # @param plato [Float] plato値 (ex: 12.5)
      def plato(plato)
        tmp = (-0.0103205628846964*plato + ((1 - 0.0103205628846964*plato)**2 + 0.3015312037528)**0.5 + 1)**(1.0/3.0)
        sg = -0.708890403557989*tmp + 1.54481839060175 + 0.475360601927164/tmp
        new(sg)
      end

      # 比重からオブジェクト生成
      #
      # @param sg [Float] Specific Gravity. (ex: 0.036)
      def sg(sg)
        new(sg.to_f)
      end

      # PPGからオブジェクト生成
      #
      # @param ppg [Float] Points/Pound/Gallon、1ガロンの水で1ポンドのモルトを仕込んだときに達成する比重. (ex: 36)
      def ppg(ppg)
        new(ppg * 0.001 + 1.0)
      end

      # 目標アルコール度数からオブジェクト生成
      #
      # @param abv [Float] 目標アルコール度数 (ex: 0.057)
      # @param attenuation [Float] 発酵率 (ex: 0.75)
      def abv(abv, attenuation=0.75)
        sg = (0.738 * abv + attenuation) / attenuation
        new(sg)
      end
      alias_method :alcohol_by_volume, :abv
    end


    WATER = sg(1.0)
    MALT_EXTRACT = sg(1.30800000459)
    SUGER = sg(1.385)
  end
end
