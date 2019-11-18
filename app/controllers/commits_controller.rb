require './lib/commit_lister/lister'
class CommitsController < ApplicationController
  def index
    result = CommitLister::Lister.new(safe_params["url"]).run
    if result[:success]
      render :json => {:data => result[:data]}
    else
      render :json => {:errors => result[:error]}, :status => :internal_server_error
    end
  end

  private

  def safe_params
    params.require(:url)
    params.permit(:url)
  end
end