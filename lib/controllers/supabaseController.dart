import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drape_shoppe_crm/controllers/apiController.dart';
import 'package:drape_shoppe_crm/models/comment.dart';
import 'package:drape_shoppe_crm/models/user.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task.dart';

class SupabaseController {
  static final SupabaseController instance = SupabaseController._privateConstructor();
  SupabaseController._privateConstructor();
  final supabase = Supabase.instance.client;
  final homeProvider = HomeProvider.instance;

  Future<void> signUp(BuildContext context, String name, String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      UserModel user = UserModel(name: name, email: email, profilePhotoUrl: "x");

      // Add user entry to table
      await createRowEntry(user);
      await _saveLoginState(res.user!.id);
    } catch (error) {
      print("Error during signUp: $error");
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future<List<TaskModel>> fetchTasksList() async {
    List<TaskModel> tasks = [];
    return tasks;
  }

  Future<List<CommentModel>> fetchComments(String dealNo) async {
    List<CommentModel> c = [];

    return c;
  }

  Future<void> _saveLoginState(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', userId);
  }

  Future<void> createRowEntry(UserModel user) async {
    try {
      final data = await supabase.from('salesperson').insert(user);
    } catch (error) {
      print("Error inserting user: $error");
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future<void> login(BuildContext context, String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      await _saveLoginState(res.user!.id);
      context.goNamed('home');
    } catch (error) {
      print("Error during login: $error");
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    await supabase.auth.signOut();
  }

  Future<Iterable<Map<String, dynamic>>?> getUsers() async {
    try {
      final response = await supabase.from('salesperson').select();

      if (response.isNotEmpty) {
        return response;
      } else {
        Fluttertoast.showToast(
          msg: 'Error fetching userNames',
        );
        return [];
      }
    } catch (error) {
      print("Error during getUsers: $error");
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future<void> createTask(assignedTo, priority, title, description, dueDate, designer, comment,
      status, progress, attachments, clients) async {
    final createdBy = supabase.auth.currentUser!.id;

    //upload attachments to supabase storage

   final response = await uploadTask(createdBy, assignedTo, priority, title, description, dueDate, designer, comment, status, progress, attachments, clients);
   
   if(response!.isNotEmpty) {
     final dealNo = response['deal_no'];
     final taskId = response['id'];

     //insert asignees
     for (Map<String, dynamic> asignee in assignedTo) {
       final data = {"task_id": taskId, "salesperson_id": asignee['id']};
       await supabase.from('task_asignees').insert(data);
     }

     //upload attachments
      List<String> attachmentUrls = await uploadAttachments(attachments, dealNo);
     //insert attachment urls
     for (String url in attachmentUrls) {
      final data = {"attachment_url": url, "task_id":taskId, "salesperson_id": createdBy};

       await supabase.from('task_attachments').insert(data);
     }

     //insert clients
     for (String client in clients) {
      final data = {"client_id": client, "task_id":taskId};

       await supabase.from('task_clients').insert(data);
     }

     //insert comment
         if(comment.isNotEmpty()) {
        final commentData = {"comment": comment,"salesperson_id": createdBy ,"task_id": taskId};

        await supabase.from('task_comments').insert(commentData);
      }
    }
  }

  Future<Map<String, dynamic>?> uploadTask(String createdBy, assignedTo, priority, title, description, dueDate, designer, comments, status, progress, attachments, client) async {
    final TaskModel task = TaskModel(
      createdBy: createdBy,
      priority: priority,
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      progress: progress,
    );

    final formattedDueDate = dueDate.toIso8601String();

    final dio = Dio();
    dio.options.validateStatus = (status) {
      return status! < 500; // Don't throw for 409, 400, etc. You can handle them manually
    };

    const url = 'https://tyjkydwnyuokukdjeuel.supabase.co/rest/v1/rpc/add_new_task';
    final data = { "p_created_by": "1eeb9d7a-795d-404b-a590-15202530ea3d",
      "p_priority": priority,
      "p_title": title,
      "p_description": description,
      "p_due_date": formattedDueDate,
      "p_status": status,
      "p_progress": progress,};
    print(data);

    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            "ApiKey":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5amt5ZHdueXVva3VrZGpldWVsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE5MDc3NjIsImV4cCI6MjA0NzQ4Mzc2Mn0.uEXFewr587J99awy6EWgGLqKBmDphLxSlvDGNKgHfGw",  // Replace with actual key
          },
        ),
      );
      if (response.statusCode == 200) {
        print('Task created successfully');
        print('Response: ${response.data}');
        return response.data[0];
      } else {
        print('Error: ${response.statusCode}, ${response.data}');
        return null;
      }
    } catch (e) {
      print('Error during request: $e');
    }
    return null;
  }

  Future<List<String>> uploadAttachments(List<String> files, String dealNo) async {
    final List<String> urls = [];
    const String bucketName = 'drape_shoppe_crm';

    //for each file
    for (String filePath in files) {
      final String fileName = basename(filePath);
      final file = File(filePath);
      //upload the file
      await supabase.storage.from(bucketName).upload(
            'attachments/$dealNo/$fileName',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      //download url
      final String publicUrl =
          supabase.storage.from(bucketName).getPublicUrl('attachments/$dealNo/$fileName');

      if (publicUrl.isNotEmpty) {
        urls.add(publicUrl);
      } else {
        //errror getting public url
      }
    }
    return urls;
  }
}
