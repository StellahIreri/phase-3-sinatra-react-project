class AddImageUrlToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :imageUrl, :string
  end
end
