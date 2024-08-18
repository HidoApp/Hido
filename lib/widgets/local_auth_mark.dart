import 'package:ajwad_v4/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocalAuthMark extends StatelessWidget {
  const LocalAuthMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.051,
      width: MediaQuery.of(context).size.width * 0.051,
      decoration:
          const BoxDecoration(color: colorGreen, shape: BoxShape.circle),
      child: RepaintBoundary(
        child: SvgPicture.asset('assets/icons/local_auth.svg'),
      ),
    );
  }
}
