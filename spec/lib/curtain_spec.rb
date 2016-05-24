require "spec_helper"

describe "::Rcurtain" do
  context "is opened" do
    context "when 100%" do
      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened? "feature").to be true }
    end

    context "when user exists" do
      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened? "feature").to be true }
    end
  end

  context "is closed" do
    context "when 0%" do
      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened? "feature").to be false }
    end

    context "when user does not exists" do
      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened? "feature").to be false }
    end

    context "when nothing was found on redis" do
      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened? "feature_not_exists").to be false }
    end

    context "when failed connection" do
      it { expect(Rcurtain.new("redis://:p4ssw0rd@10.0.1.1:6380/15").opened? "feature_not_exists").to be false }
    end
  end
end
