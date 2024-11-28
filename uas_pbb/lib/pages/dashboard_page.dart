import 'package:flutter/material.dart';
import 'package:uas_pbb/widget/class_list.dart';
import 'package:uas_pbb/widget/bottomSheet.dart';
import 'package:uas_pbb/widget/event_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Create a GlobalKey to maintain the Scaffold state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to Scaffold
      appBar: AppBar(
        title: const Text("PTIK Class List"),
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