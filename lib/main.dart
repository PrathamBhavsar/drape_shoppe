import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:drape_shoppe_crm/router/router.dart';
import 'package:drape_shoppe_crm/utils/secrets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Secrets.supabaseUrl,
    anonKey: Secrets.supabaseKey,
  );

  // Check login state from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  print(isLoggedIn);
  runApp(
    ChangeNotifierProvider(
      create: (context) => HomeProvider.instance,
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: TaskTabScreen(
    //     isNewTask: false,
    //     dealNo: '20241018124429',
    //   ),
    // );

    return MaterialApp.router(
      routerConfig: MyRouter.router(isLoggedIn),
    );
  }
}
