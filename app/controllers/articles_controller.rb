class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  # below is what this lab came with
  # def show
  #   article = Article.find(params[:id])
  #   render json: article
  # end

  # When a user makes a GET request to /articles/:id
  def show

    # If this is the first request this user has made, set session[:page_views] to an initial value of 0. Hint: consider using ||= to set this initial value!
    session[:page_views] ||= 0
    # For every request to /articles/:id, increment the value of session[:page_views] by 1. 
    session[:page_views] += 1

    #If the user has viewed 3 or fewer pages, render a JSON response with the article data.
    if session[:page_views] <= 3
      article = Article.find(params[:id])
      render json: article
      
      # If the user has viewed more than 3 pages, render a JSON response including an error message, and a status code of 401 unauthorized.
    else
      render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
