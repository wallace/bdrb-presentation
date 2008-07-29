class ScheduledWorker < BackgrounDRb::MetaWorker
  set_worker_name :scheduled_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
    puts "someone just started a scheduled worker with args: #{args.inspect}\n\n"
  end
  def run_next_job(args = nil)
    puts "scheduled worker running run_next_job with args: #{args.inspect}\n\n"
  end
end

