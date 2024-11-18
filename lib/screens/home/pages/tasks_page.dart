
import 'package:drape_shoppe_crm/controllers/supabaseController.dart';
import 'package:drape_shoppe_crm/models/task.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:drape_shoppe_crm/screens/home/tab_screen.dart';
import 'package:drape_shoppe_crm/screens/task/widgets/custom_task_icon_widget.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // Provider.of<HomeProvider>(context, listen: false).getUsers();
    HomeProvider.instance.getUsers();
    SupabaseController.instance.fetchTasksList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await HomeProvider.instance.getUsers();
          await SupabaseController.instance.fetchTasksList();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Tasks',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 400,
                  child: FutureBuilder<List<TaskModel>>(
                      future: SupabaseController.instance.fetchTasksList(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }
                        if (snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No assigned tasks yet'),
                          );
                        }
                        List<TaskModel> tasks = snapshot.data!;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: TableWidget(
                            columnHeaders: ['Task Name', 'Due Date', 'Status'],
                            taskData: tasks,
                          ),
                        );

                        // return ListView.builder(
                        //   itemCount: tasks.length,
                        //   itemBuilder: (context, index) {
                        //     TaskModel task = tasks[index];
                        //     int priorityIndex = HomeProvider.instance
                        //         .getPriorityIndexFromText(task.priority);
                        //     int statusIndex = HomeProvider.instance
                        //         .getTaskIndexFromText(task.status);
                        //     String formattedCreatedAtDate =
                        //         DateFormat("dd MMM''yy").format(task.createdAt);
                        //     String formattedDueDate =
                        //         DateFormat("dd MMM''yy").format(task.dueDate);
                        //
                        //     return GestureDetector(
                        //       onTap: () {
                        //         Navigator.of(context).push(
                        //           MaterialPageRoute(
                        //             builder: (context) => AddTaskScreen(
                        //               dealNo: task.dealNo,
                        //               isNewTask: false,
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //       child: Column(
                        //         children: [
                        //           Row(
                        //             crossAxisAlignment: CrossAxisAlignment.center,
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceAround,
                        //             children: [
                        //               CustomTaskIconWidget(
                        //                 color: HomeProvider.instance
                        //                         .priorityValues[priorityIndex]
                        //                     ["color"],
                        //               ),
                        //               Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text(task.title),
                        //                   Text(formattedCreatedAtDate),
                        //                 ],
                        //               ),
                        //               Text(formattedDueDate),
                        //               Container(
                        //                 decoration: BoxDecoration(
                        //                     borderRadius:
                        //                         BorderRadius.circular(10),
                        //                     color: HomeProvider.instance
                        //                             .taskStatus[statusIndex]
                        //                         ["secondaryColor"]),
                        //                 child: Padding(
                        //                   padding: const EdgeInsets.all(8.0),
                        //                   child: Row(
                        //                     children: [
                        //                       CustomTaskIconWidget(
                        //                         color: HomeProvider.instance
                        //                                 .taskStatus[statusIndex]
                        //                             ["primaryColor"],
                        //                       ),
                        //                       SizedBox(width: 10),
                        //                       Text(
                        //                         HomeProvider.instance
                        //                                 .taskStatus[statusIndex]
                        //                             ["text"],
                        //                         style: TextStyle(
                        //                             color:
                        //                                 HomeProvider.instance
                        //                                             .taskStatus[
                        //                                         statusIndex]
                        //                                     ["primaryColor"],
                        //                             fontWeight: FontWeight.bold),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               )
                        //             ],
                        //           ),
                        //           SizedBox(height: 5),
                        //           Divider(),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TableWidget extends StatelessWidget {
  TableWidget({super.key, required this.taskData, required this.columnHeaders});
  final List<TaskModel> taskData;
  final List<String> columnHeaders;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      child: Table(
        border: const TableBorder(
          horizontalInside: BorderSide(width: 1, color: Colors.grey),
        ),
        columnWidths: {
          // Use IntrinsicColumnWidth for dynamic column sizing
          0: const IntrinsicColumnWidth(),
          1: const IntrinsicColumnWidth(),
          2: const IntrinsicColumnWidth(),
        },
        children: [
          // Column Headers
          TableRow(
            children: columnHeaders.map((header) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  header,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              );
            }).toList(),
          ),
          // Table Data with entire row tappable
          ...taskData.map((task) {


            int priorityIndex =
                HomeProvider.instance.getPriorityIndexFromText(task.priority);
            int statusIndex =
                HomeProvider.instance.getTaskIndexFromText(task.status);

            // Wrap each cell in a GestureDetector to detect taps anywhere in the row
            return TableRow(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TaskTabScreen(
                            isNewTask: false, dealNo: task.dealNo),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CustomTaskIconWidget(
                          color: HomeProvider
                              .instance.priorityValues[priorityIndex]["color"],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.title),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TaskTabScreen(
                            isNewTask: false, dealNo: task.dealNo),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'formattedDueDate',
                      style: TextStyle(
                        color: task.dueDate.isAfter(DateTime.now())
                            ? Colors.lightGreen
                            : Colors.red,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TaskTabScreen(
                            isNewTask: false, dealNo: task.dealNo),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HomeProvider.instance.taskStatus[statusIndex]
                            ["secondaryColor"],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTaskIconWidget(
                              color: HomeProvider.instance
                                  .taskStatus[statusIndex]["primaryColor"],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              HomeProvider.instance.taskStatus[statusIndex]
                                  ["text"],
                              style: TextStyle(
                                color: HomeProvider.instance
                                    .taskStatus[statusIndex]["primaryColor"],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
