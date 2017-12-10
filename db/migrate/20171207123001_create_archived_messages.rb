class CreateArchivedMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :archived_messages do |t|
      t.integer  :offset,      null: false
      t.string   :topic,       null: false
      t.integer  :partition,   null: false
      t.text     :value,       null: false
      t.string   :key
      t.integer  :create_time

      t.index :topic
      t.index [:topic, :partition]
      t.index [:topic, :partition, :offset], order: { offset: :asc }, unique: true
    end
  end
end
