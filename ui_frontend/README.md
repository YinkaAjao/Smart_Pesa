# ui_frontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Backend Integration

- Firebase Project: smartpesa-6bb50
- Auth Methods: Email/Password
- Firestore Collections:
  - users/{uid} → {name, email, currency, premium, createdAt}
  - users/{uid}/transactions/{txId} → {category, amount, date, note}
  - subscriptions/{uid} → {planType, startDate, endDate}
- Models:
  - UserModel, ExpenseModel, SubscriptionModel
- FirestoreService:
  - CRUD operations implemented for users, transactions, subscriptions
- Security Rules:
  - Only authenticated users can access their own data.
- Firebase initialization:
```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

