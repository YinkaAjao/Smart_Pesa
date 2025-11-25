# Smart_PesaSmart-Pesa

Smart-Pesa is a financial planning app designed for freelancers and gig workers with irregular income. It uses obligation-first planning to automatically allocate income toward bills, taxes, and savings before showing what is "Safe to Spend."

## Features

Safe-to-Spend Dashboard: Real-time calculation: $Income - (Expenses + Tax + Savings)$.

Expense Tracking: Add, view, and delete expenses with category tagging.

Statistics: Visual charts and category breakdowns of monthly spending.

Profile Management: Set vital financial data (Tax Rate, Monthly Income, Savings Goals).

Dark Mode: Persisted user preference using Shared Preferences.

Authentication: Secure Login and Sign-up via Firebase Auth.

## Tech Stack & Architecture

Framework: Flutter (Dart)

State Management: BLoC (Business Logic Component) & Cubit.

Architecture: Feature-First Clean Architecture.

Data Layer: Repositories and Data Sources (Firestore).

Domain Layer: Entities and Abstract Repositories.

Presentation Layer: UI Screens and BLoC logic.

Backend: Firebase Firestore & Firebase Authentication.

Local Storage: SharedPreferences (for Theme settings).

## Setup Instructions

Clone the repository:

git clone <your-repo-link>


Install Dependencies:

flutter pub get


Firebase Setup:

Ensure firebase_options.dart is present in lib/.

Enable Authentication (Email/Password) in Firebase Console.

Enable Firestore Database and set rules to allow read, write: if request.auth != null;.

Run the App:

flutter run


## Database Structure

The app uses a NoSQL Firestore structure rooted in the users collection to ensure data privacy.

/users/{uid}

tax_rate: (Number)

/transactions: Stores expense documents.

/income: Stores income source documents.

/savings: Stores savings goal documents.

## Testing

Unit tests for BLoC logic.

Widget tests for UI components.
(Run flutter test to execute)