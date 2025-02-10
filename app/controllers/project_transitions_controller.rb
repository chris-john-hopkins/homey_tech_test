class ProjectTransitionsController < ApplicationController
  def create
    @state_creator = ::ProjectTransitions::Creator.new(
      project: project,
      creator: current_user,
      to_state: params[:state]
    )

    @state_creator.save

    if @state_creator.errors.empty?
      return redirect_to project, notice: "Project status was successfully updated."
    end

    render "projects/show", status: :unprocessable_entity
  end

  private

  def project
    @project ||= Project.find(params[:project_id])
  end
end
