class CreateArticleComments < ActiveRecord::Migration[7.0]
  def change
    create_table :article_comments do |t|
      t.string :article_uid
      t.integer :user_id
      t.string :user_name
      t.string :content

    end
  end
end
