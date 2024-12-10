import 'package:flutter/material.dart';
import 'package:uas_pbb/widget/event_calendar.dart';
import 'package:uas_pbb/widget/post_list.dart';

class ClassDetail extends StatefulWidget {

  const ClassDetail({Key? key}) : super(key: key);

  @override
  State<ClassDetail> createState() => ClassDetailState();
}
class ClassDetailState extends State<ClassDetail> {
   @override
  Widget build(BuildContext context) {
    String name = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        elevation: 5.0,
        shadowColor: Colors.grey.withOpacity(0.5),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: IconButton(icon: Icon(Icons.home), onPressed: () {
              Navigator.pushNamed(context, 
              '/');
            }),
          )
        ],
      ),
      drawer: EventCalendar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            post_view(name),
          ],
        ),
      ),
      floatingActionButton: addPost(context, name)
    );   
  }
}

FloatingActionButton addPost(BuildContext context, String pushName) {
  return FloatingActionButton(
    heroTag: 'addpost',
    onPressed: () {
      Navigator.pushNamed(context, '/post',
        arguments: {
          'name': pushName,
          'Title': '', // Default empty string for Title
          'Deskripsi': '', // Default empty string for Deskripsi
          'Tag': '', // Default empty string for Tag
          'DocumentID' : null, // Default empty string for DocumentID
          'Deadline': null, // Default null if no deadline
          'Tanggal_Upload': null, // Default null if no deadline
          'Color': null, // Default null for Color
        }
      );
    },
    child: Icon(Icons.post_add),
  );
}
