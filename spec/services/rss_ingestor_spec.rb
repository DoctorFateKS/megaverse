require "rails_helper"

RSpec.describe RssIngestor do
  let(:feed_url) { "https://megaverse.forumactif.com/feed/?" }
  let(:feed_body) { file_fixture("megaverse_feed.xml").read }

  before do
    stub_request(:get, feed_url).to_return(status: 200, body: feed_body)
  end

  it "crée un sujet par entrée du flux" do
    expect { described_class.new.call }.to change(Topic, :count).by(20)
  end

  it "ne crée aucun doublon si on relance l'ingestion" do
    described_class.new.call

    expect { described_class.new.call }.not_to change(Topic, :count)
  end

  it "renseigne correctement les champs d'un sujet" do
    described_class.new.call

    topic = Topic.find_by(
      guid: "https://megaverse.forumactif.com/t2560-i-wanna-hear-it-from-your-lips-%EA%A8%84-raria-3"
    )

    expect(topic).not_to be_nil
    expect(topic.creator).to eq("Reign Hargrave")
    expect(topic.category).to eq("Celestial Gates")
  end

  it "renvoie le détail des sujets créés et ignorés" do
    result = described_class.new.call

    expect(result.created).to eq(20)
    expect(result.skipped).to eq(0)
    expect(result.errors).to be_empty
  end

  it "ne plante pas si le flux est inaccessible" do
    stub_request(:get, feed_url).to_return(status: 500)

    expect { described_class.new.call }.not_to raise_error
    expect(Topic.count).to eq(0)
  end
end
