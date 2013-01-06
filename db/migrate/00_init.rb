class Init < ActiveRecord::Migration
  def self.up

    create_table :applications do |t|
      t.string  :name,       :null => false
      t.string  :revision
      t.string  :subdomain,  :null => false
      t.timestamps
    end
    add_index  :applications, :name, :unique => true
    add_index  :applications, :subdomain, :unique => true

    create_table :app_servers do |t|
      t.integer :application_id, :null => false
      t.string  :host,           :null => false
      t.integer :port,           :null => false
    end
    add_index  :app_servers, [:host, :port], :unique => true

    create_table :db_servers do |t|
      t.integer :application_id, :null => false
      t.string  :host,           :null => false
      t.string  :mysql_db,       :null => false
      t.string  :mongo_db,       :null => false
      t.integer :redis_db,       :null => false
    end
    add_index  :db_servers, :mysql_db, :unique => true
    add_index  :db_servers, :mongo_db, :unique => true
    add_index  :db_servers, :redis_db, :unique => true

    create_table :environments do |t|
      t.integer :application_id, :null => false
      t.string  :key,            :null => false
      t.string  :value,          :null => false
    end
    add_index  :environments, [:application_id, :key], :unique => true

    create_table :users do |t|
      t.string  :email,    :null => false
      t.string  :pubkey,   :null => false
      t.timestamps
    end
    add_index  :users, :email,  :unique => true
    add_index  :users, :pubkey, :unique => true

  end
end
