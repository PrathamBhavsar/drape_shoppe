import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskController extends GetxController {
  var userNames = <Map<String, dynamic>>[].obs; // Observable list to hold data
  var isLoading = true.obs; // Observable loading state

  // Fetch data from Supabase
  Future<void> fetchData() async {
    isLoading(true); // Set loading state to true
    final response = await Supabase.instance.client.from('salesperson').select('name');
    
    if (response.isNotEmpty) {
      userNames.assignAll(response); // Assign fetched data
      print(response);
    } else {
      Fluttertoast.showToast(
        msg: 'Error fetching userNames',
      );
    }

    isLoading(false); // Set loading state to false
  }
}