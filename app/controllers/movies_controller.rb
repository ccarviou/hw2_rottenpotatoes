class MoviesController < ApplicationController

  def show
	id = params[:id] # retrieve movie ID from URI route
   	@movie = Movie.find(id) # look up movie by unique ID
    	# will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:commit] == 'Refresh'  # if user refreshes reset the ratings
		if params[:ratings] == nil
			params[:ratings] = session[:ratings]
		else
			session[:ratings] = params[:ratings]
		end
	else if session[:ratings] != params[:ratings] #if the user changes the ratings they would like to see, store themi params
		change = true
		params[:ratings] = session[:ratings]
	end
	end
	 
	if params[:sortid] #save the sort request
		session[:sortid] = params[:sortid]
	else if session[:sortid] #if params has no sortid, recall old sortid request from session
		change = true
		params[:sortid] = session[:sortid]
	end
	end

	@sortid = session[:sortid] #save the sort request and ratings as accessible local variables
	@ratings = session[:ratings]

	if change
		redirect_to movies_path({:sortid=>@sortid, :ratings=>@ratings}) #recall old sortid if member comes back from other page
	else if
		details = {'title'=>'title', 'release_date'=>'release_date'} #create a hash to compare and see if sort request is valid
		if details.has_key?(@sortid) #determine if sort is valid
			mov = Movie.order(@sortid) #sort movies by valid sort type
		else
			@sortid = nil #sort type was not valid and will not be stored
			mov = Movie #keep old order
		end

	
		if @ratings == nil #if no ratings are recorded show all movies else find the movies with the ratings listed by map function
			@movies = mov.all
		else
			@movies = mov.find_all_by_rating(@ratings.map {|r| r}) 
		end

			@all_ratings = Movie.ratings #populate the ratings table with all the ratings given by the model
	end
	end

	
		
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
