class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:rich_text_description).all
  end

  def show
    @project = Project
                .includes(
                  :rich_text_description,
                  :project_transitions,
                  comments: [ :creator ]
                ).find(params[:id])
  end
end
