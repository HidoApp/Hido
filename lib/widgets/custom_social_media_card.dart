import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomSocialMediaCard extends StatelessWidget {
  const CustomSocialMediaCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onCardTap,
  });

  final String title;
  final String imagePath;
  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 50,
      ),
      child: Card(
        color: Colors.white,
        // shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          alignment: Alignment.center,
          child: InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            onTap: onCardTap,
            // Add image & text
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
               
                CustomText(
                  text: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  color: const Color(0xFF2C2828),
                ), 
                
                 const SizedBox(
                  width: 10,
                ),
                Ink.image(
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                    image: AssetImage(imagePath)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
