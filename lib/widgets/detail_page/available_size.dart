import 'package:flutter/material.dart';
import 'package:shop_online/core/appConfigSize.dart';
import 'package:shop_online/core/appStyles.dart';
class AvailableSize extends StatefulWidget {

  final String size;
  const AvailableSize({super.key, required this.size});

  @override
  State<AvailableSize> createState() => _AvailableSizeState();
}

class _AvailableSizeState extends State<AvailableSize> {

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    AppConfigSize.init(context);
    return GestureDetector(
      onTap: (){
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: getHeight(15), top: getHeight(10)),
        height: 30,
        width: 45,
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.transparent,
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: Text(
            widget.size,
            style: AppTextStyles.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
