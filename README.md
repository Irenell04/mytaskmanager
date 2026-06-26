# My Task Manager

A simple Flutter app where users register, log in, and manage their own list
of tasks, backed by Firebase Authentication (email/password) and Cloud
Firestore.

## Features

- Register / log in / log out with email and password
- Validation blocks empty email or password fields
- Add a task (title, description, date)
- Tasks are scoped per user — you only ever see your own
- Two views, toggled from the app bar:
  - **Tasks by Date** — tasks grouped under date headings
  - **All Tasks** — one flat list of everything, sorted with the date shown
- Tap a task to edit its title/description
- Delete a task (with a confirmation dialog)

## Project structure

```
lib/
  main.dart                     # Firebase init + auth-state routing
  firebase_options.dart         # placeholder — replaced by flutterfire configure
  models/
    task.dart                   # Task model + Firestore (de)serialization
  services/
    auth_service.dart           # Firebase Authentication wrapper
    firestore_service.dart      # Firestore CRUD for tasks
  screens/
    login_screen.dart
    register_screen.dart
    home_screen.dart            # toggle + FAB + logout
    tasks_by_date_view.dart
    all_tasks_view.dart
    add_edit_task_screen.dart   # shared add/edit form
  widgets/
    task_tile.dart
```

## 1. Create the Flutter project shell

This package only contains `lib/` and `pubspec.yaml`. Generate the platform
folders (`android/`, `ios/`, etc.) first, then drop these files in:

```bash
flutter create my_task_manager
cd my_task_manager
# copy the lib/ folder and pubspec.yaml from this package into place,
# overwriting the generated ones
flutter pub get
```

## 2. Set up Firebase

1. Go to the [Firebase console](https://console.firebase.google.com) and
   create a new project.
2. **Authentication** → Sign-in method → enable **Email/Password**.
3. **Firestore Database** → create a database (start in production mode;
   rules are below).
4. Install the FlutterFire CLI if you don't have it:
   ```bash
   dart pub global activate flutterfire_cli
   ```
5. From the project root, run:
   ```bash
   flutterfire configure
   ```
   Pick your Firebase project and the platforms you want (Android/iOS/etc).
   This generates a real `lib/firebase_options.dart`, overwriting the
   placeholder, and adds any native config files Firebase needs
   (`google-services.json` for Android, `GoogleService-Info.plist` for iOS).

## 3. Firestore security rules

Each task document stores the owner's `userId`. Lock the `tasks` collection
down so a user can only read/write their own:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{taskId} {
      allow read, update, delete: if request.auth != null
                                   && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null
                     && request.auth.uid == request.resource.data.userId;
    }
  }
}
```

Paste these into Firestore → Rules in the console and publish.

## 4. Firestore index

The task list query filters by `userId` and orders by `date`, which needs a
composite index. Firestore will throw an error in the console/logs the first
time you run the app, with a direct link to create that index automatically
— just click it. (Alternatively create it manually ahead of time: Firestore
→ Indexes → Composite → collection `tasks`, fields `userId` Ascending,
`date` Descending.)

## 5. Run it

```bash
flutter run
```

## Notes / things you might extend

- Tasks currently have no "completed" checkbox — easy to add as a boolean
  field plus a `Checkbox` in `TaskTile` if you want it.
- The date a task is filed under is set once, at creation; editing only
  changes title/description per the original spec. Add a date field to the
  edit form too if you'd like that editable.
- `intl` is used purely for date formatting/grouping.
"# my_task_manager" 
