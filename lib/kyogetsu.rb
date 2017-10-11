# Copyright Dylan Enloe 2017
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module Kyogetsu
    @registry = {}

    def self.define(route, &block)
        route_config = RouteConfig.new
        route_config.instance_eval(&block)
        @registry[route] = route_config
    end

    def self.registry
        @registry
    end

end

