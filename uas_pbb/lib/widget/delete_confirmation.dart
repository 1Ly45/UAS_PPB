import 'package:flutter/material.dart';
import 'package:uas_pbb/function/CRUD.dart';

void showDeleteConfirmation(BuildContext context, String documentId, String name) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text('Are you sure you want to proceed?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteDocument(documentId, name);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post Deleted')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}
