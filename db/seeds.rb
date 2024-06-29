require 'faker'

Notification.destroy_all
Rental.destroy_all
Message.destroy_all
Favorite.destroy_all
Car.destroy_all
User.destroy_all

# Create users
users = []
4.times do |i|
  users << User.create!(
    email: "user#{i + 1}@example.com",
    password: 'password',
    name: Faker::Name.name,
    birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
    phone_number: Faker::PhoneNumber.cell_phone,
    address: Faker::Address.street_address,
    zip_code: Faker::Address.zip_code,
    town: Faker::Address.city,
    country: Faker::Address.country,
    about_me: Faker::Lorem.paragraph
  )
end

# Create an admin user
admin_user = User.create!(
  email: 'admin@example.com',
  password: 'password',
  name: 'Admin User',
  admin: true,
  birthday: Faker::Date.birthday(min_age: 30, max_age: 65),
  phone_number: Faker::PhoneNumber.cell_phone,
  address: Faker::Address.street_address,
  zip_code: Faker::Address.zip_code,
  town: Faker::Address.city,
  country: Faker::Address.country,
  about_me: Faker::Lorem.paragraph
)

# Car images from Pexels
car_images = [
  'https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/305070/pexels-photo-305070.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/116675/pexels-photo-116675.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/707046/pexels-photo-707046.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/164634/pexels-photo-164634.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/909907/pexels-photo-909907.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/70912/pexels-photo-70912.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'
]

# Create 30 cars and assign them to users
30.times do
  address = Faker::Address.full_address
  latitude = Faker::Address.latitude
  longitude = Faker::Address.longitude
  car = Car.new(
    user: users.sample,
    car_name: Faker::Vehicle.model,
    car_make: Faker::Vehicle.make,
    price_per_day: Faker::Commerce.price(range: 50..150),
    status: ['approved', 'pending'].sample, # Randomly assign approved or pending status
    image: car_images.sample,
    features: Faker::Vehicle.standard_specs.join(', '),
    transmission: Faker::Vehicle.transmission,
    fuel_type: Faker::Vehicle.fuel_type,
    number_of_seat: Faker::Number.between(from: 2, to: 8),
    rating: Faker::Number.between(from: 1, to: 5),
    address: address,
    latitude: latitude,
    longitude: longitude
  )
  car.save!
end

# Create rentals
Rental.create!([
  { user: users[1], car: Car.first, start_date: '2024-07-01', end_date: '2024-07-10', driving_license: Faker::DrivingLicence.british_driving_licence, id_proof: Faker::IDNumber.valid, status: 'pending', location: Faker::Address.city },
  { user: users[2], car: Car.second, start_date: '2024-07-05', end_date: '2024-07-12', driving_license: Faker::DrivingLicence.british_driving_licence, id_proof: Faker::IDNumber.valid, status: 'pending', location: Faker::Address.city },
  { user: users[3], car: Car.third, start_date: '2024-07-15', end_date: '2024-07-20', driving_license: Faker::DrivingLicence.british_driving_licence, id_proof: Faker::IDNumber.valid, status: 'pending', location: Faker::Address.city },
  { user: users[0], car: Car.fourth, start_date: '2024-07-18', end_date: '2024-07-25', driving_license: Faker::DrivingLicence.british_driving_licence, id_proof: Faker::IDNumber.valid, status: 'pending', location: Faker::Address.city }
])

# Create messages
Message.create!([
  { sender: users[0], recipient: users[1], body: "Hey, I'm interested in your car.", read: false },
  { sender: users[1], recipient: users[0], body: "Sure, when do you want to rent it?", read: false },
  { sender: users[2], recipient: users[3], body: "Is the Tesla Model 3 available?", read: false },
  { sender: users[3], recipient: users[2], body: "Yes, it's available.", read: false }
])

# Create favorites
users.each do |user|
  Favorite.create!(
    user: user,
    car: Car.all.sample,
    shared_with: Faker::Internet.email
  )
end

# Create reviews
users.each do |user|
  Review.create!(
    user: user,
    car: Car.all.sample,
    rating: Faker::Number.between(from: 1, to: 5),
    comment: Faker::Lorem.sentence
  )
end

# Create notifications
users.each do |user|
  Notification.create!(
    recipient: user,
    actor: admin_user,
    notifiable: Car.where(status: 'pending').sample,
    notifiable_type: 'Car',
    message: "Your car is pending approval",
    read: [true, false].sample
  )
end

# Create rental notifications for car owners
Rental.where(status: 'pending').each do |rental|
  Notification.create!(
    recipient: rental.car.user,
    actor: rental.user,
    notifiable: rental,
    notifiable_type: 'Rental',
    message: "You have a new rental request",
    read: false
  )
end

puts "Seeding completed!"
