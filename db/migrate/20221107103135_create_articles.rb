class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :uid
      t.string :title
      t.text :content
      t.string :author
      t.string :state
    end
  end
end
