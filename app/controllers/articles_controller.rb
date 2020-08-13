class ArticlesController < ApplicationController
  skip_before_action :authorize!, only: [:index, :show]

  def index
    @articles = Article.all.order(created_at: :desc).page(params[:page]).per(params[:per_page] || 10)
    render_serialized_data(@articles)
  end

  def show
    @article = Article.find(params[:id])
    render_serialized_data(@article)
  end

  def create
    article = Article.new(article_params)
    if article.valid?
    else
      # byebug
      render_serialized_error(article)
    end
  end

  private

  def article_params
    ActionController::Parameters.new
  end

  def render_serialized_data(object)
    render json: ArticleSerializer.new(object).serializable_hash
  end

  def render_serialized_error(object)
    byebug
    render json: ErrorSerializer.new(object).serializable_hash
  end  
end
