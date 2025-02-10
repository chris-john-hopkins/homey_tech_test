FactoryBot.define do
  factory :project do
    association :creator, factory: :user
    title { "Sample Project" }
    deadline { 1.week.from_now }
    description { "This is a sample project description" }
  end
end
