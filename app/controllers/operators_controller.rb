class OperatorsController < ApplicationController
  before_filter :require_authorization, only: [:show]
  # GET /operators
  # GET /operators.json

  def require_authorization
    unless params[:id] == current_user.operator_id or current_user.has_role? 'Administrador' or current_user.has_role? 'Administrador'
      flash[:error] = "No tiene acceso a esa informacion"
      redirect_to operator_path(current_user.operator_id) # halts request cycle
    end
  end

  def index
    @operators = Operator.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @operators }
    end
  end

  # GET /operators/1
  # GET /operators/1.json
  def show
    @operator = Operator.find(params[:id].to_i)
    @recorridos = Recorrido.where(:operator_id => @operator.id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @operator }
    end
  end

end
