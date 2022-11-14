class Api::V1::ArticlesController < ApplicationController
  def index
    @articles = Articles::Article.order("id DESC")
    render json: {data: @articles}
  end

  def show
    @article = Articles::Article.find_by_uid(params[:id])

    render json: {data: { articles: @article, visitors: @article.try(:article_visitors), comments: @article.try(:article_comments)}}
  end

  def create
   
    ApplicationRecord.transaction do
      submit_article
    end
    
    render json: { messages: "Order was successfully submitted", data: { article_id: @uuid}}
  end

  def like
    ActiveRecord::Base.transaction do
      command_bus.(
        Blogging::LikeArticle.new(
          article_id: params[:id],
          user_id: params[:user_id]
        )
      )
    end

    render json: { messages: "Article was successfully liked", data: { article_id: params[:id]}}
  end

  def read
    ActiveRecord::Base.transaction do
      command_bus.(
        Blogging::ReadArticle.new(
          article_id: params[:id],
          user_id: params[:user_id]
        )
      )
    end

    render json: { messages: "Article was successfully readed", data: { article_id: params[:id]}}
  end

  def comment
    ActiveRecord::Base.transaction do
      command_bus.(
        Blogging::CommentArticle.new(
          article_id: params[:id],
          user_id: params[:user_id],
          content: params[:content]
        )
      )
    end

    render json: { messages: "Article was successfully commented", data: { article_id: params[:id]}}
  end
  

  private

  def submit_article
    @uuid = SecureRandom.uuid
    command_bus.(Blogging::SubmitArticle.new(
      article_id: @uuid,
      content: params[:content],
      title: params[:title]
    ))

    command_bus.(Crm::AssignUserToArticle.new(
      article_id: @uuid,
      user_id: params[:user_id]
    ))
  end

end