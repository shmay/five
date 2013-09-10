# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

games = []
game_names = ['Settlers of Catan','Dungeons and Dragons', 'Carcassonne']

game_names.each do |n|
  g = Game.create name: n, user_id: 1
  games << g
end

group_names = ['SLO Group', 'Apple']
zips = [93401,95014]
groups = []

2.times do |n|
  g = Group.create! name: group_names[n]

  location = Location.new zip: zips[n].to_s
  location.group = g
  location.save

  Grouping.create! user_id: 1, group_id: g.id, admin:true

  rand(3).times do |t|
    t -= 1
    if t >= 0
      g.games << games[t]
    end
  end

  groups << g
end

zips = [93401,93401,93405,93406,95014,95015]
names = ['Kyle Murph', 'jayD', 'lew rockwell', 'some guy', 'steve woz', 'steve jerbs']
infos = ['kyle murph', 'blogger', 'lew writer', 'broski', 'iWoz', 'apple ceo, bro']
emails = ['kmurph73@gmail.com', 'jayD@dibbs.dev', 'lew@robbs.dev', 'someguy@dibbs.dev', 'iWoz@woz.dev', 'stevejerbs@jebs.dev']

6.times do |n|
  user = User.create! email: emails[n], password:'pass1212', password_confirmation:'pass1212', name:names[n], info:infos[n]

  location = Location.new zip:zips[n].to_s
  location.user = user
  location.save

  #user.confirm!

  rand(2).times do |t|
    user.games << games[t]
  end
end

start_times = [DateTime.new(2014, 2, 2, 16, 30), DateTime.new(2014, 3, 3, 16, 30)]
finish_times = [DateTime.new(2014, 2, 2, 19, 30), DateTime.new(2014, 3, 3, 19, 30)]
abouts = ['yarrrrrrrrrrrrr', 'some crazy event']
titles = ['eventy1', 'eventy2']
zips = [93401,90210]

2.times do |n|
  event = Event.create! start_time: start_times[n], finish_time: finish_times[n], title: titles[n], about: abouts[n]

  location = Location.new zip:zips[n].to_s
  location.event = event
  location.save

  rand(2).times do |t|
    event.games << games[t]
    event.groups << groups[t]
  end
end
