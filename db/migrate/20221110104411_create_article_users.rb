class CreateArticleUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :article_users do |t|
      t.string :uid
      t.string :name
      t.timestamps
    end
  end
end
