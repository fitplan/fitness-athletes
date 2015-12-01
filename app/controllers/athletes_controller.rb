class AthletesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :outbound, :submitted_by_user, :liked_by_user]
  before_action :set_date, only: [:index]
  before_action :set_athlete, only: [:show, :edit, :update, :destroy, :outbound, :upvote]
  before_action :set_user, only: [:submitted_by_user, :liked_by_user]

  # TODO: add pagination and infinite scroll support!
  def index
    @athletes = Athlete::Base.order('created_at DESC')

    if @date
      @athletes = @athletes.on_date(@date)
    end

    if params[:tag].present?
      @athletes = @athletes.tagged_with(params[:tag])
    end

    @athletes = @athletes.group_by { |p| p.created_at.to_date }
  end

  def submitted_by_user
    @athletes = Athlete::Base.where user: @user
    render :index
  end

  def liked_by_user
    @athletes = @user.find_up_voted_items
    render :index
  end

  def upvote
    current_user.up_votes(@athlete)
    respond_to do |format|
      format.html { redirect_to athletes_path, notice: 'Successfully voted!' }
    end
  end

  def outbound
    @athlete.clicks.create! user: current_user
    redirect_to @athlete.url
  end

  # GET /athletes/new
  def new
    @athlete = Athlete::Base.new
  end

  # POST /athletes
  # POST /athletes.json
  def create
    @athlete = Athlete::Link.new athlete_params.merge user: current_user

    instagram_name = URI(athlete_params["instagram_url"]).path.split('/').last
    avatar_url = "https://res.cloudinary.com/demo/image/instagram_name/w_75,h_75,c_fill/"+instagram_name+".jpg"
    @athlete.avatar_url = avatar_url
    @athlete.url = avatar_url

    respond_to do |format|
      if @athlete.save
        format.html { redirect_to athlete_comments_path(@athlete), notice: 'Athlete was successfully created.' }
        format.json { render :show, status: :created, location: athlete_path(@athlete) }
      else
        handle_athlete_error format, :new
      end
    end
  end

  def top
    @athletes = Athlete::Base.order("cached_votes_score DESC")

    if params[:tag].present?
      @athletes = @athletes.tagged_with(params[:tag])
    end
  end

  private

  def set_date
    return unless params[:year] && params[:month] && params[:day]
    @date = Date.strptime("#{params[:year]}-#{params[:month]}-#{params[:day]}")
  end

  def handle_athlete_error(format, action = :edit)
    format.html { render action }
    format.json { render json: @athlete.errors, status: :unprocessable_entity }
  end

  def set_user
    @user = User.friendly.find(params[:user_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_athlete
    @athlete = Athlete::Base.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def athlete_params
    params.require(:athlete).permit(:title, :description, :url, :instagram_url, :tag_list)
  end
end
