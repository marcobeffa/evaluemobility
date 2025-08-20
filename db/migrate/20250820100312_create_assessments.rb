# db/migrate/001_create_assessments.rb
class CreateAssessments < ActiveRecord::Migration[8.0]
  def change
    create_table :assessments do |t|
      # Personal info
      t.string :name
      t.integer :age
      t.string :email
      t.string :phone_country_code  # +39, +41, +33, etc.
      t.string :phone_number
      t.boolean :privacy_consent, default: false
      t.boolean :marketing_consent, default: false
      t.text :notes

      # Session management
      t.string :session_token, null: false
      t.integer :current_step, default: 1

      # Exercise scores (0-3, nullable until completed)
      t.integer :flexion_extension
      t.integer :arms_overhead
      t.integer :spine_rotation_right
      t.integer :spine_rotation_left
      t.integer :deep_squat
      t.integer :hands_behind_back_right
      t.integer :hands_behind_back_left
      t.integer :straight_leg_raise_right
      t.integer :straight_leg_raise_left

      t.boolean :completed, default: false
      t.datetime :completed_at

      t.timestamps
    end

    add_index :assessments, :session_token, unique: true
    add_index :assessments, :created_at
    add_index :assessments, :completed
    add_index :assessments, :email
    add_index :assessments, :phone_country_code
  end
end
