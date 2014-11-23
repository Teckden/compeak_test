FactoryGirl.define do
  factory :submitter do
    name 'John Doe'
    sequence(:email) { |n| "user#{n}@example.com" }
  end

  factory :submitter_with_message, parent: :submitter do
    after(:create) do |submitter|
      create_list(:message, 1, submitter: submitter)
    end
  end
end
