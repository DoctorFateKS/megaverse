namespace :rss do
  desc "Ingestion du flux RSS du forum Megaverse"
  task ingest: :environment do
    result = RssIngestor.new.call
    puts "Créés : #{result.created} | Ignorés (déjà connus) : #{result.skipped} | Erreurs : #{result.errors.join(', ')}"
  end
end
