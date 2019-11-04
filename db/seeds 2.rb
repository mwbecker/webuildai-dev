# frozen_string_literal: true

person_one = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_two = Participant.create(role: 'admin', password: 'secret', password_confirmation: 'secret')
person_three = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_four = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_five = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_six = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_seven = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_eight = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_nine = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_ten = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_eleven = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_twelve = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_thirteen = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_fourteen = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_fifteen = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_sixteen = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_seventeen = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_eighteen = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_nineteen = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_twenty = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_twenty_one = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_twenty_two = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_twenty_three = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_twenty_four = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')
person_twenty_five = Participant.create(role: 'user', password: 'secret', password_confirmation: 'secret')


### Request Features ###
distance1 = Feature.create(name: "Distance between pickup & drop-off", category: 'request', description: '	Drop-off Distance', unit: 'miles')
tips1 = Feature.create(name: "Customer's average tip perentage", category: "request", description: "Customer Tipping")
feedback1 = Feature.create(name: "Rating customer gave their most recent driver", category: "request", description: "Customer Feedback")
rating1 = Feature.create(name: "Customer Rating", category: "request", description: "Customer Rating")
usage1 = Feature.create(name: "How often the customer uses the service", category: "request", description: "Customer App Usage")

### Driver Features ###
tenure1 = Feature.create(name: 'How long the driver worked for the company', category: 'driver', description: 'Tenure', unit: 'months')
acceptance1 = Feature.create(name: "Driver's request acceptance rate", category: 'driver', description: 'Acceptance Rate', unit: '%')
acceptance2 = Feature.create(name: "Driver's request acceptance rate that day", category: 'driver', description: 'Acceptance Rate')
completion1 = Feature.create(name: "Driver's cancellation rate", category: 'driver', description: 'Completion Rate')
completion2 = Feature.create(name: "Driver's cancellation rate that day", category: 'driver', description: 'Completion Rate')



### Data Range for Request Features ###
data_range_distance1 = DataRange.create(feature_id: distance1.id, is_categorical: false, lower_bound: 0, upper_bound: 35)
data_range_tips1 = DataRange.create(feature_id: tips1.id, is_categorical: false, lower_bound: 0, upper_bound: 25)
data_range_feedback1 = DataRange.create(feature_id: feedback1.id, is_categorical: false, lower_bound: 0, upper_bound: 5)
data_range_rating1 = DataRange.create(feature_id: rating1.id, is_categorical: false, lower_bound: 3, upper_bound: 5)
data_range_usage1 = DataRange.create(feature_id: usage1.id, is_categorical: false, lower_bound: 1, upper_bound: 5)

### Data Range for Driver Features ###
data_range_tenure1 = DataRange.create(feature_id: tenure1.id, is_categorical: false, lower_bound: 0, upper_bound: 24)
data_range_acceptance1 = DataRange.create(feature_id: acceptance1.id, is_categorical: false, lower_bound: 50, upper_bound: 100)
data_range_acceptance2 = DataRange.create(feature_id: acceptance2.id, is_categorical: false, lower_bound: 50, upper_bound: 100)
data_range_completion1 = DataRange.create(feature_id: completion1.id, is_categorical: false, lower_bound: 50, upper_bound: 100)
data_range_completion2 = DataRange.create(feature_id: completion2.id, is_categorical: false, lower_bound: 50, upper_bound: 100)