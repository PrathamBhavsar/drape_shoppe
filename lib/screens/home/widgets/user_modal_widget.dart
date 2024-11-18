import 'package:drape_shoppe_crm/controllers/taskController.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UserModalWidget extends StatefulWidget {
  const UserModalWidget({super.key, required this.assignedToController});
final TextEditingController assignedToController;
  @override
  State<UserModalWidget> createState() => _UserModalWidgetState();
}

class _UserModalWidgetState extends State<UserModalWidget> {
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  final List<String> selectedUsers = []; // List to track selected users

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.put(TaskController());

    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Users',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Spacer(), // Push the button to the right
                TextButton(
                  onPressed: () {
                    // Update the HomeProvider with the selected users
                    // homeProvider.addSelectedUsers(selectedUsers, widget.assignedToController);
                    print(selectedUsers);

                    Navigator.of(context).pop(); // Close the modal
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Search Field
            TextField(
              focusNode: searchFocusNode,
              controller: searchController,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'Search Here',
                prefixIcon: Icon(Icons.search_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: controller.userNames.length,
                  itemBuilder: (context, index) {
                    String userName = controller.userNames[index]['name'];
                    bool isSelected = selectedUsers.contains(userName);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedUsers.remove(userName); // Deselect
                          } else {
                            selectedUsers.add(userName); // Select
                          }
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.lightGreen
                                      : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                height: 40,
                                width: 40,
                                child: isSelected
                                    ? const Icon(
                                  Icons.done_rounded,
                                  color: Colors.white,
                                )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const Text('Tasks: 10'),
                                ],
                              ),
                            ],
                          ),
                          const Divider(), // Divider between each ListTile
                        ],
                      ),
                    );
                  },
                );
              }),
            )
            // Expanded(
            //   child: homeProvider.userNames.isEmpty
            //       ? const Center(child: CircularProgressIndicator())
            //       : ListView.builder(
            //           itemCount: homeProvider.userNames.length,
            //           itemBuilder: (context, index) {
            //             String userName = homeProvider.userNames[index];
            //             bool isSelected = selectedUsers.contains(userName);
            //
            //             return GestureDetector(
            //               onTap: () {
            //                 setState(() {
            //                   if (isSelected) {
            //                     selectedUsers.remove(userName); // Deselect
            //                   } else {
            //                     selectedUsers.add(userName); // Select
            //                   }
            //                 });
            //               },
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Row(
            //                     children: [
            //                       const SizedBox(width: 12),
            //                       Container(
            //                         decoration: BoxDecoration(
            //                           color: isSelected
            //                               ? Colors.lightGreen
            //                               : Colors.red,
            //                           shape: BoxShape.circle,
            //                         ),
            //                         height: 40,
            //                         width: 40,
            //                         child: isSelected
            //                             ? const Icon(
            //                                 Icons.done_rounded,
            //                                 color: Colors.white,
            //                               )
            //                             : null,
            //                       ),
            //                       const SizedBox(width: 12),
            //                       Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             userName,
            //                             style: const TextStyle(fontSize: 18),
            //                           ),
            //                           const Text('Tasks: 10'),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                   const Divider(), // Divider between each ListTile
            //                 ],
            //               ),
            //             );
            //           },
            //         ),
            // ),
          ],
        ),
      ),
    );
  }
}
