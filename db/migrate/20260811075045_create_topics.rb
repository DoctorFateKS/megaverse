class CreateTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :topics do |t|
      t.string :guid
      t.string :title
      t.string :link
      t.string :creator
      t.string :category
      t.text :description
      t.datetime :pub_date

      t.timestamps
    end

    add_index :topics, :guid, unique: true
  end
end
