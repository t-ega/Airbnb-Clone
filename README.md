# Airbnb Clone

This project is an Airbnb clone built with Ruby on Rails, using a monolithic architecture for the web views and GraphQL for the API endpoints.

## Features

- User authentication: Sign up, log in, and log out functionality.
- Property listings: Users can create, view, update, and delete property listings.
- Search functionality: Users can search for properties based on location, dates, and other criteria.
- Booking system: Users can make bookings for available properties.
- Reviews and ratings: Users can leave reviews and ratings for properties they have booked.

## Technologies Used

- Ruby on Rails: A web application framework written in Ruby.
- GraphQL: A query language for APIs that provides a more efficient and flexible way to request data.
- PostgreSQL: A relational database management system for storing application data.
- Active Storage: A built-in library for managing file uploads in Rails.
- Front-end technologies: HTML, Tailwind CSS, and Hotwire for building the user interface.
- Robocop: For linting and code formatting.

Please visit the ROADMAP.md section to see the proposed plan for this project.

## Installation

1. Clone the repository:

   ```shell
   git clone https://github.com/t-ega/Airbnb-Clone.git
   ```

2. Install dependencies using Bundler:

   ```shell
   bundle install
   ```

3. Set up the database by running the migrations:

   ```shell
   rails db:migrate db:seed
   ```

4. Start the Rails server:

   ```shell
   bin/dev
   ```

5. Open your web browser and access the application at `http://localhost:3000`.

## Configuration

- Database configuration: Update the `config/database.yml` file with your PostgreSQL database credentials.
- Environment variables:

## Usage

- Visit the homepage and sign up for a new account.
- Explore the available properties, search for listings, and view property details.
- Create your own property listings, update existing listings, and delete your own listings.
- Make bookings for available properties and leave reviews and ratings after your stay.

## Contributing

Contributions to this project are welcome. Feel free to open issues or submit pull requests for bug fixes, feature enhancements, or other improvements.

## Acknowledgements

- [Elbie Moonga](https://github.com/Elbie-em): Mentorship and guidance
- [Abiodun Onisade](): Mentorship and guidance
- [Airbnb](https://www.airbnb.com): Inspiration for the project idea and design.
- [Rails Guides](https://guides.rubyonrails.org): Official documentation for Ruby on Rails.
