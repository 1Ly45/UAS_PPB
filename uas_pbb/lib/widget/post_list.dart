import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_pbb/function/auth.dart';
import 'package:uas_pbb/widget/delete_confirmation.dart';
import 'package:url_launcher/url_launcher.dart';

Widget post_view(String className) {
  final CollectionReference _detailCollection =
      FirebaseFirestore.instance.collection(className);
  return StreamBuilder<QuerySnapshot>(
    stream: _detailCollection
        .orderBy('Tanggal_Upload', descending: true)
        .limit(20)
        .snapshots(), // Limit the number of documents fetched
    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
      if (streamSnapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (streamSnapshot.hasError) {
        return Center(child: Text('Error: ${streamSnapshot.error}'));
      } else if (streamSnapshot.hasData) {
        if (streamSnapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No one post anything yet', 
          style: TextStyle(
            fontSize: 25.0,
          )
          )
          );
        }
        return Expanded(
          child: ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return PostCard(documentSnapshot, className);
            },
          ),
        );
      } else {
        return const Center(child: Text('No data available'));
      }
    },
  );
}

class PostCard extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final String className;
  final User? user = Auth().currentUser;

  PostCard(this.documentSnapshot, this.className);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        userPoster(documentSnapshot, user, context, className),
        Card(
          color: checkTag_Color(documentSnapshot['Tag'] ?? Colors.grey),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(checkTag_Icon(documentSnapshot['Tag']) ?? Icons.adjust),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(documentSnapshot['Title'] ?? '', 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          ),
                          Text(timetoString(documentSnapshot['Tanggal_Upload']) ??
                              '', 
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                
                              ) ),
                        ],
                      ),
                    ),
                    Spacer(),
                    // Replacing PopupMenuButton with an IconButton
                    
                  ],
                ),
                Text(documentSnapshot['Deskripsi'] ?? '', 
                style: TextStyle(
                  // color: Colors.white60,
                )),
                if (documentSnapshot['Link'] != null && documentSnapshot['Link'].toString().trim().isNotEmpty) 
                 ElevatedButton(
                    onPressed: () {
                      launchUrl(Uri.parse(documentSnapshot['Link']));
                    },
                    child: Text(documentSnapshot['Link']),
                  ),
                if (documentSnapshot['Tag'] == 'Tugas')
                  deadline(documentSnapshot['Tanggal_Deadline'])
              ],
            ),
          ),
        ),
      ],
    );
  }
}

checkTag_Color(String tag) {
  if (tag == 'Tugas') {
    return const Color.fromARGB(255, 125, 170, 206);
  } else if (tag == 'Materi') {
    return const Color.fromARGB(255, 115, 208, 118);
  } else if (tag == 'Note') {
    return const Color.fromARGB(255, 233, 160, 49);
  }
  return Colors.white;
}

checkTag_Icon(String tag) {
  if (tag == 'Tugas') {
    return Icons.assignment;
  } else if (tag == 'Materi') {
    return Icons.list_alt;
  } else if (tag == 'Note') {
    return Icons.notes;
  }
  return Icons.help;
}

timetoString(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('MMM dd, hh:mm').format(dateTime);
}

Widget deadline(Timestamp? dl) {
  if (dl == null) {
    return Text("This assessment has no Deadline");
  } else {
    return Text("Deadline: ${timetoString(dl)}", 
    style: TextStyle(
      color: Colors.red,
    )
    );
  }
}

Widget userPoster(DocumentSnapshot documentSnapshot, User? user, BuildContext context, String className){
  if (user?.email == documentSnapshot['Poster']) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.account_box),
          Text(documentSnapshot['Poster']??"User"),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.edit),
                          title: Text("Edit"),
                          onTap: () {
                            // Your edit logic here
                            Navigator.pop(context); // Close the bottom sheet
                            Timestamp? docDeadline = null;
                            String? docColor;
                            if(documentSnapshot['Tag'] == "Tugas"){
                              docDeadline = documentSnapshot['Tanggal_Deadline'];
                              docColor = documentSnapshot['Color'];
                            }
                            // Navigate to the post screen and pass the className
                            Navigator.pushNamed(
                              context,
                              '/post',  // The route name
                              arguments: {
                                'name': className,
                                'Title': documentSnapshot['Title'],
                                'Deskripsi': documentSnapshot['Deskripsi'],
                                'Tag': documentSnapshot['Tag'],
                                'DocumentID' :documentSnapshot.id,
                                'Deadline': docDeadline,
                                'Tanggal_Upload': documentSnapshot['Tanggal_Upload'],
                                'Color': docColor,
                              },
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete),
                          title: Text("Delete"),
                          onTap: () {
                            // Your delete logic here
                            Navigator.pop(context); // Close the bottom sheet
                            showDeleteConfirmation(context, documentSnapshot.id, className);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.more_vert),
          )
        ]
      ),
    );
  }else{
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.account_box),
          Text(documentSnapshot['Poster']??"User"),
        ]
      ),
    );
  }
}