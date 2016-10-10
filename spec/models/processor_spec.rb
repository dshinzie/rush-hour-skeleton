require_relative '../spec_helper'

describe Processor do
  it "returns hash with proper root_url key case" do
    params = {identifier: "test_id", rootUrl: "test_url"}
    expected = {identifier: "test_id", root_url: "test_url"}

    expect(Processor.clean_data(params)).to eq(expected)
  end

  it "returns nil root_url if rootUrl case is incorrect" do
    params = {identifier: "test_id", root_url: "test_url"}
    expected = {identifier: "test_id", root_url: nil}

    expect(Processor.clean_data(params)).to eq(expected)
  end

  # it "returns referred by ID" do
  #   pc = Processor.params_cleaner(test_data)
  #   expected = ReferredBy.find_by(root_url: pc[:referredBy]).id
  #
  #   expect(pc[:referred_by_id]).to eq(expected)
  # end

end
