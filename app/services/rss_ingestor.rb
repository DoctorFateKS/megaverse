require "net/http"
require "rss"

class RssIngestor
  class FetchError < StandardError; end

  FEED_URL = ENV.fetch("MEGAVERSE_RSS_URL", "https://megaverse.forumactif.com/feed/?")

  Result = Struct.new(:created, :skipped, :errors, keyword_init: true)

  def call
    feed = RSS::Parser.parse(fetch_feed, false)

    created = 0
    skipped = 0

    feed.items.each do |item|
      guid = item.guid.content.strip
      topic = Topic.find_or_initialize_by(guid: guid)

      if topic.persisted?
        skipped += 1
        next
      end

      topic.assign_attributes(
        title: item.title&.strip,
        link: item.link&.strip,
        creator: item.dc_creator,
        category: item.categories.first&.content&.strip,
        description: item.description,
        pub_date: item.pubDate
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
end
