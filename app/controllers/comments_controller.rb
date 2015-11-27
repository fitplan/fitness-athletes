class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :set_athlete

  def index
    @comments = @athlete.comment_threads
    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  def create
    @athlete.comment_threads.create!(comment_params.merge user: current_user)
    redirect_to athlete_comments_path(@athlete)
  end

  protected

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_athlete
    @athlete = Athlete::Base.friendly.find params[:athlete_id] || params[:id]
  end
end
