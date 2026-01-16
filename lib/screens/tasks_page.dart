import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  Box? _box;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: const Row(
          children: [
            Icon(Icons.event_note, size: 22),
            SizedBox(width: 8),
            Text(
              "Daily Planner",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: _tasksWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey.shade900,
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _tasksWidget() {
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _taskList();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _taskList() {
    final tasks = _box!.values.toList();

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          "Your task list is empty.\nAdd a task to get started.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = Task.fromMap(tasks[index]);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            leading: Checkbox(
              value: task.done,
              onChanged: (value) {
                task.done = value!;
                _box!.putAt(index, task.toMap());
                setState(() {});
              },
            ),
            title: Text(
              task.todo,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                decoration:
                    task.done ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              task.timeStamp.toLocal().toString(),
              style: const TextStyle(fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                _box!.deleteAt(index);
                setState(() {});
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddTaskDialog() {
    String text = "";

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("New Task"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "What do you need to do?",
            ),
            onChanged: (value) => text = value,
            onSubmitted: (_) => _addTask(text),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => _addTask(text),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _addTask(String text) {
    if (text.trim().isEmpty) return;

    final task = Task(
      todo: text,
      timeStamp: DateTime.now(),
      done: false,
    );

    _box!.add(task.toMap());
    Navigator.pop(context);
    setState(() {});
  }
}
