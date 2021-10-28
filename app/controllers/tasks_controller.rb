class TasksController < ApplicationController
    before_action :require_user_logged_in #追加した部分
    before_action :correct_user, only: [:show, :edit, :update, :destroy] #追加した部分
    
    def index
#      @tasks = Task.all
#        if logged_in?
            @tasks = current_user.tasks.all  
#       end
    end
    
    def show
#        @tasks = Task.find(params[:id])
    end
    
    def new
        @task = Task.new
    end
    
    def create
        @task = current_user.tasks.build(tasks_params)    #変更した箇所：correct_user追加　taskをtasksに @tasksをtaskに

        if @task.save
            flash[:success] = 'Task が正常に投稿されました'
            redirect_to @task
    
        else
            flash.now[:danger] = 'Task が投稿されませんでした'
            render :new
        end
    end
    
    def edit
#        @task = Task.find(params[:id])
    end
    
    def update
#        @tasks = Task.find(params[:id])
        
        if @task.update(tasks_params)
            flash[:success] = 'Task は正常に更新されました'
            redirect_to @task
            
        else
            flash.now[:danger] = 'Task は更新されませんでした'
            render :edit
        end
        
    end
    
    def destroy
#        @tasks = Task.find(params[:id])
        @task.destroy
        
        flash[:success] = 'Task は正常に削除されました'
        redirect_to tasks_url
    end
    
    private

    def tasks_params
        params.require(:task).permit(:status, :content)
    end
    
    def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
        unless @task
          redirect_to root_url
        end
    end 
end