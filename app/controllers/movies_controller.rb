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
    if (params[:ratings])
      @selected_ratings = params[:ratings].keys
    elsif (session[:ratings])
      @selected_ratings = session[:ratings].keys
    else
      @selected_ratings = @all_ratings
    end
    val = params[:sort].to_s
    if ((val == "title" ) || (session[:sort] == "title" && val != "release_date"))
			if (params[:ratings])
        @movies = Movie.where(:rating => @selected_ratings).order(:title)
        session[:ratings] = params[:ratings]
				@selected_ratings = params[:ratings].keys
				if (session[:sort] == "title" && val != "title")
					redirect_to movies_path(:sort => session[:sort], :ratings => params[:ratings])
				end
			elsif (session[:ratings])
				@movies = Movie.where(:rating => @selected_ratings).order(:title)
				if (session[:sort] == "title")
					redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
				else
					redirect_to movies_path(:sort => params[:sort], :ratings => session[:ratings])
				end
			else
      	@movies = Movie.order(:title)
				if (session[:sort] && val!="title")
					redirect_to movies_path(:sort => "title")
				end 
			end
      @title_header = "hilite"
			session[:sort] = "title"
    elsif ((val == "release_date" ) || (session[:sort] == "release_date" && val != "title"))
			if (params[:ratings])
        @movies = Movie.where(:rating => @selected_ratings).order(:release_date)
        session[:ratings] = params[:ratings]
				@selected_ratings = params[:ratings].keys
				if(session[:sort] == "release_date" && val != "release_date")
					redirect_to movies_path(:sort => session[:sort], :ratings => params[:ratings])
				end
			elsif (session[:ratings])
				@movies = Movie.where(:rating => @selected_ratings).order(:release_date)
				if (session[:sort] == "release_date")
					redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
				else
					redirect_to movies_path(:sort => params[:sort], :ratings => session[:ratings])
				end
			else
      	@movies = Movie.order(:release_date)
				if (session[:sort] && val != "release_date")
					redirect_to movies_path(:sort => "release_date")
				end 
			end
      @release_date_header = "hilite"
			session[:sort] = "release_date"
    else
      if (params[:ratings])
        @movies = Movie.where(:rating => @selected_ratings)
        session[:ratings] = params[:ratings]
      elsif (session[:ratings])
        @movies = Movie.where(:rating => @selected_ratings)
				redirect_to movies_path(:ratings => session[:ratings])
      else
        @movies = Movie.all
        @selected_ratings = Movie.all_ratings
      end
   end
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
