import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_pbb/function/auth.dart';


Future<void> createCollection(String name, String  lecture, String color) async {
  // Reference to the new Firestore collection (will be created automatically when you add data)
  CollectionReference _classCollection = FirebaseFirestore.instance.collection('Class');

  // Data for the document
  Map<String, dynamic> documentData = {
    'Name':name,
    'Lecture': lecture,
    'Color': color,
  };

  try {
    await _classCollection.add(documentData);
    print('Document added to new collection successfully!');
  } catch (e) {
    print('Error adding document: $e');
  }
}

Future<void> createOrUpdatePost(
  String name, 
  String title, 
  String deskripsi, 
  String tag, 
  Timestamp? deadline, 
  Timestamp? tanggal_upload,
  String? color,
  String? documentId
) async {
  // Reference to the Firestore collection
  CollectionReference _classCollection = FirebaseFirestore.instance.collection(name);
  final User? user = Auth().currentUser;


  // Data for the document
  Map<String, dynamic> documentData = {
    'Poster': user?.email,
    'Title': title,
    'Deskripsi': deskripsi,
  };

  try {
    if (documentId != null) {
      documentData['Tanggal_Upload'] = tanggal_upload;
      // If documentId is provided, update the existing document
      if (tag == "Tugas") {
        documentData['Tanggal_Deadline'] = deadline;
        documentData['Color'] = color;
        documentData['Class'] = name;
        CollectionReference _tugasCollection = FirebaseFirestore.instance.collection('Tugas');
        DocumentReference _classDocument = FirebaseFirestore.instance.collection(name).doc(documentId);
        DocumentSnapshot classSnapshot = await _classDocument.get();
        String classID = classSnapshot.get('DocumentID');
        await _tugasCollection.doc(classID).update(documentData);
        documentData.remove('Class');
      }
      documentData['Tag'] = tag;
      await _classCollection.doc(documentId).update(documentData);
      print('Document updated successfully!');
    } else {
      // If no documentId, add a new document
      documentData['Tanggal_Upload']= FieldValue.serverTimestamp();
      if (tag == "Tugas") {
        documentData['Tanggal_Deadline'] = deadline;
        documentData['Color'] = color;
        documentData['Class'] = name;
        CollectionReference _tugasCollection = FirebaseFirestore.instance.collection('Tugas');
        DocumentReference _tugasDocument = await _tugasCollection.add(documentData);
        documentData['DocumentID'] = _tugasDocument.id;
        documentData.remove('Class');
      }
      documentData['Tag'] = tag;
      await _classCollection.add(documentData);
      print('Document added to new collection successfully!');
    }
  } catch (e) {
    print('Error creating or updating document: $e');
  }
}

Future<void> deleteDocument(String documentId, String name) async {
  CollectionReference _tugasCollection = FirebaseFirestore.instance.collection('Tugas');
  CollectionReference _classCollection = FirebaseFirestore.instance.collection(name);
  DocumentReference _classDocument = FirebaseFirestore.instance.collection(name).doc(documentId);
  DocumentSnapshot classSnapshot = await _classDocument.get();


    try {
      if (classSnapshot.get('Tag') == "Tugas") {
        String tugasID = classSnapshot.get('DocumentID');
        await _tugasCollection.doc(tugasID).delete();
      }
      await _classCollection.doc(documentId).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }