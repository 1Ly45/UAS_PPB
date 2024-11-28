import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          return const Center(child: Text('No data available'));
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

  PostCard(this.documentSnapshot, this.className);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                      Text(documentSnapshot['Title'] ?? ''),
                      Text(timetoString(documentSnapshot['Tanggal_Upload']) ??
                          ''),
                    ],
                  ),
                ),
                Spacer(),
                // Replacing PopupMenuButton with an IconButton
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
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
                        'Deadline': null,
                        'Color': null,
                      },
                    );
                  },
                ),
              ],
            ),
            Text(documentSnapshot['Deskripsi'] ?? ''),
            if (documentSnapshot['Tag'] == 'Tugas')
              deadline(documentSnapshot['Tanggal_Deadline'])
          ],
        ),
      ),
    );
  }
}

checkTag_Color(String tag) {
  if (tag == 'Tugas') {
    return Colors.indigo;
  } else if (tag == 'Materi') {
    return Colors.green;
  } else if (tag == 'Note') {
    return Colors.yellow;
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
  return DateFormat('MMM dd').format(dateTime);
}

Widget deadline(Timestamp? dl) {
  if (dl == null) {
    return Text("This assessment has no Deadline");
  } else {
    return Text("Deadline: ${timetoString(dl)}");
  }
}
