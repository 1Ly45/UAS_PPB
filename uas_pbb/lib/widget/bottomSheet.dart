import 'package:flutter/material.dart';
import 'package:uas_pbb/function/colorPicker.dart';
import 'package:uas_pbb/function/CRUD.dart';

showModalBottomSheetExample(BuildContext context) {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lectureController = TextEditingController();
  String selectedColor = "0xFFFF0000"; // Default selected color

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext ctx) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 10,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Field for Class Name
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Class'),
                  ),

                  // Text Field for Lecture
                  TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: _lectureController,
                    decoration: const InputDecoration(labelText: 'Lecture'),
                  ),

                ColorPicker(
                    onColorSelected: (color) {
                      setState(() {
                        selectedColor = colorToHex(color); // Update selected color
                      });
                    },
                  ),

                  // Create Button
                  const SizedBox(height: 15),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isEmpty || _lectureController.text.isEmpty) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields')));
                        }else{
                          createCollection(_nameController.text, _lectureController.text, selectedColor);
                          Navigator.pop(ctx);
                        }
                      },
                      child: const Text('Create'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

