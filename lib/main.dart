import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ProxyProvider2<TaskProvider, CategoryProvider, List<Task>>(
          update: (context, taskProvider, categoryProvider, _) {
            return taskProvider.tasksByCategory(categoryProvider.selectedCategory);
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      home: TaskListScreen(),
    );
  }
}

class Task {
  String id;
  String title;
  bool isCompleted;
  String categoryId;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.categoryId,
  });
}

class Category {
  String id;
  String name;

  Category({required this.id, required this.name});
}

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void toggleTaskCompletion(String taskId) {
    final task = _tasks.firstWhere((task) => task.id == taskId);
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  List<Task> tasksByCategory(String? categoryId) {
    if (categoryId == null) return _tasks;
    return _tasks.where((task) => task.categoryId == categoryId).toList();
  }
}

class CategoryProvider extends ChangeNotifier {
  final List<Category> _categories = [
    Category(id: '1', name: 'Work'),
    Category(id: '2', name: 'Personal'),
  ];

  List<Category> get categories => _categories;

  String? selectedCategory;
  void selectCategory(String? categoryId) {
    selectedCategory = categoryId;
    notifyListeners();
  }

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void removeCategory(String categoryId) {
    _categories.removeWhere((category) => category.id == categoryId);
    notifyListeners();
  }
}

class TaskListScreen extends StatelessWidget {
  final TextEditingController taskController = TextEditingController();

  TaskListScreen({super.key});
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          DropdownButton<String>(
            hint: const Text("Select Category"),
            value: categoryProvider.selectedCategory,
            items: categoryProvider.categories.map((category) {
              return DropdownMenuItem(
                value: category.id,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (categoryId) {
              categoryProvider.selectCategory(categoryId);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: taskController,
              decoration: const InputDecoration(labelText: 'Enter Task'),
            ),
            DropdownButton<String>(
              hint: const Text("Select Category"),
              value: selectedCategory,
              items: categoryProvider.categories.map((category) {
                return DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (categoryId) {
                selectedCategory = categoryId;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (taskController.text.isNotEmpty && selectedCategory != null) {
                  final newTask = Task(
                    id: DateTime.now().toString(),
                    title: taskController.text,
                    categoryId: selectedCategory!,
                  );
                  taskProvider.addTask(newTask);
                  taskController.clear();
                  selectedCategory = null;
                } else {
                  debugPrint("Task title cannot be empty");
                }
              },
              child: const Text('Add Task'),
            ),
            Expanded(
              child: Consumer<List<Task>>(
                builder: (context, tasks, child) {
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(taskId: tasks[index].id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String taskId;

  const TaskItem({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Selector<TaskProvider, Task>(
      selector: (_, provider) => provider.tasks.firstWhere((task) => task.id == taskId),
      builder: (context, task, child) {
        return ListTile(
          title: Text(task.title),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              Provider.of<TaskProvider>(context, listen: false).toggleTaskCompletion(taskId);
            },
          ),
        );
      },
    );
  }
}
