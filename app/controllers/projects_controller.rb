class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:rich_text_description).all
  end

  def show
    @project = Project.find(params[:id])
  end
end
