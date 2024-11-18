import 'dart:io';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  static final HomeProvider instance = HomeProvider._privateConstructor();
  HomeProvider._privateConstructor();

  List<String> userNames = [];
  List<Map<String, dynamic>> priorityValues = [
    {"text": "Low", "color": const Color.fromARGB(255, 182, 255, 220)},
    {"text": "Medium", "color": const Color.fromARGB(255, 254, 254, 226)},
    {"text": "High", "color": const Color.fromARGB(255, 255, 160, 160)},
  ];

  late String selectedPriority = priorityValues[0]["text"];
  int selectedPriorityIndex = 0;

  List<String> pickedFile = [];
  List<String> pickedFileNames = [];

  DateTime now = DateTime.now();
  String dealNo = '';

  List<Map<String, dynamic>> taskStatus = [
    {
      "text": "Pending",
      "primaryColor": Colors.blue,
      "secondaryColor": Color(0x660000FF)
    },
    {
      "text": "Closed - lost",
      "primaryColor": Colors.green,
      "secondaryColor": Color(0x6600FF00)
    },
    {
      "text": "Closed - won",
      "primaryColor": Colors.purple,
      "secondaryColor": Color(0x66800080)
    },
    {
      "text": "Measurement",
      "primaryColor": Colors.orange,
      "secondaryColor": Color(0x66FFA500)
    },
    {
      "text": "Quote review",
      "primaryColor": Colors.teal,
      "secondaryColor": Color(0x66008080)
    },
    {
      "text": "Site long delay",
      "primaryColor": Colors.pink,
      "secondaryColor": Color(0x66FFB6C1)
    },
    {
      "text": "So & advance",
      "primaryColor": Colors.grey,
      "secondaryColor": Color(0x66B0B0B0)
    },
    {
      "text": "Store visit / selection",
      "primaryColor": Colors.amber,
      "secondaryColor": Color(0x66FFD700)
    }
  ];

  late String selectedStatus = taskStatus[0]["text"];
  int selectedStatusIndex = 0;

  void setSelectedStatus(int index) {
    selectedStatus = taskStatus[index]["text"];
    selectedStatusIndex = index;
    notifyListeners();
  }

  void setSelectedPriority(int index) {
    selectedPriority = priorityValues[index]["text"];
    selectedPriorityIndex = index;
    notifyListeners();
  }

  List<String> selectedUsers = [];

  void addSelectedUsers(
      List<String> users, TextEditingController assignedToController) {
    selectedUsers.clear();
    selectedUsers.addAll(users);
    print(selectedUsers);
    assignedToController.text = selectedUsers.join(", ");
    notifyListeners();
  }

  int assignedTasks = 0;
  int totalTasks = 0;
  int dueTodayTasks = 0;
  int pastDueTasks = 0;

  //saves list of fetched taskmodels in a var
  //increaments the values of the home screen data based on the taskmodels
  Future<void> setAssignedTasks() async {
    final taskList = await FirebaseController.instance.fetchTasksList();
    Timestamp timestamp = Timestamp.now();
    DateTime dateOnly = DateTime(timestamp.toDate().year,
        timestamp.toDate().month, timestamp.toDate().day);

    totalTasks = await FirebaseController.instance.fetchAllTasks();
    assignedTasks = taskList.length;
    for (var task in taskList) {
      if (task.dueDate == dateOnly) {
        dueTodayTasks++;
      }
      if (task.dueDate.isAfter(dateOnly)) {
        pastDueTasks++;
      }
    }
    notifyListeners();
  }

  List<Map<String, int>> userTaskList = [];

  Future<void> setTasks() async {
    List<TaskModel> tasks =
    await FirebaseController.instance.fetchIncompleteTasks();
    userTaskList.clear();

    for (var task in tasks) {
      // userTaskList.add(task);
    }
  }

  Map<String, int> userTaskCount = {};
  List<Map<String, int>> userTaskCountList = [];

  Future<void> setIncompleteTasks() async {
    // Fetch the incomplete tasks from Firestore (assuming fetchIncompleteTasks is correctly implemented)
    List<TaskModel> tasks =
    await FirebaseController.instance.fetchIncompleteTasks();

    // Clear the map and list to avoid duplication
    userTaskCount.clear();
    userTaskCountList.clear();

    // Loop through each task
    for (var task in tasks) {
      // Assuming 'assignedTo' is a list of usernames
      for (var user in task.assignedTo) {
        // If the user is already in the map, increment their task count
        if (userTaskCount.containsKey(user)) {
          userTaskCount[user] = userTaskCount[user]! + 1;
        } else {
          // Otherwise, add the user to the map with a count of 1
          userTaskCount[user] = 1;
        }
      }
    }

    userTaskCount.forEach((user, count) {
      userTaskCountList.add({user: count});
    });
    notifyListeners();
    print(userTaskCount);
    print(userTaskCountList);
  }

  UserModel? currentUser;

  Future<void> getCurrentUser() async {
    currentUser = await FirebaseController.instance.currentUserModel();
    notifyListeners();
  }

  Future<void> setControllers(
      String dealNo,
      TextEditingController title,
      TextEditingController desc,
      TextEditingController assignedTo,
      TextEditingController designer,
      ) async {
    TaskModel task = await FirebaseController.instance.getTask(dealNo);
    title.text = task.title;
    desc.text = task.description;
    String assignedToUser = task.assignedTo.join(', ');
    assignedTo.text = assignedToUser;
    designer.text = task.designer;
    HomeProvider.instance.pickedFileNames.addAll(task.attachments);

    selectedStatusIndex = getTaskIndexFromText(task.status);
    selectedPriorityIndex = getPriorityIndexFromText(task.priority);
    notifyListeners();
  }

  int getPriorityIndexFromText(String priorityValue) {
    for (int index = 0; index < priorityValues.length; index++) {
      var priority = priorityValues[index];
      if (priority["text"] == priorityValue) {
        return index;
      }
    }
    return 0;
  }

  int getTaskIndexFromText(String statusValue) {
    for (int index = 0; index < taskStatus.length; index++) {
      var status = taskStatus[index];
      if (status["text"] == statusValue) {
        return index;
      }
    }
    return -1;
  }

  String setDealNo() {
    DateTime rightNow = DateTime.now();
    now = rightNow;
    dealNo = DateFormat('yyyyMMddHHmmss').format(rightNow);
    pickedFileNames.clear();
    notifyListeners();
    return dealNo;
  }

  String comment = '';
  List<String> AllComments = [];
  void setComment(String text) {
    comment = text;
    print(comment);
    notifyListeners();
  }

  Future<void> getUsers() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').get();

      List<String> names =
      snapshot.docs.map((doc) => doc['user_name'] as String).toList();

      userNames = names;
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }
}
