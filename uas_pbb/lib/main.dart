import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uas_pbb/firebase_options.dart';
import 'package:uas_pbb/pages/assignment_page.dart';
import 'package:uas_pbb/pages/class_detail_page.dart';
import 'package:uas_pbb/pages/dashboard_page.dart';
import 'package:uas_pbb/pages/post_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/post': (context) => PostPage(),
        '/class_detail': (context) => ClassDetail(),
        '/assignment': (context) => AssignmentPage(),

      },
    );
  }
}
