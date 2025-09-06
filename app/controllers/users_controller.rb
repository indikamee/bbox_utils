class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.json
  load_and_authorize_resource :except => [:stop_impersonating]
  authorize_resource :class => false,  :except => [:stop_impersonating]

  def index
    @users = User.accessible_by(current_ability)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        #@user.updateCentreSelections(params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def impersonate
    @user = User.find(params[:id])
    impersonate_user(@user)
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Impersonating #{@user.email}" }
    end
    #UserMailer.with(user: @user).test_email.deliver_now
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end
  
  def edit_password
    @user = User.find(params[:id])
  end

  def update_password
    @user = User.find(params[:id])
    pwd_params = params.require(:user).permit(:password, :password_confirmation)
    if @user.update(pwd_params)
      redirect_to users_path, notice: 'Password was successfully updated.'
    else
      render :edit_password
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name)
    end
end
