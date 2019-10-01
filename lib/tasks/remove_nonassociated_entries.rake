namespace :remove_nonassociated_entries do
  desc "Remove things in database that don't have any association."

  task add_users: :environment do
    40.times do
      Participant.create(password: "secret", password_confirmation: "secret", role: "user")
    end
  end
end