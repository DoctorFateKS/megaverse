require "rails_helper"

RSpec.describe Topic, type: :model do
  it "exige un guid" do
    topic = Topic.new
    expect(topic).not_to be_valid
    expect(topic.errors[:guid]).to include("can't be blank")
  end

  it "refuse un guid déjà existant" do
    Topic.create!(guid: "abc123", title: "Test")

    duplicate = Topic.new(guid: "abc123", title: "Autre titre")
    expect(duplicate).not_to be_valid
  end
end
