class AddCompanyIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :company_id, :bigint, index: true
  end
end
