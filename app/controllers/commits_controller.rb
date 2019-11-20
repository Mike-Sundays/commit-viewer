require './lib/commit_lister/git_cli/lister'
class CommitsController < ApplicationController
  def index
    result = CommitListerCli::Lister.new(
        safe_params["url"],
        safe_params["page"],
        safe_params["per_page"]
    ).run

    if result.successful
      render :json => {:data => result.data}, status: :ok

    elsif !result.successful && result.valid_input
      render :json => {:errors => result.error}, :status => :internal_server_error

    elsif !result.successful && !result.valid_input
      render :json => {:errors => result.error}, :status => :bad_request
    end
  end

  private

  def safe_params
    params.require(:url)
    params.permit(:url,  :page, :per_page)
  end
end