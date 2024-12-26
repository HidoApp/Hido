
import 'package:ajwad_v4/services/view/widgets/city_filter.dart';
import 'package:ajwad_v4/services/view/widgets/sort_filter.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      padding: EdgeInsets.only(
        top: width * 0.04,
        left: width * 0.061,
        right: width * 0.061,
        bottom: width * 0.082,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BottomSheetIndicator(),
          SizedBox(
            height: 28,
          ),
          SortFilter(),
          SizedBox(
            height: 10,
          ),
          CityFilter()
        ],
      ),
    );
  }
}
