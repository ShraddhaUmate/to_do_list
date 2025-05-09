 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/size_config.dart';

 // Task model with priority and editing
 class Task {
   String title;
   bool isCompleted;
   int priority; // 1-high, 2-medium, 3-low

   Task({required this.title, this.isCompleted = false, this.priority = 2});

   Map<String, dynamic> toJson() => {
     'title': title,
     'isCompleted': isCompleted,
     'priority': priority,
   };

   factory Task.fromJson(Map<String, dynamic> json) => Task(
     title: json['title'],
     isCompleted: json['isCompleted'],
     priority: json['priority'],
   );
 }


 class HomePage extends StatefulWidget {
   const HomePage({super.key});

   @override
   State<HomePage> createState() => _HomePageState();
 }

 class _HomePageState extends State<HomePage> {
   final TextEditingController controller = TextEditingController();
   List<Task> tasks = [];
   int selectedPriority = 2;

   @override
   void initState() {
     super.initState();
     loadTasks();
   }

   Future<void> loadTasks() async {
     final prefs = await SharedPreferences.getInstance();
     final data = prefs.getString('tasks');
     if (data != null) {
       final decoded = jsonDecode(data);
       setState(() {
         tasks = List<Task>.from(decoded.map((e) => Task.fromJson(e)));
       });
     }
   }

   Future<void> saveTasks() async {
     final prefs = await SharedPreferences.getInstance();
     final encoded = jsonEncode(tasks.map((t) => t.toJson()).toList());
     await prefs.setString('tasks', encoded);
   }

   void addTask(String title) {
     if (title.trim().isEmpty) return;
     setState(() {
       tasks.add(Task(title: title.trim(), priority: selectedPriority));
       controller.clear();
       selectedPriority = 2;
       sortTasks();
       saveTasks();
     });
   }

   void toggleComplete(int index) {
     setState(() {
       tasks[index].isCompleted = !tasks[index].isCompleted;
       saveTasks();
     });
   }

   void deleteTask(int index) {
     setState(() {
       tasks.removeAt(index);
       saveTasks();
     });
   }

   void editTask(int index, String newTitle) {
     setState(() {
       tasks[index].title = newTitle;
       saveTasks();
     });
   }

   void sortTasks() {
     tasks.sort((a, b) => a.priority.compareTo(b.priority));
   }

   void showEditDialog(int index) {
     final editController = TextEditingController(text: tasks[index].title);

     showGeneralDialog(
       context: context,
       barrierDismissible: true,
       barrierLabel: 'Edit',
       pageBuilder: (_, __, ___) => const SizedBox.shrink(), // Required placeholder
       transitionDuration: const Duration(milliseconds: 300),
       transitionBuilder: (_, animation, __, child) {
         return ScaleTransition(
           scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
           child: AlertDialog(
             title: const Text('Edit Task'),
             content: TextField(controller: editController),
             actions: [
               TextButton(
                 onPressed: () {
                   editTask(index, editController.text);
                   Navigator.pop(context);
                 },
                 child: const Text('Save'),
               ),
             ],
           ),
         );
       },
     );
   }


   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: const Text('To-Do List')),
       body: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           children: [
             AddTaskWidget(
               controller: controller,
               selectedPriority: selectedPriority,
               onPriorityChanged: (val) => setState(() => selectedPriority = val!),
               onAdd: () => addTask(controller.text),
             ),
             const SizedBox(height: 16),
             Expanded(
               child: tasks.isEmpty
                   ? const Center(child: Text("No tasks yet."))
                   : ListView.builder(
                 itemCount: tasks.length,
                 itemBuilder: (context, index) {
                   final task = tasks[index];
                   return AnimatedContainer(
                     duration: const Duration(milliseconds: 300),
                     margin: const EdgeInsets.symmetric(vertical: 6),
                     decoration: BoxDecoration(
                       color: task.isCompleted
                           ? Colors.green[50]
                           : Colors.white,
                       borderRadius: BorderRadius.circular(12),
                       boxShadow: [
                         BoxShadow(
                           blurRadius: 4,
                           color: Colors.grey.withOpacity(0.2),
                           offset: const Offset(0, 2),
                         )
                       ],
                     ),
                     child: ListTile(
                       leading: Checkbox(
                         value: task.isCompleted,
                         onChanged: (_) => toggleComplete(index),
                       ),
                       title: Text(
                         task.title,
                         style: TextStyle(
                           decoration: task.isCompleted
                               ? TextDecoration.lineThrough
                               : TextDecoration.none,
                         ),
                       ),
                       subtitle: Text("Priority: ${["High", "Medium", "Low"][task.priority - 1]}"),
                       trailing: Row(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           IconButton(
                             icon: const Icon(Icons.edit),
                             onPressed: () => showEditDialog(index),
                           ),
                           IconButton(
                             icon: const Icon(Icons.delete),
                             onPressed: () => deleteTask(index),
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
       ),
     );
   }
 }

 class AddTaskWidget extends StatelessWidget {
   final TextEditingController controller;
   final int selectedPriority;
   final void Function(int?) onPriorityChanged;
   final VoidCallback onAdd;

   const AddTaskWidget({
     super.key,
     required this.controller,
     required this.selectedPriority,
     required this.onPriorityChanged,
     required this.onAdd,
   });

   @override
   Widget build(BuildContext context) {
     return Column(
       children: [
         TextField(
           controller: controller,
           decoration: const InputDecoration(
             hintText: 'Enter new task',
             border: OutlineInputBorder(),
           ),
         ),
         const SizedBox(height: 8),
         Row(
           children: [
             const Text("Priority: "),
             DropdownButton<int>(
               value: selectedPriority,
               items: const [
                 DropdownMenuItem(value: 1, child: Padding(
                   padding: EdgeInsets.all(8.0),
                   child: Text("High"),
                 )),
                 DropdownMenuItem(value: 2, child: Padding(
                   padding: EdgeInsets.all(8.0),
                   child: Text("Medium"),
                 )),
                 DropdownMenuItem(value: 3, child: Padding(
                   padding: EdgeInsets.all(8.0),
                   child: Text("Low"),
                 )),
               ],
               onChanged: onPriorityChanged,
             ),
             const Spacer(),
             ElevatedButton(
               onPressed: onAdd,
               child: const Text('Add Task'),
             ),
           ],
         ),
       ],
     );
   }
 }

