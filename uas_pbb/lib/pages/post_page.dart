import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_pbb/function/CRUD.dart';
import 'package:uas_pbb/function/colorPicker.dart';
import 'package:uas_pbb/widget/event_calendar.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => PostPageState();
}

class PostPageState extends State<PostPage> {
  String _name = '';
  String selectedTag = ''; 
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  String? selectedColor;
  Timestamp? deadline;
  String? documentID;

  @override
  void initState() {
    super.initState();

    // Schedule a post-frame callback to delay the execution until after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      
      if (args != null) {
        // Initialize values with arguments, only once
        setState(() {
          _name = args['name'];  
          _titleController.text = args['Title'] ?? '';
          _deskripsiController.text = args['Deskripsi'] ?? '';
          selectedTag = args['Tag'] ?? ''; 
          documentID = args['DocumentID'] ?? null;
          
          if (selectedTag == "Tugas") {
            _deadlineController.text = args['Deadline'] != null
                ? DateFormat('MMM dd').format(args['Deadline'].toDate())
                : '';
            selectedColor = args['Color'];
            deadline = args['Deadline'];
          }

          // Debugging: Log the initial state
          print("PostPageState initialized with selectedTag: $selectedTag");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Debugging: Log the current selectedTag when building the widget
    print("build - SelectedTag: $selectedTag");

    final List<String> tags = ['Tugas', 'Materi', 'Note'];

    return Scaffold(
      appBar: AppBar(title: Text("Post In " + _name)),
      drawer: EventCalendar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a Tag:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 10),

                // Radio buttons for tags
                Column(
                  children: tags.map((tag) {
                    return RadioListTile<String>(
                      title: Text(tag),
                      value: tag,
                      groupValue: selectedTag, // Ensures the value is bound to selectedTag
                      activeColor: selectedTag == tag ? Colors.green : Colors.blue, // Color changes based on selected tag
                      onChanged: (String? value) {
                        // Update selectedTag when a new value is selected
                        setState(() {
                          selectedTag = value!; // Update selectedTag with the new value
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 10),
                // Title and Description fields
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: TextField(
                    controller: _deskripsiController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Show the deadline picker and color picker if the tag is 'Tugas'
                if (selectedTag == 'Tugas') ...[
                  TextField(
                    controller: _deadlineController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Deadline',
                      border: OutlineInputBorder(),
                    ),
                    onTap: _selectDate,
                  ),
                  const SizedBox(height: 10),
                  ColorPicker(
                    onColorSelected: (color) {
                      setState(() {
                        selectedColor = colorToHex(color);
                      });
                    },
                  ),
                ],

                const SizedBox(height: 20),
                // Save Button
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedTag.isEmpty ||
                            _titleController.text.isEmpty ||
                            _deskripsiController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                        } else {
                          await createOrUpdatePost(
                            _name,  // Use name
                            _titleController.text,
                            _deskripsiController.text,
                            selectedTag,
                            deadline,
                            selectedColor,
                            documentID
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            '/class_detail',
                            arguments: _name,  // Return name
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      pickedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        23,
        59,
        59,
      );
      setState(() {
        _deadlineController.text = pickedDate.toString().split(" ")[0];
        deadline = Timestamp.fromDate(pickedDate!);
      });
    }
  }
}
