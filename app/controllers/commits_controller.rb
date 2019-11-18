require './lib/commit_lister/lister'
class CommitsController < ApplicationController
  def index
    result = CommitLister::Lister.new(safe_params["url"]).run

    if result[:success]
      render :json => {:data => result[:data]}, status: :ok

    elsif !result[:success] && result[:valid_input]
      render :json => {:errors => result[:error]}, :status => :internal_server_error

    elsif !result[:success] && !result[:valid_input]
      render :json => {:errors => result[:error]}, :status => :bad_request
    end
  end

  private

  def safe_params
    params.require(:url)
    params.permit(:url)
  end
end