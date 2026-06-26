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
- Delete a task 
