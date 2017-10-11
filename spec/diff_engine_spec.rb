# Copyright Dylan Enloe 2017
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'diff_engine'
require 'diffy'

describe Kyogetsu::DiffEngine do
  context "initialization" do
    it "should initialize versions hash to be empty" do
      d = Kyogetsu::DiffEngine.new
      expect(d.versions).to be_empty
    end
  end

  context "versions" do
    before(:each) do
      @diff = Kyogetsu::DiffEngine.new
      @diff.version '1' do |s, p|
        'Diff'
      end
    end

    it "should correctly add a version to the list" do
      expect(@diff.versions).to include('1')
    end

    it "should correctly store the given block" do
      expect(@diff.versions['1'].call('s', 'p')).to eq('Diff')
    end

    it "should correctly handle different versions" do
      @diff.version '2' do |s, p|
        '2nd Version'
      end
      expect(@diff.versions['2'].call('s', 'p')).to eq('2nd Version')
    end
  end

  context "global" do
    before(:each) do
      @diff = Kyogetsu::DiffEngine.new
      @diff.global do |s, p|
        'Global'
      end
    end

    it "should correctly store the given block" do
      expect(@diff.instance_variable_get(:@global).call('s', 'p')).to eq('Global')
    end
  end

  context "diff function" do
    before(:each) do
      @diff = Kyogetsu::DiffEngine.new
      @diff.diff_func do |s, p|
        'Diff Func'
      end
    end

    it "should correctly store the given block" do
      r = @diff.instance_variable_get(:@diff_func).call('s', 'p')
      expect(r).to eq('Diff Func')
    end
  end

  context "mutate staging" do
    before(:each) do
      @diff = Kyogetsu::DiffEngine.new
      @diff.version 1 do |s, p|
        s.sub 'test', 'production'
      end
      @diff.version 2 do |s, p|
        s.sub 'test', 'prod'
      end
      @diff.version 3 do |s, p|
        s.sub 't', 'test'
      end
      @diff.global do |s, p|
        s.sub 'testing', 'test'
      end
      @staging = 'test'
    end

    it "should correctly apply only needed versions" do
      r = @diff.mutate_staging(@staging, 0, 1)
      expect(r).to eq('production')
    end

    it "should apply the versions in order" do
      r = @diff.mutate_staging(@staging, 0 , 2)
      expect(r).to eq('prod')
    end

    it "should apply multiple versions if needed" do
      r = @diff.mutate_staging('t', 0, 3)
      expect(r).to eq('prod')
    end

    it "should apply global first" do
      r = @diff.mutate_staging('testing', 0, 1)
      expect(r).to eq('production')
    end
  end

  context "diff" do
    before(:each) do
      @diff = Kyogetsu::DiffEngine.new
      @diff.diff_func do |s, p|
        Diffy::Diff.new(p, s).to_s
      end
    end

    it "should not return a diff if there isn't a diffence" do
      r = @diff.diff('test', 'test', 0 , 1)
      expect(r).to be_empty
    end

    it "should return a diff if there is a diffence" do
      r = @diff.diff("prod\n", "test\n", 0, 1)
      expect(r).to eq("-test\n+prod\n")
    end
  end

end
