import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_pbb/widget/class_list.dart';
import 'package:uas_pbb/widget/bottomSheet.dart';
import 'package:uas_pbb/function/auth.dart';
import 'package:uas_pbb/widget/event_calendar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Create a GlobalKey to maintain the Scaffold state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to Scaffold
      appBar: AppBar(
        // backgroundColor: Colors.,
        elevation: 5.0,
        shadowColor: Colors.grey.withOpacity(0.5),
        title: const Text("TASKMATE"),
        actions: [
          Text(user?.email ?? 'User email'),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: _signOutButton(),
          ),
        ]
      ),
      drawer: EventCalendar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            class_view(),
          ],
        ),
      ),
      floatingActionButton: addClass(context),
    );
  }
}

FloatingActionButton addClass(BuildContext context) {
  return FloatingActionButton(
    heroTag: 'addClass',
    onPressed: () async {
      showModalBottomSheetExample(context);
    },
    child: Icon(Icons.add),
  );
}


Widget _signOutButton() {
  Future<void> signOut() async {
    await Auth().signOut();
  }
  return ElevatedButton(
    onPressed: signOut,
    child: const Text("Sign Out"),
  );
}
