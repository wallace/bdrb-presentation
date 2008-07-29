class CreateLongRunningTasks < ActiveRecord::Migration
  def self.up
    create_table :long_running_tasks do |t|
      t.string :task
      t.integer :max

      t.timestamps
    end
  end

  def self.down
    drop_table :long_running_tasks
  end
end
