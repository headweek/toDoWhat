# Todo List App in Swift

This is a Swift-based Todo List application that allows users to manage their tasks effectively. The app fetches Todo items using a public API and stores them in CoreData. It allows users to add, edit, delete, and view tasks, while also keeping track of their creation and modification dates.

## Features
- Fetches Todo items from an external API.
- Stores created Todo items in CoreData for offline access.
- Add, edit, and delete tasks.
- View creation and modification dates for each task.
- Syncs data with the API and CoreData on app launch.

## Installation

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/yourusername/todo-list-app.git
   ```

2. Open the project in Xcode:
   ```bash
   open TodoListApp.xcodeproj
   ```

3. Build and run the app on your simulator or device.

## Usage

- **Add Todo**: Click on the "Add" button to create a new Todo. The new task will be stored locally and sent to the API.
- **Edit Todo**: Tap on any task to modify its title or description.
- **Delete Todo**: Swipe to delete a task. It will be removed from both CoreData and the API.
- **Syncing**: On app launch, Todo items are fetched from CoreData and synced with the API.

## Dependencies
- **CoreData** for local storage.
- **URLSession** to interact with the Todo API.
