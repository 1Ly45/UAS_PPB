import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final Function(Color) onColorSelected; // Callback to send selected color

  const ColorPicker({Key? key, required this.onColorSelected}) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Color> colors = [
    const Color.fromARGB(255, 245, 149, 142),
    const Color.fromARGB(255, 100, 220, 104),
    const Color.fromARGB(255, 112, 177, 229),
    Colors.yellow,
    const Color.fromARGB(255, 241, 175, 77),
    const Color.fromARGB(255, 208, 91, 228),
    const Color.fromARGB(255, 226, 87, 133),
    const Color.fromARGB(255, 151, 94, 73),
    Colors.cyan,
    const Color.fromARGB(255, 92, 114, 238)
  ];
  Color selectedColor = Colors.red; // Default selected color

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
                  selectedColor = color; // Update the selected color
                });
                widget.onColorSelected(color); // Send selected color to parent
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: selectedColor == color ? 50 : 40,
                height: selectedColor == color ? 50 : 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color: selectedColor == color ? Colors.black : Colors.grey,
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
String colorToHex(Color color) {
  return '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}