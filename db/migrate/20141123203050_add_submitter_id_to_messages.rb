class AddSubmitterIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :submitter_id, :integer
    add_index :messages, :submitter_id
  end
end
