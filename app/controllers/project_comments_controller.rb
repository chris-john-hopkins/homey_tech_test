class ProjectCommentsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @comment = @project.comments.build(comment_params)

    return render :create if @comment.save

    render turbo_stream: turbo_stream.replace(
      "comment_form",
      partial: "comments/form",
      locals: { commentable: @project, comment: @comment }
    ), status: :unprocessable_entity
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(creator: current_user)
  end
end
