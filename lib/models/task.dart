
import 'package:drape_shoppe_crm/models/comment.dart';

class TaskModel {
  final String dealNo;
  final String createdBy;
  final List<String> assignedTo;
  final String priority;
  final String title;
  final String description;
  final DateTime dueDate;
  final String designer;
  final Map<String, CommentModel> comments; // Map of CommentModels
  final String status;
  final int progress;
  final List<String> attachments;

  TaskModel({
    required this.dealNo,
    required this.createdBy,
    required this.assignedTo,
    required this.priority,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.designer,
    required this.comments,
    required this.status,
    required this.progress,
    required this.attachments,
  });

  // JSON to TaskModel object
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // Convert the 'comments' field, which is a Map of Maps, into a Map of CommentModel objects
    Map<String, CommentModel> commentsMap =
    (json['comments'] as Map<String, dynamic>).map((key, value) {
      return MapEntry(key, CommentModel.fromJson(value));
    });

    return TaskModel(
      dealNo: json['deal_no'] as String,
      createdBy: json['created_by'] as String,
      assignedTo: List<String>.from(json['assigned_to']),
      priority: json['priority'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: (json['due_date']).toDate(),
      designer: json['designer'] as String,
      comments: commentsMap,
      status: json['status'] as String,
      progress: json['progress'] as int,
      attachments: List<String>.from(json['attachments']),
    );
  }

  // TaskModel object to JSON
  Map<String, dynamic> toJson() {
    // Convert the comments map to a map of JSON objects
    Map<String, dynamic> commentsMap = comments.map((key, commentModel) {
      return MapEntry(key, commentModel.toJson());
    });

    return {
      'deal_no': dealNo,
      'created_by': createdBy,
      'assigned_to': assignedTo,
      'priority': priority,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'designer': designer,
      'comments': commentsMap, // Save comments as a map of JSON objects
      'status': status,
      'progress': progress,
      'attachments': attachments,
    };
  }
}
