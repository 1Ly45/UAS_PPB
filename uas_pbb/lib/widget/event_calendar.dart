import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventCalendar extends StatefulWidget {
  @override
  _EventCalendarState createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  List<Appointment> assignments = [];

  @override
  void initState() {
    super.initState();
    // Fetch the appointments from Firestore when the widget is initialized
    FirebaseFirestore.instance.collection('Tugas').snapshots().listen((snapshot) {
      setState(() {
        // Map Firestore data to Appointment objects and update the assignments list
        assignments = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          DateTime start = (data['Tanggal_Upload'] as Timestamp).toDate();
          DateTime end;
          if (data['Tanggal_Deadline'] != null) {
            end = (data['Tanggal_Deadline'] as Timestamp).toDate();
          }else{
            end = start;
          }
          return Appointment(
            startTime: start,
            endTime: end,
            subject: data['Title'],
            color: Color(int.parse(data['Color']) ), // Customize the color as needed
          );
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Limit the height of the calendar to half the screen height
          Container(
            height: MediaQuery.of(context).size.height / 1.3,
            child: SfCalendar(
              view: CalendarView.month,
              dataSource: AssigmentDataSource(assignments),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 20, 5, 5),
            child: assesmentList(context),
          ),
        ],
      ),
    );
  }
}

class AssigmentDataSource extends CalendarDataSource {
  AssigmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

Widget assesmentList(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
    child: ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/assignment',
        );
      },
      child: Column(
        children: [
          Text("List Tugas"),
        ],
      ),
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(0),
      ),
    ),
  );
}
