class MoviesController < ApplicationController
  def index
    # TODO: extract loginc into a Search service
    if _index_params[:user_id]
      @submitter = User[_index_params[:user_id]]
      scope = Movie.find(user_id: @submitter.id)
    elsif !current_user
      scope = Movie.all
    else
      @current_filter = _index_params.fetch(:filter, 'i_neutral')
      scope = case @current_filter
              when 'i_liked'
                current_user.liked_movies
              when 'i_hated'
                current_user.hated_movies
              when 'i_neutral'
                Movie.all
              else
                raise "invalid filter param: #{@current_filter}"
              end
    end

    @current_sort = _index_params.fetch(:by, 'likers')
    @movies = case @current_sort
    when 'likers'
      scope.sort(by: 'Movie:*->liker_count', order: 'DESC')
    when 'haters'
      scope.sort(by: 'Movie:*->hater_count', order: 'DESC')
    when 'date'
      scope.sort(by: 'Movie:*->created_at',  order: 'DESC')
    end
  end

  def new
    authorize! :create, Movie

    @movie = Movie.new
    @validator = NullValidator.instance
  end

  def create
    authorize! :create, Movie

    attrs = _create_params.merge(user: current_user)
    @movie = Movie.new(attrs)
    @validator = MovieValidator.new(@movie)

    if @validator.valid?
      @movie.save
      flash[:notice] = "Movie added"
      redirect_to root_url
    else
      flash[:error] = "Errors were detected"
      render 'new'
    end
  end

  private

  def _index_params
    params.permit(:by, :user_id, :filter)
  end

  def _create_params
    params.permit(:title, :description, :date)
  end
end
