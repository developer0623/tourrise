class CreateMailerConfigurations < ActiveRecord::Migration[6.0]
  def change
    create_table :mailer_configurations do |t|
      t.string :frontoffice_inbox
      t.string :sender

      t.timestamps
    end
  end
end
