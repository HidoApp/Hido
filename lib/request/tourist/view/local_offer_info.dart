import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class LocalOfferInfo extends StatefulWidget {
  const LocalOfferInfo(
      {super.key,
      required this.image,
      required this.name,
      required this.price,
      required this.rating,
      required this.tripNumber,
      required this.place});
  final String image;
  final String name;
  final int price, rating, tripNumber;

  final Place place;
  @override
  State<LocalOfferInfo> createState() => _LocalOfferInfoState();
}

class _LocalOfferInfoState extends State<LocalOfferInfo> {
  late double width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return DefaultTabController(
        animationDuration: Durations.long1,
        length: 3,
        child: Scaffold(
          body: Center(
            child: const TabBar(
              tabs: [
                Tab(
                  text: "About",
                ),
                Tab(
                  text: "Expert",
                ),
                Tab(
                  text: "Reviews",
                ),
              ],
            ),
          ),
        ));
  }
}
