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


## Notes / things you might extend

- Tasks currently have no "completed" checkbox — easy to add as a boolean
  field plus a `Checkbox` in `TaskTile` if you want it.
- The date a task is filed under is set once, at creation; editing only
  changes title/description per the original spec. Add a date field to the
  edit form too if you'd like that editable.
- `intl` is used purely for date formatting/grouping.
"# my_task_manager" 
