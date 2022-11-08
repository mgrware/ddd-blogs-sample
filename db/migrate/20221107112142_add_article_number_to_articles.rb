class AddArticleNumberToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :article_number, :string
  end
end
