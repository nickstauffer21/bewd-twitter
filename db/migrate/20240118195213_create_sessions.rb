class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.string :token
      t.references :user, foreign_key: true, index: true
      t.timestamps
    end
  end
end
