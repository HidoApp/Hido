import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OfflineRequest extends StatelessWidget {
  const OfflineRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/offline.svg'),
          CustomText(
            text: "Offline",
            color: almostGrey,
            fontSize: 17,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: CustomText(
              text:
                  'You are currently offline and won‘t be receiving any tour requests',
              color: almostGrey,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
