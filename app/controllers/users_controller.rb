class UsersController < ApplicationController
	before_filter :authenticate_user!

	def index
		if current_user.has_role? 'Administrador'
			@users = User.all
		else
			@users = User.where(:operator_id => current_user.operator_id)
		end
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		unless params[:user][:role_ids].blank?
			@user.role_ids << params[:user][:role_ids]
			@user.role_ids.uniq
		end

		if params[:user][:operator_id].blank?
			@user.operator_id = current_user.operator_id
		end

		if @user.save
			flash[:notice] = "Successfully created User."
			redirect_to users_path
		else
			render :action => 'new'
		end
	end


	def update
		@user = User.find(params[:id])
		params[:user].delete(:password) if params[:user][:password].blank?
		params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
		unless params[:user][:role_ids].blank?
			@user.role_ids << params[:user][:role_ids]
			@user.role_ids.uniq
		end
		if @user.update_attributes(params[:user])
			flash[:notice] = "Usuario actualizado correctamente."
			redirect_to users_path
		else
			render :action => 'edit'
		end
	end

	def destroy
		@user = User.find(params[:id])
		if @user.destroy
			flash[:notice] = "Usuario eliminado correctamente."
			redirect_to users_path
		end
	end





end
