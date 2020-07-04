class ArticlesController < ApplicationController

  def index
    @articles = Article.all.order(created_at: :desc)
      .page(params[:page]).per(params[:per_page] || 10)
    render_serialized_data(@articles)
  end

  def show
    @article = Article.find(params[:id])
    render_serialized_data(@article)
  end

  private

  def render_serialized_data(object)
    render json: ArticleSerializer.new(object).serializable_hash
  end
end
