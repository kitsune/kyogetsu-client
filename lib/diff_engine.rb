# Copyright Dylan Enloe 2017
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module Kyogetsu

  class DiffEngine
    attr_reader :global, :versions

    def initialize()
      @versions = {}
    end

    def diff_func(&block)
      @diff_func = block
    end

    def global(&block)
      @global = block
    end

    def version(ver, &block)
      @versions[ver] = block
    end

    def diff(prod, staging, prodver, stagingver)
      staging = mutate_staging(staging, prodver, stagingver)
      @diff_func.call(prod, staging)
    end

    def mutate_staging(staging, prodver, stagingver)
      if @global then
        staging = @global.call(staging)
      end
      v = @versions.select { |ver| ver > prodver && ver <= stagingver }
      v.sort.reverse_each do |ver, prc|
        staging = prc.call(staging)
      end
      staging
    end
  end

end
