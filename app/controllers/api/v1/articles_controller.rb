class Api::V1::ArticlesController < ApplicationController
  def index
    @articles = Articles::Article.order("id DESC")
    render json: {data: @articles}
  end

  def show
    @article = Articles::Article.find_by_uid(params[:id])
    render json: {data: @article}
  end

  def create
   
    ApplicationRecord.transaction do
      submit_article
    end
    
    render json: { messages: "Order was successfully submitted", data: { article_id: @uuid}}
  end

  private

  def submit_article
    @uuid = SecureRandom.uuid
    command_bus.(Blogging::SubmitArticle.new(
      article_id: @uuid,
      content: params[:content],
      title: params[:title]
    ))
  end

end