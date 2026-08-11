require "net/http"
require "nokogiri"
require "time"

class RssIngestor
  class FetchError < StandardError; end

  FEED_URL = ENV.fetch("MEGAVERSE_RSS_URL", "https://megaverse.forumactif.com/feed/?")

  Result = Struct.new(:created, :skipped, :errors, keyword_init: true)

  def call
    doc = Nokogiri::XML(fetch_feed) { |config| config.recover }
    doc.remove_namespaces! # simplifie l'accès à dc:creator -> creator

    created = 0
    skipped = 0

    doc.css("item").each do |item|
      guid = item.at_css("guid")&.text&.strip
      next if guid.blank?

      topic = Topic.find_or_initialize_by(guid: guid)

      if topic.persisted?
        skipped += 1
        next
      end

      topic.assign_attributes(
        title: item.at_css("title")&.text&.strip,
        link: item.at_css("link")&.text&.strip,
        creator: item.at_css("creator")&.text&.strip,
        category: item.at_css("category")&.text&.strip,
        description: item.at_css("description")&.text&.strip,
        pub_date: parse_date(item.at_css("pubDate")&.text)
      )

      if topic.save
        created += 1
      else
        Rails.logger.error("[RssIngestor] échec de sauvegarde pour #{guid}: #{topic.errors.full_messages.join(', ')}")
      end
    end

    Result.new(created: created, skipped: skipped, errors: [])
  rescue => e
    Rails.logger.error("[RssIngestor] échec d'ingestion: #{e.class} #{e.message}")
    Result.new(created: 0, skipped: 0, errors: [ e.message ])
  end

  private

  def fetch_feed
    response = Net::HTTP.get_response(URI(FEED_URL))
    raise FetchError, "HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    response.body
  end

  def parse_date(raw)
    return nil if raw.blank?

    Time.parse(raw)
  rescue ArgumentError
    nil
  end
end
