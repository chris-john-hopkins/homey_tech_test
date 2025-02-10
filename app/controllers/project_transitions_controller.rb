class ProjectTransitionsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    if @project.transition_to(params[:state])
      return redirect_to @project, notice: "Project status was successfully updated."
    end
    @project.errors.add(:state, "Cannot transition from #{@project.current_state} to #{params[:state]}")
    render "projects/show", status: :unprocessable_entity
  end
end
