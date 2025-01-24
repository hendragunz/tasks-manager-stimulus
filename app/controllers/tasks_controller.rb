class TasksController < ApplicationController
  def index
    @tasks = Task.order(created_at: :desc)
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        @task.broadcast_render_to :stream_tasks, partial: 'tasks/create', locals: { task: @task }
        format.html { redirect_to tasks_url, notice: "Task was successfully created" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # # no longer needed here
  # #
  # def toggle
  #   @task = Task.find(params[:id])
  #   @task.update(completed: params[:completed])
  #   render json: { message: "Success" }
  # end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    respond_to do |format|
      if @task.update(task_params)
        # format.turbo_stream
        @task.broadcast_render_to :stream_tasks, partial: 'tasks/update', locals: { task: @task }
        format.html { redirect_to tasks_url, notice: "Task was successfully updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      @task.broadcast_render_to :stream_tasks, partial: 'tasks/destroy', locals: { task: @task }
      format.html { redirect_to tasks_url, notice: "Post was successfully deleted." }
    end
  end

  private

  def task_params
    params.require(:task).permit(:description, :completed)
  end
end
