# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create email: "otavkaal@grinnell.edu", password: "examplepassword",
            name: "Zander Otavka", admin: true

Location.create name: "Grinnell College"
Location.create name: "Walmart"
Location.create name: "Des Moines"
Location.create name: "Chicago"
