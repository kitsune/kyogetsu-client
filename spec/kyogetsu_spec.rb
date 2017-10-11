# Copyright Dylan Enloe 2017
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'kyogetsu'

describe Kyogetsu do
  before(:each) do
    Kyogetsu.instance_variable_get(:@registry).clear
  end
  context "parsing routes" do
    it "should be able to parse a valid route" do
      Kyogetsu.define '/' do
        add_diff Kyogetsu::DiffEngine.new do
          diff_func do |p, s|
            "Diff"
          end
        end
      end

      expect(Kyogetsu.registry.length).to eq(1)
      expect(Kyogetsu.registry['/'].diff('p','s', 0, 1)).to eq(['Diff'])
    end
  end
end
