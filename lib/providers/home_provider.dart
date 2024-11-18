import 'dart:io';
import 'package:drape_shoppe_crm/models/user.dart';
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

  }

  List<Map<String, int>> userTaskList = [];

  Future<void> setTasks() async {

  }

  Map<String, int> userTaskCount = {};
  List<Map<String, int>> userTaskCountList = [];

  Future<void> setIncompleteTasks() async {
  }

  UserModel? currentUser;

  Future<void> getCurrentUser() async {

  }

  Future<void> setControllers(
      String dealNo,
      TextEditingController title,
      TextEditingController desc,
      TextEditingController assignedTo,
      TextEditingController designer,
      ) async {
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

    return 'dealNo';
  }

  String comment = '';
  List<String> AllComments = [];
  void setComment(String text) {
    comment = text;
    print(comment);
    notifyListeners();
  }

  Future<void> getUsers() async {

  }
}
