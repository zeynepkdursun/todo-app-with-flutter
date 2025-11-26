import 'package:flutter/material.dart';

void main() {
  runApp(const DailyFlowApp());
  print('deneme for github');
}

class DailyFlowApp extends StatelessWidget {
  const DailyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

// Task modeli
class Task {
  String id;
  String title;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
  @override
  String toString() {
    return title;
  }
}

// Main Page
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  // CREATE - add a new Task
  void _addTask() {
    if (_taskController.text.isEmpty) return;

    setState(() {
      _tasks.add(Task(
        id: DateTime.now().toString(),
        title: _taskController.text,
      ));
      print('the task "${_taskController.text}" is created');

      _taskController.clear();
    });
  }

  // UPDATE - change the state of Task (completed or uncompleted)
  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      print('the task "${_tasks[index].title}" is marked as ${_tasks[index].isCompleted ? 'Completed' : 'Uncompleted'}');
    });
  }

  // UPDATE - update the text in Task line
  void _editTask(int index) {
    _taskController.text = _tasks[index].title;
    final prevTask = _taskController.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            hintText: 'Task Name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _taskController.clear();
            },
            child: const Text('Cancel'),
          ),
          //for the updated text note:
          TextButton(
            onPressed: () {
              if (_taskController.text.isNotEmpty) {
                setState(() {
                  _tasks[index].title = _taskController.text;
                });
                print(
                    'the task "${prevTask}" is updated as "${_tasks[index].title}"');
              }
              Navigator.pop(context);
              _taskController.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // DELETE - delete the Task
  void _deleteTask(int index) {
    final deletedTask = _tasks[index];
    setState(() {
      print('the task "${deletedTask}" is deleted');
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos - Daily Tasks'),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Adding Task section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new task...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add a task'),
                ),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No task to display.\nAdd your first task!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          // Checkbox - completed mark
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) => _toggleTask(index),
                          ),

                          // task title
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color:
                                  task.isCompleted ? Colors.grey : Colors.black,
                            ),
                          ),

                          // Edit and delete buttons
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit button
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editTask(index),
                              ),

                              // Delete button
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTask(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Statistics Display
          if (_tasks.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Total: ${_tasks.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Completed: ${_tasks.where((t) => t.isCompleted).length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}
