# README

This is the proposed roadmap for this app. I'll add more as times goes

- Implement endpoints using graphql
- Enable CORS for production mode
- Users
    - Authentication
        - Add support for auth using JWT tokens
        - Enable email sending features using a worker e.g RabbitMQ

### TODO
- [X] Create a Rake task to automatically delete blacklisted JWT Auth tokens after they have expired.
- [X] Create a Rake task to delete all tokens after they have expired
- [] Create a cron job to run the rake task
- [X] Send a confirmation token after sign up.
- [X] Send a reset token after requesting for one.
- [X] Create a confirmation endpoint to validate confirmation tokens.
- [] Use Pundit for Authorization

## User stories

This is a simplified version of Airbnb. Only worry about user stories described here.
Payments and the rest to come up later...

### As a host, I should be able to...

- Add a listing
- Title
- Private room or entire home
- Photos (taken by host)
- Description
- Number of bedrooms
- Number of bathrooms
- Number of beds
- Max occupants
- City
- Neighborhood
- Policies (check-in time, house rules, etc)
- Default price per night
- Specify which nights the unit is available
- Price (if different from default)
- Respond to messages from guests
- Review and accept requests
- See past reviews of the requester (both as guests and of listings where they were host)
- See a message history between myself and the requester
- Leave a review of a guest
- Overall rating (1-5)
- Which booking this review is for (we'll keep this private, though)
- Body (freeform text)

### As a guest, I should be able to...

- Browse listings
- See past reviews of the listing, and other listings by the same hosts, and of the host when they were a guest
- Bookmark listings
    - Send a message to the owner of a listing
- See the nights a listing is available for
- Send a request for available nights
- Include an introduction of myself
- Not send a request for unavailable nights
- Leave a review of a booking
- Accuracy (1-5)
- Communication (1-5)
- Cleanliness (1-5)
- Location (1-5)
- Check In (1-5)
- Value (1-5)
- Body (freeform text)