module Kyogetsu

  class RouteConfig
    attr_reader :diff_engines

    def initialize()
      @diff_engines = []
    end

    def add_diff(engine, &block)
      engine.instance_eval(&block)
      @diff_engines << engine
    end

    def diff(prod, staging, prodver, stagingver)
      @diff_engines.map { |d| d.diff(prod, staging, prodver, stagingver) }
    end
  end

end