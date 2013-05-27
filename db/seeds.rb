# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Trait.create([
  { name: 'simple' },
  { name: 'heavy' },
  { name: 'crunchy' },
  { name: 'creamy' },
  { name: 'tart' },
  { name: 'sour' },
  { name: 'sweet' },
  { name: 'savory' },
  { name: 'earthy' },
  { name: 'fluffy' },
  { name: 'herbacious' },
  { name: 'nutty' },
  { name: 'raw' },
  { name: 'buttery' },
  { name: 'flaky' },
  { name: 'briney' },
  { name: 'salty' },
  { name: 'oily' },
  { name: 'starchy' },
  { name: 'fatty' },
  { name: 'comfort food' },
  { name: 'spicy' },
  { name: 'zesty' },
  { name: 'rich' }
])

User.create([
  { name: 'User', email: 'user@example.com', password: 'password' }
])
