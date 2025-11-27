import 'package:flutter/material.dart';
import 'generated/app_localizations.dart'; // ← sadece bu satır yeter!
import 'l10n/l10n.dart';

//rule: any time you change data that the ui depends on,
//use setState((){.................})
//example: setState(() { _tasks.add(...); });      //adding
//example: setState(() {_tasks.removeAt(index); });  //deleting

void main() {
  runApp(const DailyFlowApp());
}

//the class widget returns another widget
class DailyFlowApp extends StatelessWidget {
  const DailyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ← THESE 3 LINES ARE THE ONLY ONES YOU NEED TO ADD/CHANGE
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      //locale: null, // null = automatically uses phone language
      locale: const Locale('en'),

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
  //every statefulWidget must override createState()
  // the underscore _ makes the state object private
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];
  //_taskController is a controller for a text field where users type new tasks
  //TestEditingController is a built-in Flutter class
  //It lets read/change the text in a TextField widget
  final TextEditingController _taskController = TextEditingController();

  // CREATE - a method to add a new Task
  void _addTask() {
    if (_taskController.text.isEmpty) return;
    //setState(() {......}) is the key to updating the UI in flutter
    setState(() {
      _tasks.add(Task(
        id: DateTime.now().toString(),
        title: _taskController.text,
      ));
      print('the task "${_taskController.text}" is created');
      //clears the text input field
      _taskController.clear();
    });
  }

  // UPDATE - change the state of Task (completed or uncompleted)
  void _toggleTask(int index) {
    //it rebuilds the ui (whole ui or the part of toggleTask section??)
    setState(() {
      //// Flip the boolean: true → false, false → true
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      //debug message in console
      print(
          'the task "${_tasks[index].title}" is marked as ${_tasks[index].isCompleted ? 'Completed' : 'Uncompleted'}');
    });
  }

  // UPDATE - update the text in Task line
  void _editTask(int index) {
    //
    _taskController.text = _tasks[index].title;
    final prevTask = _taskController.text;
    //opens a popup dialog (a small window on top of the screen)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.editTask),
        //TextField is where user types the new task
        content: TextField(
          controller: _taskController,
          decoration: InputDecoration(
            hintText: context.l10n.addNewTaskHint,
          ),
          autofocus: true, //keyboard opens automatically
        ),
        actions: [
          //CANCEL BUTTON
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _taskController.clear();
            },
            child: Text(context.l10n.cancel),
          ),
          //SAVE BUTTON for the updated text note:
          TextButton(
            onPressed: () {
              if (_taskController.text.isNotEmpty) {
                //used setState because the date is changed
                //flutter immediately calls build() again on the whole TaskListScreen:
                setState(() {
                  _tasks[index].title = _taskController.text;
                });
                print(
                    'the task "${prevTask}" is updated as "${_tasks[index].title}"');
              }
              //another way:
              // if (_taskController.text.isNotEmpty) {
              //   _tasks[index].title = _taskController.text;  // change data
              //   setState(() {});  // empty setState → just triggers rebuild
              // }

              Navigator.pop(context); //close the dialog
              _taskController.clear(); //clean the text field
            },
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
  }

  // DELETE - delete the Task
  void _deleteTask(int index) {
    final deletedTask = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
    });
    print('the task "${deletedTask}" is deleted');

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('"${deletedTask}" is deleted'),
    //     action: SnackBarAction(
    //       label: 'UNDO',
    //       onPressed: () {
    //         setState(() {
    //           _tasks.insert(index, deletedTask);
    //         });
    //       }
    //     ),
    //   ),

    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //the basic app layout: appBar and body
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        elevation: 2, //small show under the app bar
      ),
      body: Column(
        //everything is stacked vertically
        children: [
          //SECTION 1
          //Add new task area
          Padding(
            padding: const EdgeInsets.all(16.0), //space around the whole row:
            child: Row(
              //horizontal layout: text field + button
              children: [
                //TEXT FIELD
                //takes as much space as possible
                Expanded(
                  // Makes the TextField stretch to fill the row
                  child: TextField(
                    controller: _taskController, //connects to the text field
                    decoration: InputDecoration(
                      hintText: context.l10n.addNewTaskHint,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) =>
                        _addTask(), // When user presses Enter → add the task!
                  ),
                ),
                const SizedBox(width: 10), //small gap
                //THE ADD BUTTON
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Text(
                      context.l10n.noTasks,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    //LIST when there are tasks
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        //for each tasks
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          // 1. CHECKBOX ON THE LEFT
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) => _toggleTask(index),
                          ),

                          // 2. TASK TITLE
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

                          // EDIT + DELETE BUTTONS ON THE RIGHT
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit button
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Color.fromARGB(255, 93, 169, 231)),
                                onPressed: () => _editTask(index),
                              ),

                              // Delete button
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Color.fromARGB(255, 255, 100, 88)),
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
                    '${context.l10n.totalTasks}: ${_tasks.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${context.l10n.completedTasks}: ${_tasks.where((t) => t.isCompleted).length}',
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
