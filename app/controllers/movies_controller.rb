class MoviesController < ApplicationController

  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @sorting = params[:sort]
    @rate = params[:ratings]
    
    @rate = params[:ratings]
    if  @rate.nil?
      @sel_rate = @all_ratings
    else
      @sel_rate = params[:ratings].keys
    end

    if @sorting.nil?
      @sorting = session[:sort]
    else
      session[:sort] = @sorting
    end
    
    @movies = Movie.order("#{@sorting}").where(rating: @sel_rate).all
    
    if params[:sort] == 'title'
      @t = 'hilite'
    elsif params[:sort] == 'release_date'
      @r ='hilite'
    end
    
    @rate = params[:ratings]
    if  @rate.nil?
      @sel_rate = session[:ratings]
    else
      @sel_rate = params[:ratings].keys
      session[:ratings] = @sel_rate
    end

    @movies = Movie.save_ratings(@sel_rate).order("#{@sorting}").all
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
