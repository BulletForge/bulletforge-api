# frozen_string_literal: true

FactoryBot.define do
  factory :random_user, class: User do
    pwd = Faker::Internet.password

    login { Faker::Name.unique.first_name }
    email { Faker::Internet.unique.safe_email }
    password { pwd }
    password_confirmation { pwd }
  end
end
