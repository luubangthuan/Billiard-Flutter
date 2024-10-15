# Billiard Entertainment Business Recommendation Mobile App

This mobile application assists users in finding billiard venues based on their preferences and allows businesses to manage their venues and interact with customers. Built using **Dart** with **Flutter** for the frontend, **Node.js** with **Express** for the backend, and **MongoDB** (MongoDB Atlas) as the database system.

## Table of Contents
- [Introduction](#introduction)
- [Motivation](#motivation)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Target Users](#target-users)
- [Development Process](#development-process)
- [Database Structure](#database-structure)
- [Setup Instructions](#setup-instructions)
- [Contributing](#contributing)
- [License](#license)

## Introduction

The "Billiard Entertainment Business Recommendation Mobile App" is an innovative platform for users to find billiard venues that meet their specific preferences such as location, cost, facilities, and user ratings. The app facilitates both customers and business owners in improving the billiard experience by integrating booking, promotions, and customer interaction functionalities.

## Motivation

This app was developed to address the needs of modern billiard enthusiasts and business owners. It provides users with a seamless experience for discovering and interacting with billiard venues. As a computer science student with a passion for billiards, I recognized the gap between billiard businesses and new customers, and this app aims to bridge that gap.

### Why Choose This Topic?

1. **Understanding User Needs**: The app caters to urban youths and billiard business owners, providing personalized recommendations and engagement opportunities.
2. **Bridging a Gap**: It addresses the difficulties faced by new customers trying to find suitable billiard venues while giving businesses a platform to reach new customers.
3. **Real-world Application**: The app solves practical issues for both users and businesses by making the venue discovery and interaction process seamless.

## Features

### For Customers:
- **Venue Recommendations**: Personalized venue suggestions based on location, cost, ratings, and facilities.
- **Search Filters**: Advanced search options to find venues based on specific criteria such as price, rating, or amenities.
- **User Accounts**: Customers can create accounts to book tables, order refreshments, or interact with businesses.
- **History & Reviews**: Track visit history and post reviews with photos after each booking.
- **Educational Content**: Provide tutorials and billiard techniques through videos for beginners.

### For Business Owners:
- **Promotion Tools**: Promote billiard venues and attract new customers.
- **Customer Interaction**: Manage bookings and customer requests.
- **Venue Management**: Update venue details, services, operating hours, and view customer feedback.

## Technologies Used

- **Frontend**: Dart & Flutter
  - The mobile app is built using Flutter for cross-platform development on iOS and Android.
  - User-friendly UI/UX design with features for searching, booking, and interacting with venues.
  
- **Backend**: Node.js & Express
  - Node.js powers the backend API and data handling.
  - Express framework structures the API routes and middleware, handling user requests and authentication.

- **Database**: MongoDB (MongoDB Atlas)
  - MongoDB stores venue information, user profiles, reviews, and booking data.
  - MongoDB Atlas, a cloud-hosted database, ensures scalability and performance.

## Target Users

The app targets two primary user groups:
1. **Customers**: People, primarily young adults, looking for billiard venues that meet their preferences.
2. **Business Owners**: Billiard venue owners who want to promote their business, attract new customers, and manage their venue operations online.

## Development Process

1. **Requirement Gathering**: Collect essential requirements via surveys and research to understand user and business needs.
2. **Functional Analysis**: Analyze key functionalities and create user flow diagrams.
3. **Database Design**: Design a flexible database structure based on user interactions and business models.
4. **UI Design**: Build a responsive and compatible UI across mobile platforms.
5. **Backend Development**: Implement the backend logic with Node.js and Express, integrating with MongoDB for data persistence.
6. **Testing & Iteration**: Conduct testing as both a developer and user, then package and deploy the app to the cloud or a hosting service.
7. **User Feedback & Final Launch**: Deploy a beta version, gather feedback from users, and release the final version.

## Database Structure

- **User Collection**: Stores user profiles, including their preferences, booking history, and reviews.
- **Venue Collection**: Stores information about billiard venues such as name, location, pricing, facilities, and user ratings.
- **Booking Collection**: Tracks user bookings, allowing customers to reserve tables and interact with venues.
- **Review Collection**: Stores customer reviews and photos, linking users with venues.

## Setup Instructions

### Prerequisites

- Install **Node.js** and **npm** for backend development.
- Install **Flutter SDK** for mobile development.
- Set up a **MongoDB Atlas** cluster and configure your connection URI.

### Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/your-repo/billiard-app.git
    cd billiard-app
    ```

2. **Install dependencies for the backend**:
    ```bash
    cd billiard-booking-app-backend
    npm install
    ```

3. **Set up the environment**:
    - Create a `.env` file for the backend and add the MongoDB Atlas connection string:
    ```plaintext
    MONGO_URI=your-mongodb-atlas-uri
    ```

4. **Install dependencies for the mobile app**:
    ```bash
    cd billiard_management_mobile_app
    flutter pub get
    ```

5. **Run the backend server**:
    ```bash
    npm start
    ```

6. **Run the Flutter app**:
    ```bash
    flutter run
    ```

## Contributing

Contributions are welcome! If you'd like to contribute to this project, please follow these steps:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add a feature'`).
4. Push the branch (`git push origin feature-branch`).
5. Create a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
