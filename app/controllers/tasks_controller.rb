class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    # @tasks = Task.all
    # @tasks = current_user.tasks.order(created_at: :desc) # ログインしているユーザーに紐づくTaskだけ表示
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)
    # @tasks = current_user.tasks.recent # ログインしているユーザーに紐づくTaskだけ表示
  end

  def show
  end

  def new
    @task = Task.new
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  def create
    # @task = Task.new(task_params.merge(user_id: current_user.id)) # インスタンス変数を使う理由はビューに渡すことが出来る。入力内容とエラー箇所を渡せる。
    @task = current_user.tasks.new(task_params) # インスタンス変数を使う理由はビューに渡すことが出来る。入力内容とエラー箇所を渡せる。

    if params[:back].present?
      render :new
      return
    end

    if @task.save
      TaskMailer.create_creation_email(@task).deliver_now
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
