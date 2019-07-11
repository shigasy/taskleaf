class AddUserIdToTasks < ActiveRecord::Migration[5.2]
  class Tasks < ActiveRecord::Base
  end

  def up
    execute 'DELETE FROM tasks;'
    add_reference :tasks, :user, null: false, index: true
  end

  def down
    remove_reference :tasks, :user, null:false, index: true
  end
end


