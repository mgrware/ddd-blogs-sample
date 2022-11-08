class CreateArticleVisitors < ActiveRecord::Migration[7.0]
  def change
    create_table :article_visitors do |t|
      t.string :article_uid
      t.integer :user_id
      t.string :user_name
      t.string :rate

    end
  end
end
