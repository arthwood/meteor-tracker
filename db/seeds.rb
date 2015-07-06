require_relative '../model/shower'
require_relative '../model/user'

MeteorTracker::User.create(
  login: 'admin',
  role: 'admin',
  password: 'andantespianato'
)

MeteorTracker::Shower.create(
  [
    {name: 'Eta Aquariids'},
    {name: 'Lyrids'},
    {name: 'Perseids'},
    {name: 'Quadrantids'},
  ]
)
