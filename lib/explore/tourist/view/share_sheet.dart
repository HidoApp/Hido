import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ShareSheet extends StatefulWidget {
  const ShareSheet({Key? key, this.fromAjwady = true}) : super(key: key);
  final bool fromAjwady;

  @override
  State<ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<ShareSheet> {
  late double width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: GestureDetector(
        child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.45,
            maxChildSize: 1,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                    color: widget.fromAjwady ? lightBlack : Colors.white,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                padding: const EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.only(
                      // bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: height * 0.03,
                      left: width * 0.03,
                      right: width * 0.03,
                      bottom: height * 0.03),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                            alignment: AppUtil.rtlDirection2(context)
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: CustomText(
                              text: "shareWithFriends".tr,
                              color: widget.fromAjwady
                                  ? Colors.white
                                  : Colors.black,
                              textDirection: AppUtil.rtlDirection2(context)
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            )),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(7),
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                        color: lightGreyColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: SvgPicture.asset(
                                      "assets/icons/copyLink.svg",
                                    )),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomText(
                                  text: "copyLink".tr,
                                  fontSize: 12,
                                  color: widget.fromAjwady
                                      ? Colors.white
                                      : Colors.black,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SvgPicture.asset("assets/icons/whats_icon.svg"),
                                CustomText(
                                  text: "whatsApp".tr,
                                  fontSize: 12,
                                  color: widget.fromAjwady
                                      ? Colors.white
                                      : Colors.black,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SvgPicture.asset("assets/icons/facebook.svg"),
                                CustomText(
                                  text: "facebook".tr,
                                  fontSize: 12,
                                  color: widget.fromAjwady
                                      ? Colors.white
                                      : Colors.black,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SvgPicture.asset("assets/icons/msn_icon.svg"),
                                CustomText(
                                  text: "messenger".tr,
                                  fontSize: 12,
                                  color: widget.fromAjwady
                                      ? Colors.white
                                      : Colors.black,
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SvgPicture.asset(
                                    "assets/icons/twitter_icon.svg"),
                                CustomText(
                                  text: "twitter".tr,
                                  fontSize: 12,
                                  color: widget.fromAjwady
                                      ? Colors.white
                                      : Colors.black,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SvgPicture.asset("assets/icons/instgram.svg"),
                                CustomText(
                                  text: "instagram".tr,
                                  fontSize: 12,
                                  color: widget.fromAjwady
                                      ? Colors.white
                                      : Colors.black,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SvgPicture.asset("assets/icons/skype_icon.svg"),
                                CustomText(
                                  text: "skype".tr,
                                  fontSize: 12,
                                  color: widget.fromAjwady
                                      ? Colors.white
                                      : Colors.black,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SvgPicture.asset(
                                    "assets/icons/message_icon.svg"),
                                CustomText(
                                  text: "massages".tr,
                                  fontSize: 12,
                                  color: widget.fromAjwady
                                      ? Colors.white
                                      : Colors.black,
                                )
                              ],
                            )
                          ],
                        ),
                        const Spacer(),
                        Container(
                          height: 60,
                          width: 270,
                          decoration: BoxDecoration(
                            color: lightGreyColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: CustomText(
                            text: "cancel".tr.toUpperCase(),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          )),
                        )
                      ]),
                ),
              );
            }),
      ),
    );
  }
}
