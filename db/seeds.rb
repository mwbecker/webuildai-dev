# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

person_one =   Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_two  =  Participant.create(role:'admin', password: "secret", password_confirmation: "secret")
person_three = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_four = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_five = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_six = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_seven = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_eight = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_nine = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_ten = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_eleven = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_twelve = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_thirteen = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_fourteen = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_fifteen = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_sixteen = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_seventeen = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_eighteen = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_nineteen = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_twenty = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_twenty_one = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_twenty_two = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_twenty_three = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_twenty_four = Participant.create(role:'user', password: "secret", password_confirmation: "secret")
person_twenty_five = Participant.create(role:'user', password: "secret", password_confirmation: "secret")

a = Feature.create(name: "A", category: "driver", description: "Logistics")
b = Feature.create(name: "B", category: "driver", description: "Logistics")
c = Feature.create(name: "C", category: "request", description: "Speed/Efficacy")

### Request Features ###
distance1 = Feature.create(name: "The distance to the restaurant/customer's origin", category: "request", description: "Distance / Location")
distance2 = Feature.create(name: "The distance from the customer's origin to their destination (if applicable)", category: "request", description: "Distance / Location")
distance3 = Feature.create(name: "The distance from the restaurant to the delivery destination (if applicable)", category: "request", description: "Distance / Location")
distance4 = Feature.create(name: "The total distance of the driver's entire trip", category: "request", description: "Distance / Location")
# tip1 = Feature.create(name: "How often the customer tips their drivers", category: "request", description: "Customer Tipping")
# tip2 = Feature.create(name: "The average monetary amount the customer tips for each ride/delivery", category: "request", description: "Customer Tipping")
# feedback1 = Feature.create(name: "The customer's rating of their most recent driver", category: "request", description: "Customer Feedback")
# feedback2 = Feature.create(name: "The average rating the customer gives their drivers", category: "request", description: "Customer Feedback")
# usage1 = Feature.create(name: "How frequently the customer uses the company's app", category: "request", description: "Customer's App Usage")
# usage2 = Feature.create(name: "How long the customer has had an account with the company's app", category: "request", description: "Customer's App Usage")
# cancellation1 = Feature.create(name: "The number of requests the customer has cancelled today", category: "request", description: "Customer’s Cancellation Rate")
# cancellation2 = Feature.create(name: "The number of requests the customer has cancelled since they first started", category: "request", description: "Customer’s Cancellation Rate")

### Driver Features ###
tenure1 = Feature.create(name: "How long the driver has been working for their company", category: "driver", description: "Tenure")
acceptance1 = Feature.create(name: "The driver's total acceptance rate of requests since they first started", category: "driver", description: "Acceptance Rate")
acceptance2 = Feature.create(name: "The driver's total acceptance rate of requests today", category: "driver", description: "Acceptance Rate")
completion1 = Feature.create(name: "The driver's total completion rate of requests today", category: "driver", description: "Completion Rate")
# completion2 = Feature.create(name: "The driver's total completion rate of requests since they first started", category: "driver", description: "Completion Rate")
# earnings1 = Feature.create(name: "The driver's total earnings since they first started", category: "driver", description: "Earnings")
# earnings2 = Feature.create(name: "The driver's total earnings today", category: "driver", description: "Earnings")
# tips1 = Feature.create(name: "The number of tips the driver received today", category: "driver", description: "Tips")
# tips2 = Feature.create(name: "The number of tips the driver received since they first started", category: "driver", description: "Tips")
# tips3 = Feature.create(name: "The total monetary amount earned in tips today", category: "driver", description: "Tips")
# tips4 = Feature.create(name: "The total monetary amount earned in tips since the driver first started", category: "driver", description: "Tips")
# socialDistance1 = Feature.create(name: "The distance to the restaurant/customer's origin", category: "driver", description: "Distance / Location")
# socialDistance2 = Feature.create(name: "The distance from the customer's origin to their destination (if applicable)", category: "driver", description: "Distance / Location")
# socialDistance3 = Feature.create(name: "The distance from the restaurant to the delivery destination (if applicable)", category: "driver", description: "Distance / Location")
# socialDistance4 = Feature.create(name: "The total distance of the driver's entire trip", category: "driver", description: "Distance / Location")
# rating1 = Feature.create(name: "Driver Rating", category: "driver", description: "Driver Rating")
# hours1 = Feature.create(name: "The number of hours the driver worked today", category: "driver", description: "Hours Worked")
# hours2 = Feature.create(name: "The number of hours the driver has worked since they first started", category: "driver", description: "Hours Worked")

data_range_1 = DataRange.create(feature_id: a.id, is_categorical: true)
data_range_2 = DataRange.create(feature_id: b.id, is_categorical: false, lower_bound: 0, upper_bound: 10)
data_range_3 = DataRange.create(feature_id: c.id, is_categorical: false, lower_bound: 1, upper_bound: 25)


