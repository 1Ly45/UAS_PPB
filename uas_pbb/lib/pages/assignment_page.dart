import 'package:flutter/material.dart';
import 'package:uas_pbb/widget/assignment_list.dart';
import 'package:uas_pbb/widget/event_calendar.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({Key? key}) : super(key: key);

  @override
  State<AssignmentPage> createState() => AssignmentPageState();
}

class AssignmentPageState extends State<AssignmentPage> {
  // Create a GlobalKey to maintain the Scaffold state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to Scaffold
      appBar: AppBar(
        title: const Text("PTIK Class List"),
      ),
      drawer:EventCalendar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            assignment_view()
          ],
        ),
      ),
    );
  }
}