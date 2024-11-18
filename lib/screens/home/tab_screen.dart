import 'package:drape_shoppe_crm/screens/task/add_task_screen.dart';
import 'package:drape_shoppe_crm/screens/task/comments_screen.dart';
import 'package:flutter/material.dart';

class TaskTabScreen extends StatefulWidget {
  final String? dealNo;
  final bool isNewTask;

  const TaskTabScreen({super.key, required this.isNewTask, this.dealNo});

  @override
  State<TaskTabScreen> createState() => _TaskTabScreenState();
}

class _TaskTabScreenState extends State<TaskTabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isNewTask ? 'New Task' : 'Task Details'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.task), text: "Task Details"),
              Tab(icon: Icon(Icons.comment), text: "Comments"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddTaskScreen(isNewTask: widget.isNewTask, dealNo: widget.dealNo),
            CommentsScreen(
                dealNo: widget.dealNo ?? '', isNewTask: widget.isNewTask),
          ],
        ),
      ),
    );
  }
}
