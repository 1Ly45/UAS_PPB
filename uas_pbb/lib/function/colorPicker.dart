import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final Function(Color) onColorSelected; // Callback to send selected color

  const ColorPicker({Key? key, required this.onColorSelected}) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<int> colors = [
    0xFFFF0000, // red
    0xFF008000, // green
    0xFF0000FF, // blue
    0xFFFFFF00, // yellow
    0xFFFFA500, // orange
    0xFF800080, // purple
    0xFFFF10F0, // pink
    0xFFA52A2A, // brown
    0xFF00FFFF, // cyan
    0xFF4B0082, // indigo
  ];
  Color selectedColor = const Color(0xFFFF0000); // Default selected color

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select a Color:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10, // Horizontal space between circles
          runSpacing: 10, // Vertical space between rows
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = Color(color); // Convert int to Color
                });
                widget.onColorSelected(Color(color)); // Send selected color to parent
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: selectedColor.value == color ? 50 : 40,
                height: selectedColor.value == color ? 50 : 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(color),
                  border: Border.all(
                    color: selectedColor.value == color ? Colors.black : Colors.grey,
                    width: 2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
