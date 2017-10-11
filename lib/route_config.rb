# Copyright Dylan Enloe 2017
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
