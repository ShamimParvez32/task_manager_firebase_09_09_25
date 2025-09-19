import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/data/local/db_helper.dart';
import 'package:task_manager_firebase_09_09_25/data/local/taskModel1.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SQLite Task Manager",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  String searchQuery = "";
  String filterStatus = "All"; // All, Pending, Done

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await DBHelper.getTasks();
    setState(() {
      tasks = data.map((e) => Task.fromMap(e)).toList();
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredTasks = tasks.where((task) {
        final matchesSearch = task.title!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            task.description!.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesStatus = (filterStatus == "All") || (task.status == filterStatus.toLowerCase());
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  Future<void> _addTask(String title, String description) async {
    await DBHelper.insertTask({
      "title": title,
      "description": description,
      "status": "pending",
      "createdDate": DateTime.now().toString(),
    });
    _loadTasks();
  }

  Future<void> _updateTask(int id, String title, String description, String status) async {
    await DBHelper.updateTask({
      "id": id,
      "title": title,
      "description": description,
      "status": status,
      "createdDate": DateTime.now().toString(),
    });
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    await DBHelper.deleteTask(id);
    _loadTasks();
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () {
              _addTask(titleController.text, descriptionController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    String status = task.status ?? "pending";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            DropdownButton<String>(
              value: status,
              items: const [
                DropdownMenuItem(value: "pending", child: Text("Pending")),
                DropdownMenuItem(value: "done", child: Text("Done")),
              ],
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Update"),
            onPressed: () {
              if (task.id != null) {
                _updateTask(task.id!, titleController.text, descriptionController.text, status);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Search Box
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search tasks...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchQuery = value;
                _applyFilters();
              },
            ),
          ),
          const SizedBox(width: 10),
          // Filter Dropdown
          DropdownButton<String>(
            value: filterStatus,
            items: const [
              DropdownMenuItem(value: "All", child: Text("All")),
              DropdownMenuItem(value: "Pending", child: Text("Pending")),
              DropdownMenuItem(value: "Done", child: Text("Done")),
            ],
            onChanged: (value) {
              filterStatus = value!;
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Manager")),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(child: Text("No tasks found"))
                : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Card(
                  child: ListTile(
                    title: Text(task.title ?? ""),
                    subtitle: Text("${task.description ?? ""}\nStatus: ${task.status}"),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditTaskDialog(task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            if (task.id != null) {
                              _deleteTask(task.id!);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
