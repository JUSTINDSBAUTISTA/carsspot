# Destroy all records in the correct order to prevent foreign key violations
Notification.destroy_all
Rental.destroy_all
Message.destroy_all
Favorite.destroy_all
Car.destroy_all
User.destroy_all

# Create users
user1 = User.create!(email: 'user1@example.com', password: 'password', name: 'User One')
user2 = User.create!(email: 'user2@example.com', password: 'password', name: 'User Two')
user3 = User.create!(email: 'user3@example.com', password: 'password', name: 'User Three')
user4 = User.create!(email: 'user4@example.com', password: 'password', name: 'User Four')

# Create an admin user
User.create!(email: 'admin@example.com', password: 'password', name: 'Admin User', admin: true)

# Create cars
cars = Car.create!([
  { user: user1, car_name: 'Honda Civic', car_make: 'Honda', price_per_day: 50, status: 'approved', image: 'https://www.usnews.com/object/image/00000186-0f0d-da67-a5ef-2f5f87990000/2023-lucid-air-1.jpg?update-time=1675289789997&size=responsive970' },
  { user: user1, car_name: 'Toyota Camry', car_make: 'Toyota', price_per_day: 60, status: 'approved', image: 'https://www.usnews.com/object/image/00000186-0f0d-da67-a5ef-2f5f87990000/2023-lucid-air-1.jpg?update-time=1675289789997&size=responsive970' },
  { user: user2, car_name: 'Ford Mustang', car_make: 'Ford', price_per_day: 70, status: 'approved', image: 'https://www.usnews.com/object/image/00000186-0f0d-da67-a5ef-2f5f87990000/2023-lucid-air-1.jpg?update-time=1675289789997&size=responsive970' },
  { user: user2, car_name: 'Chevrolet Malibu', car_make: 'Chevrolet', price_per_day: 65, status: 'approved', image: 'https://www.usnews.com/object/image/00000186-0f0d-da67-a5ef-2f5f87990000/2023-lucid-air-1.jpg?update-time=1675289789997&size=responsive970' },
  { user: user3, car_name: 'BMW 3 Series', car_make: 'BMW', price_per_day: 80, status: 'approved', image: 'https://www.usnews.com/object/image/00000186-0f0d-da67-a5ef-2f5f87990000/2023-lucid-air-1.jpg?update-time=1675289789997&size=responsive970' },
  { user: user3, car_name: 'Audi A4', car_make: 'Audi', price_per_day: 90, status: 'approved', image: 'https://www.usnews.com/object/image/00000186-0f0d-da67-a5ef-2f5f87990000/2023-lucid-air-1.jpg?update-time=1675289789997&size=responsive970' },
  { user: user4, car_name: 'Mercedes-Benz C-Class', car_make: 'Mercedes-Benz', price_per_day: 100, status: 'approved', image: 'https://www.usnews.com/object/image/00000186-0f0d-da67-a5ef-2f5f87990000/2023-lucid-air-1.jpg?update-time=1675289789997&size=responsive970' },
  { user: user4, car_name: 'Tesla Model 3', car_make: 'Tesla', price_per_day: 110, status: 'approved', image: 'https://www.usnews.com/object/image/00000186-0f0d-da67-a5ef-2f5f87990000/2023-lucid-air-1.jpg?update-time=1675289789997&size=responsive970' }
])

# Create rentals
Rental.create!([
  { user: user2, car: cars.first, start_date: '2024-07-01', end_date: '2024-07-10', driving_license: 'DL12345', id_proof: 'ID12345', status: 'pending' },
  { user: user3, car: cars.second, start_date: '2024-07-05', end_date: '2024-07-12', driving_license: 'DL23456', id_proof: 'ID23456', status: 'pending' },
  { user: user4, car: cars.third, start_date: '2024-07-15', end_date: '2024-07-20', driving_license: 'DL34567', id_proof: 'ID34567', status: 'pending' },
  { user: user1, car: cars.fourth, start_date: '2024-07-18', end_date: '2024-07-25', driving_license: 'DL45678', id_proof: 'ID45678', status: 'pending' }
])

# Create messages
Message.create!([
  { sender: user1, recipient: user2, body: "Hey, I'm interested in your car." },
  { sender: user2, recipient: user1, body: "Sure, when do you want to rent it?" },
  { sender: user3, recipient: user4, body: "Is the Tesla Model 3 available?" },
  { sender: user4, recipient: user3, body: "Yes, it's available." }
])

puts "Seeding completed!"
