class Init < ActiveRecord::Migration
  def self.up

    create_table :applications do |t|
      t.string  :name,     :null => false
      t.integer :port,     :null => false
      t.string  :revision, :null => false
      t.timestamps
    end
    add_index  :applications, :name, :unique => true
    add_index  :applications, :port, :unique => true

    create_table :users do |t|
      t.string  :email,    :null => false
      t.string  :pubkey,   :null => false
      t.timestamps
    end
    add_index  :users, :email,  :unique => true
    add_index  :users, :pubkey, :unique => true

  end
end
