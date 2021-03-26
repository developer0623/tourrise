class RemoveCoulmnHandleForCancellationReasons < ActiveRecord::Migration[6.0]
  def change
    remove_column :cancellation_reasons, :handle, :string
  end
end
