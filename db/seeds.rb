# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

shortens = Shorten.create([
                {url: 'example1.com', shortcode: 'example1'},
                {url: 'example2.com', shortcode: 'example2', redirectCount: 123, lastSeenDate: Time.zone.now},
                {url: 'example3.com'},
            ])
