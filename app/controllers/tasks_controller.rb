class TasksController < ApplicationController
    before_action :require_user_logged_in #追加した部分
    before_action :correct_user, only: [:destroy] #追加した部分
    
    def index
      @tasks = Task.all
      
        if logged_in?
            @task = current_user.tasks.build  # form_with 用
            @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
        end
    end
    
    def show
        @tasks = Task.find(params[:id])
    end
    
    def new
        @tasks = Task.new
    end
    
    def create
        @tasks = current_user.tasks.build(tasks_params)    #変更した箇所：correct_user追加　taskをtasksに @tasksをtaskに

        if @tasks.save
            flash[:success] = 'Task が正常に投稿されました'
            redirect_to @tasks
    
        else
            flash.now[:danger] = 'Task が投稿されませんでした'
            render :new
        end
    end
    
    def edit
        @tasks = Task.find(params[:id])
    end
    
    def update
        @tasks = Task.find(params[:id])
        
        if @tasks.update(tasks_params)
            flash[:success] = 'Task は正常に更新されました'
            redirect_to @tasks
            
        else
            flash.now[:danger] = 'Task は更新されませんでした'
            render :edit
        end
        
    end
    
    def destroy
        @tasks = Task.find(params[:id])
        @tasks.destroy
        
        flash[:success] = 'Task は正常に削除されました'
        redirect_to tasks_url
    end
    
    private

    def tasks_params
        params.require(:task).permit(:status, :content)
    end
    
    def correct_user
    @tasks = current_user.tasks.find_by(id: params[:id])
        unless @tasks
          redirect_to root_url
        end
    end 
end