namespace :add_more_users do
  desc "Add 20 more users"

  task add_users: :environment do
    40.times do
      Participant.create(password: "secret", password_confirmation: "secret", role: "user")
    end
  end
end