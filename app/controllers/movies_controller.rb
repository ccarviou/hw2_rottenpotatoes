class MoviesController < ApplicationController

  def show
	id = params[:id] # retrieve movie ID from URI route
   	@movie = Movie.find(id) # look up movie by unique ID
    	# will render app/views/movies/show.<extension> by default
  end

  def index
    



	@sortid = params[:sortid] #save the sort request as a accessible local variable

	
		details = {'title'=>'title', 'release_date'=>'release_date'} #create a hash to compare and see if sort request is valid
		if details.has_key?(@sortid) #determine if sort is valid
			mov = Movie.order(@sortid) #sort movies by valid sort type
		else
			@sortid = nil  #sort type was not valid and will not be stored
			mov = Movie  #keep old order
		end
			@movies = mov.all #populate the movies table with all movies referenced by mov

	
		
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
