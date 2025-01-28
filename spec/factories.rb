FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    password_digest { Faker::Internet.password }
    role { %w[buyer owner].sample }

    trait :buyer do
      role { 'buyer' }
    end

    trait :owner do
      role { 'owner' }
    end
  end

  factory :business do
    name { Faker::Company.name }
    total_shares { Faker::Number.between(from: 0, to: 1000) }
    available_shares { Faker::Number.between(from: 0, to: 1000) }
    owner { association(:user) }
  end

  factory :buy_order do
    quantity { Faker::Number.between(from: 1, to: 1000) }
    price { Faker::Number.between(from: 1, to: 1000) }
    status { 'pending' }
    user { association(:user) }
    business { association(:business) }

    trait :pending do
      status { 'pending' }
    end

    trait :approved do
      status { 'approved' }
    end

    trait :rejected do
      status { 'rejected' }
    end
  end

  factory :transaction do
    quantity { Faker::Number.between(from: 1, to: 100) }
    price { Faker::Number.between(from: 1, to: 100) }
    user { association(:user) }
    business { association(:business, available_shares: 100) }

    after(:build) do |transaction|
      transaction.quantity = [transaction.quantity, transaction.business.available_shares].min
    end
  end
end
