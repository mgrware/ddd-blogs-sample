class AddColumnToArticleVisitors < ActiveRecord::Migration[7.0]
  def change
    add_column :article_visitors, :like, :boolean
    add_column :article_visitors, :read, :boolean
  end
end
