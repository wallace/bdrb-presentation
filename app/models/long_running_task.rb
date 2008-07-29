class LongRunningTask < ActiveRecord::Base
  def self.lengthy_job
    1.upto(10) do |i|
      sleep(1) #do work here
      yield(10, 1) if block_given? #important line for progress
      logger.info "logger: lengthy_job progress #{i}"
      puts "puts lengthy_job progress #{i}"
    end
  end
end
