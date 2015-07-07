require_relative '../../model/user'

FactoryGirl.define do
  factory :user, class: MeteorTracker::User do
    login 'user1'
    password 'asdf1234'
    role 'user'
  end
  
  factory :admin, class: MeteorTracker::User do
    login 'admin111'
    password 'asdf1234'
    role 'admin'
  end
end
