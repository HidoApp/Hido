import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';

class StackWidgets extends StatelessWidget {
  final List<dynamic> items;
  final double size;
  const StackWidgets({Key? key, required this.items, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allItems = items.asMap().map((index,item) {
      final shift = size - 10 ;
      final value = Container(
        height: size,width: size,
        margin: AppUtil.rtlDirection(context) ?  EdgeInsets.only(right: shift * index):EdgeInsets.only(left: shift * index),
        child: item ,
      );
      return MapEntry(index, value);
    }).values.toList();
    return Stack(
      children: allItems,
    );
  }
}
