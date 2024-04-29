import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/request/widgets/expert_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpertScreen extends StatefulWidget {
  const ExpertScreen({
    super.key,
  });
// final ProfileController profileController;
  @override
  State<ExpertScreen> createState() => _ExpertScreenState();
}

class _ExpertScreenState extends State<ExpertScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: const [
        ExpertCard(
          image: "",
          location: "ryadh",
          rating: 5,
          title: "shagra",
        )
      ],
    );
  }
}
