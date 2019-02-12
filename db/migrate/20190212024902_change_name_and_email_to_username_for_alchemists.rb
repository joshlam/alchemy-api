class ChangeNameAndEmailToUsernameForAlchemists < ActiveRecord::Migration[5.2]
  def change
    change_table :alchemists do |t|
      t.remove :name
      t.rename :email, :username
    end
  end
end
