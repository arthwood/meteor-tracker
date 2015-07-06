require_relative '../model/user'

MeteorTracker::User.create(
  login: 'admin',
  role: 'admin',
  password: 'andantespianato'
)
