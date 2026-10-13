# Hindustan Standards Bureau

## Firebase setup

The app uses Cloud Firestore for the announcements CRUD flow. Firebase
configuration is intentionally not included until a Firebase project is
selected.

From the project root, install the FlutterFire CLI and generate the
project-specific configuration:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Select the Firebase project and the web platform. This creates
`lib/firebase_options.dart`. Do not replace that generated file with
hand-written credentials.

Enable Cloud Firestore and Email/Password Authentication in the Firebase
console before using the app. The app initializes Firebase before startup
when configuration is available. The announcements page uses the
`announcements` collection with real-time reads and supports create, update,
and delete operations.

Deploy the included rules after reviewing them:

```bash
firebase deploy --only firestore:rules
```

The rules require authenticated users to read announcements and require an
admin role for create, update, and delete operations. An admin can be
authorized either with a custom `admin` claim or with a manually managed
`users/{uid}` document containing `{ "role": "admin" }`. Never let the client
write its own role. The rules use safe map lookups so users without an admin
claim are denied rather than causing a rules-evaluation error.

The Render deployment must use the same Firebase project (`has1-a9ff2`) as
`lib/firebase_options.dart`. If Firestore displays `permission-denied`,
deploy the rules from this project root:

```powershell
firebase use has1-a9ff2
firebase deploy --only firestore:rules
```

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