### Data Range for Request Features ###
data_range_distance1 = DataRange.create(feature_id: distance1.id, is_categorical: false, lower_bound: 0, upper_bound: 70)
data_range_distance2 = DataRange.create(feature_id: distance2.id, is_categorical: false, lower_bound: 0, upper_bound: 70)
data_range_distance3 = DataRange.create(feature_id: distance3.id, is_categorical: false, lower_bound: 0, upper_bound: 70)
data_range_distance4 = DataRange.create(feature_id: distance4.id, is_categorical: false, lower_bound: 0, upper_bound: 140)
# data_range_tips1 = DataRange.create(feature_id: tips1.id, is_categorical: false, lower_bound: 0, upper_bound: 100)
# data_range_tips2 = DataRange.create(feature_id: tips2.id, is_categorical: false, lower_bound: 0, upper_bound: 100)
# data_range_feedback1 = DataRange.create(feature_id: feedback1.id, is_categorical: false, lower_bound: 1, upper_bound: 5)
# data_range_feedback2 = DataRange.create(feature_id: feedback2.id, is_categorical: false, lower_bound: 1, upper_bound: 5)
# data_range_usage1 = DataRange.create(feature_id: usage1.id, is_categorical: false, lower_bound: 0, upper_bound: 30)
# # Minutes to years?
# data_range_usage2 = DataRange.create(feature_id: usage2.id, is_categorical: false, lower_bound: 0, upper_bound: 8)
# data_range_cancellation1 = DataRange.create(feature_id: cancellation1.id, is_categorical: false, lower_bound: 0, upper_bound: 100)
# data_range_cancellation2 = DataRange.create(feature_id: cancellation2.id, is_categorical: false, lower_bound: 0, upper_bound: 100)

### Data Range for Driver Features ###
# Days to years?
data_range_tenure1 = DataRange.create(feature_id: tenure1.id, is_categorical: false, lower_bound: 0, upper_bound: 5)
data_range_acceptance1 = DataRange.create(feature_id: acceptance1.id, is_categorical: false, lower_bound: 50, upper_bound: 100)
data_range_acceptance2 = DataRange.create(feature_id: acceptance2.id, is_categorical: false, lower_bound: 50, upper_bound: 100)
data_range_completion1 = DataRange.create(feature_id: completion1.id, is_categorical: false, lower_bound: 50, upper_bound: 100)
# data_range_completion2 = DataRange.create(feature_id: completion2.id, is_categorical: false, lower_bound: 50, upper_bound: 100)
# data_range_earnings1 = DataRange.create(feature_id: earnings1.id, is_categorical: false, lower_bound: 0, upper_bound: 985500)
# data_range_earnings2 = DataRange.create(feature_id: earnings2.id, is_categorical: false, lower_bound: 0, upper_bound: 540)
# data_range_tips1 = DataRange.create(feature_id: tips1.id, is_categorical: false, lower_bound: 0, upper_bound: 30)
# data_range_tips2 = DataRange.create(feature_id: tips2.id, is_categorical: false, lower_bound: 0, upper_bound: 54750)
# data_range_tips3 = DataRange.create(feature_id: tips3.id, is_categorical: false, lower_bound: 0, upper_bound: 3000)
# data_range_tips4 = DataRange.create(feature_id: tips4.id, is_categorical: false, lower_bound: 0, upper_bound: 54750000)
# data_range_socialDistance1 = DataRange.create(feature_id: socialDistance1.id, is_categorical: false, lower_bound: 0, upper_bound: 70)
# data_range_socialDistance2 = DataRange.create(feature_id: socialDistance2.id, is_categorical: false, lower_bound: 0, upper_bound: 70)
# data_range_socialDistance3 = DataRange.create(feature_id: socialDistance3.id, is_categorical: false, lower_bound: 0, upper_bound: 70)
# data_range_socialDistance4 = DataRange.create(feature_id: socialDistance4.id, is_categorical: false, lower_bound: 0, upper_bound: 140)
# data_range_rating1 = DataRange.create(feature_id: rating1.id, is_categorical: false, lower_bound: 1, upper_bound: 5)
# data_range_hours1 = DataRange.create(feature_id: hours1.id, is_categorical: false, lower_bound: 0, upper_bound: 12)
# data_range_hours2 = DataRange.create(feature_id: hours2.id, is_categorical: false, lower_bound: 0, upper_bound: 21900)


cat_dat_opt_1 = CategoricalDataOption.create(data_range_id: data_range_1.id, option_value: "Apple")
cat_dat_opt_2 = CategoricalDataOption.create(data_range_id: data_range_1.id, option_value: "Bannana")
cat_dat_opt_3 = CategoricalDataOption.create(data_range_id: data_range_1.id, option_value: "Orange")



scenario_1_a = Scenario.create(group_id: 1, feature_id: a.id, feature_value: "Apple")
scenario_1_b = Scenario.create(group_id: 1, feature_id: b.id, feature_value: "10")
scenario_1_c = Scenario.create(group_id: 1, feature_id: c.id, feature_value: "3")

scenario_2_a = Scenario.create(group_id: 2, feature_id: a.id, feature_value: "Bannana")
scenario_2_b = Scenario.create(group_id: 2, feature_id: b.id, feature_value: "5")
scenario_2_c = Scenario.create(group_id: 2, feature_id: c.id, feature_value: "20")

scenario_3_a = Scenario.create(group_id: 3, feature_id: a.id, feature_value: "Orange")
scenario_3_b = Scenario.create(group_id: 3, feature_id: b.id, feature_value: "4")
scenario_3_c = Scenario.create(group_id: 3, feature_id: c.id, feature_value: "21")
