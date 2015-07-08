require_relative '../../model/event'

FactoryGirl.define do
  factory :event, class: MeteorTracker::Model::Event do
    user
    shower
    time Time.new(2015, 5, 2, 23, 8)
    ra Time.new(2000, 1, 1, 13, 43, 5)
    dec 23
    dir 'n'
    len 12
    mag -3
    vel 8
  end
end
