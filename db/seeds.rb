# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Create user roles
admin_role = Role.create(:name => "admin")
member_role = Role.create(:name => "member")

# Create Robert Walker as an administrator
robert = User.create(:login => 'robertwalker',
                 :email => 'robert4723@me.com',
                 :password => "railsdev",
                 :password_confirmation => "railsdev",
                 :first_name => "Robert",
                 :last_name => "Walker")
robert.roles << admin_role
robert.state = "active"
robert.save
