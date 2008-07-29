class AsapWorker < BackgrounDRb::MetaWorker
  set_worker_name :asap_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
    puts "asap_worker with args: #{args.inspect} for first time worker is loaded for initialization stuff"
  end
  def run_user_initiated_job(args = nil)
    puts "asap_worker:run_user_initiated_job with args: #{args.inspect}"
    t = LongRunningTask.find(args)
    puts "t is #{t.inspect}"
    puts "task result is: " 
    eval(t.task)
    puts "\ntask done\n\n"
  end
  def run_user_initiated_job_concurrently(args=nil)
    #beware: not thread safe to use register_status. need your own mutex if you do
    #default amt of threads per worker: 20
    #configurable via :pool_size
    thread_pool.defer { run_user_initiated_job(args) }
  end
  def run_job_with_progress_update
    puts "this is a long running job"

    temp_progress = 0
    LongRunningTask.lengthy_job do |max_value, increment|
      temp_progress += increment
      register_status((temp_progress*100.0 / max_value).round) if max_value > 0
    end
    puts "finished long running job"
  end
end

