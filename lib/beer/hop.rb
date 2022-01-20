module Beer
  class Hop
    attr_reader :aa

    # @param aa [Float] α酸値 (ex: 0.053)
    def initialize(aa)
      @aa = aa.to_f
    end
  end
end
