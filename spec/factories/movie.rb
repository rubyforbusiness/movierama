FactoryBot.define do
  factory :movie do
    title { 'Empire strikes back' }
    description { 'Who\'s scruffy-looking?' }
    date { '1980-05-21' }
    created_at { Time.parse('2014-10-01 10:30 UTC').to_i }
    user factory: :user
    liker_count { 1 }
    hater_count { 0 }
  end
end