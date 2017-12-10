class CreateCandidates < ActiveRecord::Migration[5.1]
  def change
    create_table :candidates, primary_key: :key, id: :string, default: nil do |t|
      t.integer :vote_count, null: false
    end
  end
end
