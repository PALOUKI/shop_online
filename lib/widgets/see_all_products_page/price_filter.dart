import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

import '../../core/core.dart';
import '../../models/Category.dart';

class PriceFilter extends StatefulWidget {
  final bool isLoading;
  final List<Category> categories;
  final Function() sortByLowPrice;
  final Function() sortByHighPrice;

  const PriceFilter({
    super.key,
    required this.isLoading,
    required this.categories,
    required this.sortByLowPrice,
    required this.sortByHighPrice,
  });

  @override
  State<PriceFilter> createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  String _selectedSort = '';

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) => Container(
            width: 100,
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ).redacted(context: context, redact: true),
        ),
      ),
    )
        : widget.categories.isEmpty
        ? Center(
        child: Image.asset(AssetsConstants.noInternet, height: 80, width: 80,)
    )
        : Container(
      height: getHeight(45),
      margin: EdgeInsets.only(top: getHeight(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_upward_outlined,
                    color: _selectedSort == 'lowToHigh' ? Colors.white : Colors.blue,
                  ),
                  SizedBox(width: getSize(8)),
                  Text(
                    "croissant",
                    style: AppTextStyles.subtitle2.copyWith(
                      color: _selectedSort == 'lowToHigh' ? Colors.grey[100] : Colors.blue,
                    ),
                  )
                ],
              ),
              selected: _selectedSort == 'lowToHigh',
              onSelected: (bool selected) {
                if (selected) {
                  widget.sortByLowPrice();
                  setState(() {
                    _selectedSort = 'lowToHigh';
                  });
                }
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(getSize(20)),
                side: const BorderSide(color: Colors.white),
              ),
              padding: EdgeInsets.symmetric(horizontal: getWidth(10), vertical: getHeight(10)),
              elevation: 0,
              pressElevation: 0,
            ),
          ),
          SizedBox(width: getWidth(10)), // Ajout d'un espacement entre les puces
          Expanded(
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_downward_outlined,
                    color: _selectedSort == 'highToLow' ? Colors.white : Colors.blue,
                  ),
                  SizedBox(width: getSize(8)),
                  Text(
                    "décroissant",
                    style: AppTextStyles.subtitle2.copyWith(
                      color: _selectedSort == 'highToLow' ? Colors.grey[100] : Colors.blue,
                    ),
                  )
                ],
              ),
              selected: _selectedSort == 'highToLow',
              onSelected: (bool selected) {
                if (selected) {
                  widget.sortByHighPrice();
                  setState(() {
                    _selectedSort = 'highToLow';
                  });
                }
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(getSize(20)),
                side: const BorderSide(color: Colors.white),
              ),
              padding: EdgeInsets.symmetric(horizontal: getWidth(10), vertical: getHeight(10)),
              elevation: 0,
              pressElevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
