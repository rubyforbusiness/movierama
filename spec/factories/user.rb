FactoryBot.define do
  factory :user do
    name { 'Joe Blogs' }
    uid { 'github|12345' }

    trait :user1 do
      name { 'A first user' }
      uid { 'github|23456' }
    end

    trait :user2 do
      name { 'A second user' }
      uid { 'github|34567' }
    end
  end
end