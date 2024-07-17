import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';

class WalletDetailsCard extends StatelessWidget {

  const WalletDetailsCard({Key? key,
  this.color,
  this.title,
  this.icon,
  this.date
  }) : super(key: key);

  final String? title;
  final String? icon;
  final Color? color;
  final String? date;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3 June 2024',
          style: TextStyle(
            color: Color(0xFF070708),
            fontSize: 13,
            fontFamily:AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0xFFE2E2E2)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: Color(0xFFE9EBF6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: Icon(Icons.account_balance_wallet,
                        size: 18, color: Color(0xFF070708)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bank Transfer',
                    style: TextStyle(
                      color: Color(0xFF070708),
                      fontSize: 13,
                      fontFamily:AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            '-1,400.00',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF070708),
                              fontSize: 15,
                              fontFamily:AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'SAR',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF070708),
                              fontSize: 11,
                             fontFamily:AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '00.00',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFFB9B8C1),
                              fontSize: 12,
                              fontFamily:AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
