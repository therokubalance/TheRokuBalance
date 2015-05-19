class CreateTherokus < ActiveRecord::Migration
  def change
    create_table :therokus do |t|
      t.string :variable
      t.string :value

      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        Theroku.create(variable: "active_url", value: "url1")
      end
    end
  end
end
