class Api::ObservationsController < ApplicationController

  before_filter :check_auth

  def check_auth
    return render :nothing => true, :status => 403 if current_user.nil?
  end

  def index
    p Time.at(params[:from].to_i)
    data = current_user.observations
    data = data.where("created_at > ?", Time.at(params[:from].to_i)) unless params[:from].blank?
    respond_to do |f|
      f.html { render :nothing => true }
      f.json { render :json => data.to_json }
    end
  end

  def create
    return render :nothing => true, :status => 406 if params[:consumption].nil?
    o = Observation.new
    o.consumption = params[:consumption]
    current_user.observations << o
    current_user.save!
    respond_to do |f|
      f.html { render :nothing => true }
      f.json { render :json => o.to_json }
    end
  end
end
