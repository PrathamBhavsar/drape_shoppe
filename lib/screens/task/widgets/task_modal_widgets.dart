import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:drape_shoppe_crm/screens/task/widgets/custom_task_icon_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TaskStatusModalWidget extends StatefulWidget {
  const TaskStatusModalWidget({super.key});

  @override
  State<TaskStatusModalWidget> createState() => _TaskStatusModalWidgetState();
}

class _TaskStatusModalWidgetState extends State<TaskStatusModalWidget> {
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Status',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: homeProvider.userNames.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator()) // Loading indicator
                  : ListView.builder(
                      itemCount: homeProvider.taskStatus.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            HomeProvider.instance.setSelectedStatus(index);
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 5),
                                  child: Row(
                                    children: [
                                      CustomTaskIconWidget(
                                        color: HomeProvider.instance
                                            .taskStatus[index]["primaryColor"],
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        homeProvider.taskStatus[index]["text"],
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: HomeProvider
                                                    .instance.taskStatus[index]
                                                ["primaryColor"]),
                                      ),
                                    ],
                                  ),
                                ),
                              ), // Display each user's name

                              const Divider(), // Divider between each ListTile
                            ],
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

class AttachmentsModelWidget extends StatelessWidget {
  const AttachmentsModelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.3,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pick An Attachment',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? photo = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (photo != null) {
                              HomeProvider.instance.pickedFile.add(photo.path);
                              HomeProvider.instance.pickedFileNames
                                  .add(photo.name);
                            }
                          },
                          icon: const Icon(
                            Icons.image_outlined,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Gallery',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? photo = await picker.pickImage(
                                source: ImageSource.camera);
                            if (photo != null) {
                              HomeProvider.instance.pickedFile.add(photo.path);
                              HomeProvider.instance.pickedFileNames
                                  .add(photo.name);
                            }
                          },
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Camera',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              allowMultiple: true,
                              type: FileType.custom,
                              allowedExtensions: ['pdf', 'doc'],
                            );
                            if (result != null) {
                              HomeProvider.instance.pickedFile
                                  .addAll(result.paths.whereType<String>());
                              HomeProvider.instance.pickedFileNames
                                  .addAll(result.names.whereType<String>());
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(
                            Icons.file_copy_outlined,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Documents',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
