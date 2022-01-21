require 'beer/malt/base'
require 'beer/malt/spec'
require 'beer/malt/ppg'

module Beer
  module Malt

    def self.spec(dbfg: nil, dbcg: nil, mc:)
      Spec.new(dbfg: dbfg, dbcg: dbcg, mc: mc)
    end

    def self.ppg(ppg)
      PPG.new(ppg)
    end
  end
end
