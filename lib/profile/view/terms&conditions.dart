import 'package:ajwad_v4/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../widgets/custom_app_bar.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key, this.fromAjwady = true})
      : super(key: key);

  @override
  State<TermsAndConditions> createState() => _helpAndFAQsScreenState();

  final bool fromAjwady;
}

var FAQs = [];

class _helpAndFAQsScreenState extends State<TermsAndConditions> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FAQs = [
      {
        'index': 1,
        'question': 'Lorem ipsum dolor sit amet consectetur. Sagittis id.',
        'answer':
            'Lorem ipsum dolor sit amet consectetur. In augue ipsum tellus ultrices. Ac pharetra ultrices consectetur consequat tellus massa. Nec aliquam cras sagittis duis sed euismod arcu hac. Ornare amet ligula ornare lacus aliquam aenean. Eu lacus imperdiet urna amet congue adipiscing. Faucibus magna nisl ullamcorper in facilisis consequat aliquam.\nId placerat dui habitasse quisque nisl tincidunt facilisi mi id. Dictum elit velit.',
        'floded': true,
      },
      {
        'index': 2,
        'question': 'Lorem ipsum dolor sit amet consectetur. Sagittis id.',
        'answer':
            'Lorem ipsum dolor sit amet consectetur. In augue ipsum tellus ultrices. Ac pharetra ultrices consectetur consequat tellus massa. Nec aliquam cras sagittis duis sed euismod arcu hac. Ornare amet ligula ornare lacus aliquam aenean. Eu lacus imperdiet urna amet congue adipiscing. Faucibus magna nisl ullamcorper in facilisis consequat aliquam.\nId placerat dui habitasse quisque nisl tincidunt facilisi mi id. Dictum elit velit.',
        'floded': true,
      },
      {
        'index': 3,
        'question': 'Lorem ipsum dolor sit amet consectetur. Sagittis id.',
        'answer':
            'Lorem ipsum dolor sit amet consectetur. In augue ipsum tellus ultrices. Ac pharetra ultrices consectetur consequat tellus massa. Nec aliquam cras sagittis duis sed euismod arcu hac. Ornare amet ligula ornare lacus aliquam aenean. Eu lacus imperdiet urna amet congue adipiscing. Faucibus magna nisl ullamcorper in facilisis consequat aliquam.\nId placerat dui habitasse quisque nisl tincidunt facilisi mi id. Dictum elit velit.',
        'floded': true,
      },
      {
        'index': 4,
        'question': 'Lorem ipsum dolor sit amet consectetur. Sagittis id.',
        'answer':
            'Lorem ipsum dolor sit amet consectetur. In augue ipsum tellus ultrices. Ac pharetra ultrices consectetur consequat tellus massa. Nec aliquam cras sagittis duis sed euismod arcu hac. Ornare amet ligula ornare lacus aliquam aenean. Eu lacus imperdiet urna amet congue adipiscing. Faucibus magna nisl ullamcorper in facilisis consequat aliquam.\nId placerat dui habitasse quisque nisl tincidunt facilisi mi id. Dictum elit velit.',
        'floded': true,
      },
      {
        'index': 5,
        'question': 'Lorem ipsum dolor sit amet consectetur. Sagittis id.',
        'answer':
            'Lorem ipsum dolor sit amet consectetur. In augue ipsum tellus ultrices. Ac pharetra ultrices consectetur consequat tellus massa. Nec aliquam cras sagittis duis sed euismod arcu hac. Ornare amet ligula ornare lacus aliquam aenean. Eu lacus imperdiet urna amet congue adipiscing. Faucibus magna nisl ullamcorper in facilisis consequat aliquam.\nId placerat dui habitasse quisque nisl tincidunt facilisi mi id. Dictum elit velit.',
        'floded': true,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          "terms".tr,
          color: black,
        ),
        body: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color.fromARGB(0, 255, 254, 254))
            ..loadRequest(Uri.parse('https://www.hido.app/terms-conditions')),
        ));
  }
}
// Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 30,
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 30),
//             height: height * 0.8,
//             child: ListView.separated(
//               separatorBuilder: (BuildContext context, int index) {
//                 return const SizedBox(
//                   height: 25,
//                 );
//               },
//               itemCount: FAQs.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Column(
//                   children: [
//                     Row(
//                       children: [
//                         CustomText(
//                           text: FAQs[index]['index'].toString().length == 1
//                               ? "0" + FAQs[index]['index'].toString()
//                               : FAQs[index]['index'].toString(),
//                           fontStyle: FontStyle.italic,
//                           color: widget.fromAjwady ? Colors.white : black,
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           child: CustomText(
//                             text: FAQs[index]['question'].toString(),
//                             maxlines: 10,
//                             color: widget.fromAjwady ? Colors.white : black,
//                           ),
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               FAQs[index]['floded'] = !(FAQs[index]['floded']);
//                                
//                                
//                             });
//                           },
//                           child: Container(
//                             height: 33,
//                             width: 33,
//                             decoration: BoxDecoration(
//                                 color: colorGreen,
//                                 borderRadius: !AppUtil.rtlDirection(context)
//                                     ? BorderRadius.only(
//                                         topRight: Radius.circular(5),
//                                         bottomRight: Radius.circular(5))
//                                     : BorderRadius.only(
//                                         topLeft: Radius.circular(5),
//                                         bottomLeft: Radius.circular(5))),
//                             child: Icon(
//                               FAQs[index]['floded'] == true
//                                   ? Icons.add
//                                   : Icons.horizontal_rule,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     FAQs[index]['floded'] != false
//                         ? Container()
//                         : Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 10),
//                             child: CustomText(
//                                 color: widget.fromAjwady ? Colors.white : black,
//                                 fontSize: 10,
//                                 text: FAQs[index]['answer'].toString()),
//                           )
//                   ],
//                 );
//               },
//             ),
//           )
//         ],
//       ),