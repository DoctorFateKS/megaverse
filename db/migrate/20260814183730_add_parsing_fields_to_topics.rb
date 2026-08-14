class AddParsingFieldsToTopics < ActiveRecord::Migration[7.1]
  def change
    add_column :topics, :chapter_number, :integer
    add_column :topics, :date_in_universe, :string
    add_column :topics, :lieu, :string
    add_column :topics, :outfit, :string
    add_column :topics, :tw, :string
    add_column :topics, :playlist, :string
    add_column :topics, :parsed_at, :datetime

    create_table :stories do |t|
      t.string :slug, null: false
      t.timestamps
    end
    add_index :stories, :slug, unique: true

    add_reference :topics, :story, foreign_key: true, null: true

    create_table :mentions do |t|
      t.references :topic, null: false, foreign_key: true
      t.string :character_name, null: false
      t.timestamps
    end
    add_index :mentions, [ :topic_id, :character_name ], unique: true
  end
end
