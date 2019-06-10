# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[5.2]
  def self.up
    change_table :users do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
  end

  def self.down
    remove_index :users, :email
    remove_index :users, :reset_password_token
    remove_index :users, :confirmation_token

    change_table :users do |t|
      t.remove :encrypted_password, :reset_password_token, :reset_password_sent_at,
               :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at,
               :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at,
               :confirmation_sent_at, :unconfirmed_email
    end
  end
end
