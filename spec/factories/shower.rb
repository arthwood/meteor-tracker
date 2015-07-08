require_relative '../../model/shower'

FactoryGirl.define do
  factory :shower, class: MeteorTracker::Model::Shower do
    name 'orionids'
  end
end
