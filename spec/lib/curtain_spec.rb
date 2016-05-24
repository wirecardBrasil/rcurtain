require "spec_helper"

describe "::Rcurtain" do

  context "is opened" do

    context "when 100%" do
      before do
        allow_any_instance_of(Redis).to receive(:get).and_return(100)
        allow_any_instance_of(Redis).to receive(:smembers).and_return(nil)
      end

      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened? "feature").to be true }
    end

    context "when user exists" do
      before do
        allow_any_instance_of(Redis).to receive(:get).and_return(0)
        allow_any_instance_of(Redis).to receive(:smembers).and_return(['MPA-123'])
      end

      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened?("feature", ['MPA-123'])).to be true }
    end
  end

  context "is closed" do
    context "when 0%" do
      before do
        allow_any_instance_of(Redis).to receive(:get).and_return(0)
        allow_any_instance_of(Redis).to receive(:smembers).and_return(nil)
      end

      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened? "feature").to be false }
    end

    context "when user does not exists" do
      before do
        allow_any_instance_of(Redis).to receive(:get).and_return(0)
        allow_any_instance_of(Redis).to receive(:smembers).and_return(nil)
      end

      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened?("feature", ['MPA-123'])).to be false }
    end

    context "when nothing was found on redis" do
      before do
        allow_any_instance_of(Redis).to receive(:get).and_return(nil)
        allow_any_instance_of(Redis).to receive(:smembers).and_return(nil)
      end

      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened? "feature_not_exists").to be false }
    end

    context "when failed connection" do
      before do
        allow_any_instance_of(Redis).to receive(:get).and_return(nil)
        allow_any_instance_of(Redis).to receive(:smembers).and_return(nil)
      end
      
      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened? "feature_not_exists").to be false }
    end
  end
end
