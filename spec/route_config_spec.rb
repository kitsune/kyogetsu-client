require 'route_config'
require 'diff_engine'

describe Kyogetsu::RouteConfig do
  context "initialization" do
    it "should initialize diff_engines list to be empty" do
      rc = Kyogetsu::RouteConfig.new
      expect(rc.diff_engines).to be_empty
    end
  end

  context "add_diff" do
    it "should add to end of the diff_engines list" do
      rc = Kyogetsu::RouteConfig.new
      expect(rc.diff_engines).to be_empty
      rc.add_diff Kyogetsu::DiffEngine.new do
        "something"
      end
      expect(rc.diff_engines.length).to eq(1)
    end
  end

  context "Diff" do
    before(:each) do
      @rc = Kyogetsu::RouteConfig.new
      @rc.add_diff Kyogetsu::DiffEngine.new do
        diff_func do |p, s|
          "Diff"
        end
      end

    end

    it "should handle a single diff engine" do
      expect(@rc.diff('p', 's', '0', '1')).to eq(['Diff'])
    end

    it "should handle multiple diff engines" do
      @rc.add_diff Kyogetsu::DiffEngine.new do
        diff_func do |p, s|
          p
        end
      end
      expect(@rc.diff('p', 's', '0', '1')).to eq(['Diff', 'p'])
    end
  end

end
