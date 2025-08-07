class CreateAdminUser < ActiveRecord::Migration[7.2]
  def up
    user = User.new(
      email: ENV['ADMIN_EMAIL'],
      password: ENV['ADMIN_PASSWORD'],
      password_confirmation: ENV['ADMIN_PASSWORD'],
      username: "admin",
      first_name: "Admin",
      last_name: "Admin",
      is_admin: true,
      balance: 0,
      status: true
    )
    
    user.skip_confirmation! 
    user.save!
  end

  def down
    User.find_by(email: ENV['ADMIN_EMAIL'])&.destroy
  end
end