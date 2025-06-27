import 'package:flutter/material.dart';

class AvailableColor extends StatefulWidget {
  final Color color;
  const AvailableColor({super.key, required this.color});

  @override
  State<AvailableColor> createState() => _AvailableColorState();
}

class _AvailableColorState extends State<AvailableColor> {

  late bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: (){
          setState(() {
            isSelected = !isSelected;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 2),
            shape: BoxShape.circle
          ),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: widget.color,
          ),
        ),
      );
  }
}
