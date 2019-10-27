# Credit: https://stackoverflow.com/questions/28639439/rails-repeated-activerecordrecordnotunique-when-creating-objects-with-postgre 
namespace :fix_auto_increment do
  desc 'Resets Postgres auto-increment ID column sequences to fix duplicate ID errors'

  task reset: :environment do
    ActiveRecord::Base.connection.reset_pk_sequence!('scenario_groups')
  end
end