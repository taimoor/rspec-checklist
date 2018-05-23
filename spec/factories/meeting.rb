# # meetings Model
# FactoryBot.define do
#
#   factory :meeting do
#     sequence(:title) { |n| "Meeting Title #{n}" }
#     start_time Time.now + 1.day
#
#     # create subscription
#     after(:create) do |meeting, evaluator|
#       user = Features::SessionHelpers.current_test_user
#       FactoryBot.create(:meeting_subscription, meeting: meeting, user: user, created_by: user)
#     end
#
#     # sample data
#     trait :with_sample_data do
#       after(:create) do |meeting ,evaluator|
#         2.times do
#           topic = FactoryBot.build(:topic)
#           topic.user = meeting.organizer
#           topic.build_detail
#           if topic.save
#             ContentAssociation.create :parent => meeting, :child => topic
#           else
#             puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
#             puts meeting.organizer
#             puts topic.errors.full_messages
#             puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
#           end
#
#           if ([true, false].sample)
#             subtopic = FactoryBot.create(:subtopic, user: meeting.organizer)
#             ContentAssociation.create :parent => topic, :child => subtopic
#           end
#           parent = [topic, subtopic].compact.sample
#
#           2.times do
#             note = FactoryBot.create(:note, user: meeting.organizer)
#             ContentAssociation.create :parent => parent, :child => note
#           end
#
#           2.times do
#             decision = FactoryBot.create(:decision, user: meeting.organizer)
#             ContentAssociation.create :parent => parent, :child => decision
#           end
#
#           2.times do
#             task = FactoryBot.build(:task, user: meeting.organizer)
#             task.build_task_detail
#             task.save
#             ContentAssociation.create :parent => parent, :child => task
#           end
#         end
#
#       end
#     end
#
#   end
#
#   factory :topic do
#     sequence(:title) { |n| "Topic Title #{n}" }
#   end
#
#   factory :subtopic do
#     sequence(:title) { |n| "Subtopic Title #{n}" }
#   end
#
#   factory :note do
#     sequence(:title) { |n| "Note Title #{n}" }
#   end
#
#   factory :decision do
#     sequence(:title) { |n| "Decision Title #{n}" }
#   end
#
#   factory :task do
#     sequence(:title) { |n| "Task Title #{n}" }
#   end
#
#   factory :meeting_subscription do
#     subscription_type MeetingSubscription::SUB_ORGANIZER
#   end
#
# end