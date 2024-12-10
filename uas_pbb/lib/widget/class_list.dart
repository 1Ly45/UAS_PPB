import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Reference to Firestore collection
final CollectionReference _classCollection = FirebaseFirestore.instance.collection('Class');

Widget class_view() {
  return StreamBuilder<QuerySnapshot>(
    stream: _classCollection.snapshots(), // Listen for real-time updates
    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
      if (streamSnapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator()); // Show loading while waiting for data
      } else if (streamSnapshot.hasError) {
        // Show error if something goes wrong
        return Center(child: Text('Error: ${streamSnapshot.error}'));
      } else if (streamSnapshot.hasData) {
        if (streamSnapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available')); // If there are no documents
        }
        return Expanded(  // Wrap ListView in Expanded to give it a valid size
          child: ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,  // Count of documents
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];     
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 0), // Padding around the button
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  ),
                  height: 170,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/class_detail',
                      arguments: documentSnapshot['Name']);
                    },
                    child: ListTile(
                      title: Text(documentSnapshot['Name'] ?? 'No Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      ),
                      subtitle: Text(documentSnapshot['Lecture'] ?? 'No Lecture',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      )),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(_colorHex(documentSnapshot['Color'])),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Less round (change the value to adjust the roundness)
                      ),
                      padding: EdgeInsets.all(0), // No extra padding around button content
                    ),
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return const Center(child: Text('No data available')); // In case of no data
      }
    },
  );
}

_colorHex(String hex) {
  String colorhex = hex;
  return int.parse(colorhex);
}
