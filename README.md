



# Task Manager App

A simple task management app built using Flutter and Provider for state management. This app allows users to create tasks, categorize them, and manage their completion status. The app uses advanced Provider techniques like `MultiProvider`, `ProxyProvider`, and `Selector` to optimize state handling.

## Features

- Add new tasks and categorize them (Work, Personal, etc.)
- View tasks filtered by selected category
- Mark tasks as completed or pending
- Manage categories (add or remove categories)

## Getting Started

Follow these instructions to run the app on your local machine.

### Prerequisites

Ensure you have the following installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- A code editor like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation

1. Clone the repository:
   ``
   git clone https://github.com/your-repo/task-manager-app.git`` 

2.  Navigate into the project directory:
    
    `cd task-manager-app` 
    
3.  Install dependencies:
    
    `flutter pub get` 
    
4.  Run the app:
    
    
    `flutter run` 
    

## Project Structure

-   **main.dart**: Entry point of the app. Sets up the `MultiProvider` for managing the task and category state.
-   **TaskProvider**: A `ChangeNotifier` that manages the list of tasks. Provides methods for adding, removing, and toggling task completion.
-   **CategoryProvider**: A `ChangeNotifier` that manages task categories. Allows adding and selecting categories.
-   **TaskListScreen**: The main screen where tasks are listed and new tasks can be added.
-   **TaskItem**: A reusable widget that displays an individual task, including the option to mark it as completed.

## How It Works

### State Management

This app uses the Provider package to manage the state of tasks and categories. It uses:

-   `ChangeNotifierProvider` for both `TaskProvider` and `CategoryProvider`.
-   `ProxyProvider` to filter tasks by the currently selected category.
-   `Selector` to efficiently update individual task items.

### Adding a Task

1.  Enter a task in the input field.
2.  Select a category from the dropdown.
3.  Press "Add Task" to add it to the list.

### Task Filtering

The app filters tasks by the selected category using a `ProxyProvider2`, which listens to both `TaskProvider` and `CategoryProvider` and updates the list of tasks accordingly.

### Task Completion

You can mark a task as completed using a checkbox next to each task. The state is managed by the `TaskProvider` and updated in real-time.



## Contributing

1.  Fork the repo
2.  Create a new branch (`git checkout -b feature/your-feature`)
3.  Commit your changes (`git commit -m 'Add your feature'`)
4.  Push the branch (`git push origin feature/your-feature`)
5.  Create a new Pull Request
