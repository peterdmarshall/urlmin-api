class CreateUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :urls do |t|
      t.text :url
      t.text :slug

      t.timestamps
    end
  end
end
