import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

final _productImageUrl = <String>[
  'assets/images/product_detail1.png',
  'assets/images/product_detail2.png',
  'assets/images/product_detail3.png',
  'assets/images/product_detail4.png',
  'assets/images/product_detail5.png'
];
int _currentIndex = 0;
late bool isSoapFavorite;

class _ProductDetailsState extends State<ProductDetails> {
  int soapIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSoapFavorite = false;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(""),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                    height: height * 0.45,
                    viewportFraction: 1,
                    onPageChanged: (i, reason) {
                      setState(() {
                        _currentIndex = i;
                      });
                    }),
                itemCount: _productImageUrl.length,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      _productImageUrl[0],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  color: lightGreyColor.withOpacity(0.6),
                  width: width,
                  // height: height * 0.165,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "SAR 150.00",
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                      SizedBox(
                        height: AppUtil.rtlDirection(context) ? 0 : 5,
                      ),
                      CustomText(
                        text: AppUtil.rtlDirection(context)
                            ? 'صابونةاللافندر'
                            : 'Soap Lavender',
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      CustomText(
                        text: AppUtil.rtlDirection(context)
                            ? 'هي صابونية طبيعية مصنوعة من مزيج فريد من الحلبة واللافندر الطبيعيين، والذين يعرفون بفوائدهما المهدئة للبشرة. يتميز هذا الصابون بتركيبته الطبيعية التي تنظف البشرة بلطف وترطبها بشكل فعال، مع ترك رائحة اللافندر العطرية الرائعة على الجلد.'
                            : 'Wooden bedside table featuring a raised desi...',
                        color: almostGrey,
                        height: AppUtil.rtlDirection(context) ? 1.2 : 2,
                      ),
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  children: [
                    CustomText(
                      text: "productInformation".tr,
                      fontSize: 18,
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_sharp)
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: CustomText(
                  text: "youMightAlsoLike".tr,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: height * 0.3,
                padding: EdgeInsets.only(left: 15, right: 5),
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 16,
                    );
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      width: 135,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ProductDetails());
                            },
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Image.asset('assets/images/soap.png'),
                                Positioned(
                                  top: 6.56,
                                  left: 6.56,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: colorGreen,
                                    ),
                                    child: CustomText(
                                      text: 'new'.tr,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: AppUtil.rtlDirection(context)
                                    ? 'صابونةاللافندر'
                                    : 'Soap Lavender',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    soapIndex = index;
                                    isSoapFavorite = !isSoapFavorite;
                                  });
                                },
                                child: SvgPicture.asset(
                                    'assets/icons/${isSoapFavorite && soapIndex == index ? 'heart_filled' : 'heart_outlined'}.svg'),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          CustomText(
                            text: AppUtil.rtlDirection(context)
                                ? 'هي صابونية طبيعية مصنوعة من مزيج فريد من الحلبة واللافندر الطبيعيين، والذين يعرفون بفوائدهما المهدئة للبشرة. يتميز هذا الصابون بتركيبته الطبيعية التي تنظف البشرة بلطف وترطبها بشكل فعال، مع ترك رائحة اللافندر العطرية الرائعة على الجلد.'
                                : 'Wooden bedside table featuring a raised desi...',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            maxlines: 2,
                            color: almostGrey,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(colorGreen),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    fixedSize:
                        MaterialStateProperty.all(Size(width * 0.85, 58)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textDirection: TextDirection.ltr,
                    children: [
                      CustomText(
                        text: "addToBag".tr,
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/icons/add_to_bag.svg")
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ]),
            Positioned(
                top: height * 0.07,
                right:
                    AppUtil.rtlDirection(context) ? width * 0.85 : width * 0.07,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSoapFavorite = !isSoapFavorite;
                    });
                  },
                  child: Container(
                    height: 36,
                    width: 36,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)
                        //more than 50% of width makes circle
                        ),
                    child: SvgPicture.asset(
                      "assets/icons/${isSoapFavorite ? 'heart_filled' : 'heart_outlined'}.svg",
                    ),
                  ),
                )),
            Positioned(
              top: height * 0.4,
              left: width * 0.45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _productImageUrl.map((imageUrl) {
                  int index = _productImageUrl.indexOf(imageUrl);
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                      boxShadow: _currentIndex == index
                          ? [
                              BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 7,
                                  spreadRadius: 3)
                            ]
                          : [],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
