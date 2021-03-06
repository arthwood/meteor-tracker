require_relative '../../model/user'

FactoryGirl.define do
  factory :user, class: MeteorTracker::Model::User do
    login 'user'
    password 'userpass'
    role 'user'
  end
  
  factory :admin, class: MeteorTracker::Model::User do
    login 'admin'
    password 'adminpass'
    role 'admin'
  end
end
