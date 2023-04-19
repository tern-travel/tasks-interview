# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

4.times do |i|
  User.where(email: "user#{i + 1}@tern.travel").first_or_create!(
    name: "User #{i + 1}", password: "abc123", password_confirmation: "abc123"
  )
end

10.times do |i|
  Task.where(title: "Task #{i + 1}").first_or_create!(
    description: <<~EOF
      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
      Non consectetur a erat nam at. Tellus elementum sagittis vitae et leo duis ut diam. Magna eget est lorem ipsum dolor.
    EOF
  )
end
