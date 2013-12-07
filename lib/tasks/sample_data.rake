namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
	make_projects
	make_status
	make_period
  end
end

def make_users
  admin = User.create!(name:     "Admin1",
                       email:    "admin1@gmail.com",
					   phone:    "1234567890",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)
  
  admin = User.create!(name:     "Admin2",
                       email:    "admin2@gmail.com",
					   phone:    "1234567890",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)
  
  admin = User.create!(name:     "Admin3",
                       email:    "admin3@gmail.com",
					   phone:    "1234567890",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)
  
  admin = User.create!(name:     "Admin4",
                       email:    "admin4@gmail.com",
					   phone:    "1234567890",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)

end

def make_projects
  Project.create!(name: "Ardmore - Donation Processing")
  Project.create!(name: "Ardmore - Retail Floor")
  Project.create!(name: "Ardmore - Others")
  Project.create!(name: "Greenwood - Retail")
  Project.create!(name: "Greenwood - Others")
  Project.create!(name: "Crescent - Client Intake")
  Project.create!(name: "Crescent - Assistance Office")
  Project.create!(name: "Crescent - Reception")
  Project.create!(name: "Crescent - Pantry")
  Project.create!(name: "Crescent - Bread Basket")
  Project.create!(name: "Crescent - Client Choice")
  Project.create!(name: "Crescent - Others")
end

def make_status
  Status.create!(name: "Pending")
  Status.create!(name: "Group")
  Status.create!(name: "Temporary")
  Status.create!(name: "Permanent")
  Status.create!(name: "Community Service")
  Status.create!(name: "CPC")
end

def make_period
  Period.create!(name: "Morning")
  Period.create!(name: "Afternoon")
end

