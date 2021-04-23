require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
  end

  get "/" do
    erb :welcome
  end

  get "/login" do
    erb :login
  end

  post '/login' do
    user = User.find_by(:email => params[:email])
    if user && user.authenticate(params[:password])
			session[:user_id] = user.id
      redirect "/users/home"
    else
      redirect "/login"
    end
  end

  get "/signup" do
    erb :signup
  end


  post '/signup' do
    user = User.new(name: params["name"], email: params["email"], password: params["password"])
    
    if user.save && user && user.authenticate(params[:password])
			session[:user_id] = user.id
      redirect "/users/home"
    else
      redirect "/signup"
		end
  end

  get '/users/home' do
    @user = User.find(session[:user_id])
    @pets = Pet.all
    
    erb :'/users/home'
  end 

  get '/pets/new' do
    @user = User.find(session[:user_id])
    erb :'/pets/new' 
  end

  post '/pets/new' do
    @user = User.find(session[:user_id])

    @pet = Pet.create(:name => params["name"], :age => params["age"], :breed => params["breed"])
    if !@pet.user_id
      @pet.user_id = @user.id
      @pet.save
    end
    
    redirect "/users/home"
  end

  get '/pets/:id' do
    @pet = Pet.find(params[:id])
    erb :'/pets/show' 
  end

  get '/pets/:id/edit' do 
    @user = User.find(session[:user_id])
    @pet = Pet.find(params[:id])
    erb :'/pets/edit'
  end

  patch '/pets/:id' do
    id = params[:id]
    @pet = Pet.find(params[:id])
  
    @pet.update(params[:name])
    @pet.update(params[:age])
    @pet.update(params[:breed])
    
    redirect '/users/home'
  end

  delete '/pets/:id' do 
    id = params[:id]
    pet = Pet.find(params[:id])
    pet.destroy
    redirect '/users/home'
  end

  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

end
