import 'package:drape_shoppe_crm/models/comment.dart';
import 'package:drape_shoppe_crm/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task.dart';

class SupabaseController {
  static final SupabaseController instance =
  SupabaseController._privateConstructor();
  SupabaseController._privateConstructor();
  final supabase = Supabase.instance.client;

  Future<void> signUp(BuildContext context, String name,String email, String password) async {
    try{
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      UserModel user = UserModel(name: name, email: email, profilePhotoUrl: "x");

      // Add user entry to table
      await createRowEntry(user);
      await _saveLoginState(res.user!.id);
    } catch (error){
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

  Future<void> login(BuildContext context,String email, String password) async{
    try{
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      await _saveLoginState(res.user!.id);
      context.goNamed('home');
    } catch (error){
      print("Error during login: $error");
      Fluttertoast.showToast(msg: error.toString());
    }
    }

    Future<void> logout() async{
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userId');
    await supabase.auth.signOut();

    }


}