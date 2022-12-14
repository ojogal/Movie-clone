# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :set_review, only: %i[edit update destroy]
  before_action :set_movie, only: %i[new create update destroy]
  before_action :authenticate_user!

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.movie_id = @movie.id

    respond_to do |format|
      if @review.save
        format.json { render json: { stars: @movie.avg_ratings } }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @review.destroy

    respond_to do |format|
      format.html { redirect_to movie_url, notice: 'Review was successfully destroyed.' }
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def review_params
    params.require(:review).permit(:rating, :user_id, :movie_id)
  end
end
