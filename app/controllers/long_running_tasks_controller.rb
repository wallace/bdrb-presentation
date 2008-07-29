class LongRunningTasksController < ApplicationController
  # GET /long_running_tasks
  # GET /long_running_tasks.xml
  def index
    @long_running_tasks = LongRunningTask.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @long_running_tasks }
    end
  end

  # GET /long_running_tasks/1
  # GET /long_running_tasks/1.xml
  def show
    @long_running_task = LongRunningTask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @long_running_task }
    end
  end

  # GET /long_running_tasks/new
  # GET /long_running_tasks/new.xml
  def new
    @long_running_task = LongRunningTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @long_running_task }
    end
  end

  # GET /long_running_tasks/1/edit
  def edit
    @long_running_task = LongRunningTask.find(params[:id])
  end

  # POST /long_running_tasks
  # POST /long_running_tasks.xml
  def create
    @long_running_task = LongRunningTask.new(params[:long_running_task])

    respond_to do |format|
      if @long_running_task.save
        flash[:notice] = 'LongRunningTask was successfully created.'
        format.html { redirect_to(@long_running_task) }
        format.xml  { render :xml => @long_running_task, :status => :created, :location => @long_running_task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @long_running_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /long_running_tasks/1
  # PUT /long_running_tasks/1.xml
  def update
    @long_running_task = LongRunningTask.find(params[:id])

    respond_to do |format|
      if @long_running_task.update_attributes(params[:long_running_task])
        flash[:notice] = 'LongRunningTask was successfully updated.'
        format.html { redirect_to(@long_running_task) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @long_running_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /long_running_tasks/1
  # DELETE /long_running_tasks/1.xml
  def destroy
    @long_running_task = LongRunningTask.find(params[:id])
    @long_running_task.destroy

    respond_to do |format|
      format.html { redirect_to(long_running_tasks_url) }
      format.xml  { head :ok }
    end
  end

  def run_task_now_serial
    MiddleMan.worker(:asap_worker).run_user_initiated_job(params[:id])

    @long_running_tasks = LongRunningTask.find(:all)
    render :action => :index
  end
  def run_task_now_concurrently
    MiddleMan.worker(:asap_worker).run_user_initiated_job_concurrently(params[:id])

    @long_running_tasks = LongRunningTask.find(:all)
    render :action => :index
  end
  def run_long_task
    MiddleMan.worker(:asap_worker).register_status(nil)
    MiddleMan.worker(:asap_worker).run_job_with_progress_update

    render :update do |page|
      page.replace "progress", :partial => "progress"
    end
  end
  def progress
    if request.xhr?
      render :update do |page|
        result = MiddleMan.worker(:asap_worker).ask_status.to_i
        page.replace_html "progress_bar", result
        if result >= 100
          page.assign :keep_polling, false 
        end
      end
    end
  end
end
