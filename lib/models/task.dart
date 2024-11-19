class TaskModel {
  final String createdBy;
  // final List<Map<String, dynamic>> assignedTo;
  final String priority;
  final String title;
  final String description;
  final DateTime dueDate; 
  // final List<Map<String, dynamic>> designer;
  // final List<Map<String, dynamic>> client;
  // final String comment;
  final String status;
  final int progress;
  // final List<String> attachments;

  TaskModel({
    required this.createdBy,
    // required this.assignedTo,
    required this.priority,
    required this.title,
    required this.description,
    required this.dueDate,
    // required this.designer,
    // required this.client,
    // required this.comments,
    required this.status,
    required this.progress,
    // required this.attachments,
  });

  // JSON to TaskModel object
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      createdBy: json['created_by'] as String,
      // assignedTo: List<Map<String, dynamic>>.from(json['assigned_to']),
      priority: json['priority'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['due_date']), 
      // designer: List<Map<String, dynamic>>.from(json['designer']),
      // client: List<Map<String, dynamic>>.from(json['client']),
      // comment: json['comment'] as String,
      status: json['status'] as String,
      progress: json['progress'] as int,
      // attachments: List<String>.from(json['attachments']),
    );
  }

  // TaskModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'created_by': createdBy,
      // 'assigned_to': assignedTo,
      'priority': priority,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String().split('T').first, 
      // 'designer': designer,
      // 'client': client,
      // 'comment': comment,
      'status': status,
      'progress': progress,
      // 'attachments': attachments,
    };
  }
}
