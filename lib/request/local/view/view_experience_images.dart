import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ViewImages extends StatefulWidget {
  final List<String> tripImageUrl;
  final bool fromNetwork;
  final String? Type;
  const ViewImages(
      {Key? key,
      required this.tripImageUrl,
      this.fromNetwork = false,
      this.Type})
      : super(key: key);

  @override
  State<ViewImages> createState() => _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages> {
  late final _ExperienceController;

  @override
  void initState() {
    super.initState();
    _ExperienceController = _initializeController(widget.Type ?? '');
  }

  dynamic _initializeController(String type) {
    if (type == 'event') {
      return Get.put(EventController());
    } else if (type == 'hospitality') {
      return Get.put(HospitalityController());
    } else {
      return Get.put(AdventureController());
    }
  }

  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final List<XFile> pickedImages = await _picker.pickMultiImage();

      if (pickedImages.isNotEmpty) {
        List<XFile> validImages = [];

        for (final image in pickedImages) {
          final String fileExtension = image.path.split('.').last.toLowerCase();

          final bool imageSizeValidate =
              AppUtil.isImageValidate(await image.length());
          final bool imageFormatValidate =
              AppUtil.isImageFormatValidate(fileExtension);

          if (imageSizeValidate && imageFormatValidate) {
            validImages.add(image);
          } else {
            if (!imageSizeValidate) {
              if (context.mounted) {
                AppUtil.errorToast(context, 'imageValidSize'.tr);
              } else {
                AppUtil.errorToast(context, 'uploadError'.tr);
              }
            }
          }
        }

        if (validImages.isNotEmpty) {
          setState(() {
            _ExperienceController.images.addAll(validImages);
          });
          log("Valid images added: ${validImages.length}");
        }
      }
    } catch (e) {
      log("Image picking error: $e");
      if (context.mounted) {
        AppUtil.errorToast(context, e.toString());
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);
      if (photo != null) {
        if (AppUtil.isImageValidate(await photo.length())) {
          setState(() {
            _selectedImages =
                _selectedImages != null ? [..._selectedImages, photo] : [photo];
            _ExperienceController.images.add(photo);
          });
        } else {
          AppUtil.errorToast(context, 'imageValidSize'.tr);
        }
      }
    } catch (e) {}
  }

  void _deleteImage(int index) {
    setState(() {
    

      _ExperienceController.images.removeAt(index);
    });
  }

  void _insetRemoveImage(int index) {
    setState(() {
     

      final removedImage2 = _ExperienceController.images.removeAt(index);
      _ExperienceController.images.insert(0, removedImage2);
    });
  }

  Future<void> _showImageOptions(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 16,
            left: 24,
            right: 24,
            bottom: 44,
          ),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 65,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Move the selected image to the first position to set it as cover image
                        _insetRemoveImage(index);
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF37B268),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'makeCover'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'HT Rakik',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _deleteImage(index);
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1.5, color: Color(0xFFDC362E)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Delete'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFDC362E),
                          fontSize: 17,
                          fontFamily: 'HT Rakik',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("images".tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                child: Container(
                  width: double.infinity,
                  height: 186,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _ExperienceController.images == null ||
                              _ExperienceController.images.isEmpty
                          ? const AssetImage('assets/images/Placeholder.png')
                          : _ExperienceController.images[0] is String &&
                                  Uri.parse(_ExperienceController.images[0])
                                      .isAbsolute
                              ? NetworkImage(_ExperienceController.images[0])
                              : FileImage(File(
                                  (_ExperienceController.images[0] as XFile)
                                      .path)) as ImageProvider,

                      fit: BoxFit.cover,
                      //image:
                      // _ExperienceController.images == null ||
                      //         _ExperienceController.images.isEmpty
                      //     ? const AssetImage('assets/images/Placeholder.png')
                      //     : _ExperienceController.images[0] is String &&
                      //             Uri.parse(_ExperienceController.images[0])
                      //                 .isAbsolute
                      //         ? CachedNetworkImageProvider(
                      //             errorListener: (p0) => Image.asset(
                      //                 'assets/images/Placeholder.png'),
                      //             _ExperienceController.images[0])
                      //         : FileImage(File(
                      //             (_ExperienceController.images[0] as XFile)
                      //                 .path)) as ImageProvider,
                      // fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12, right: 12, left: 12), // Add padding here
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: ShapeDecoration(
                              color:
                                  Colors.white.withOpacity(0.20000000298023224),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Coverphoto'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 360,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: (_ExperienceController.images!.length - 1) + 3,
                  itemBuilder: (context, index) {
                    if (index < _ExperienceController.images!.length - 1) {
                      final imageItem = _ExperienceController.images[index + 1];
                      bool isNetworkImage = imageItem is String &&
                          Uri.parse(imageItem).isAbsolute;

                      return GestureDetector(
                        onTap: () => _showImageOptions(context, index + 1),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: isNetworkImage
                                  ? NetworkImage(imageItem)
                                  : FileImage(File((imageItem as XFile).path))
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            // image:
                            //  DecorationImage(
                            //   image: isNetworkImage
                            //       ? CachedNetworkImageProvider(
                            //           errorListener: (p0) => Image.asset(
                            //               'assets/images/Placeholder.png'),
                            //           imageItem)
                            //       : FileImage(File((imageItem as XFile).path))
                            //           as ImageProvider,
                            //   fit: BoxFit.cover,
                            // ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    } else if (index ==
                        _ExperienceController.images.length - 1) {
                      return GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: DottedBorder(
                          strokeWidth: 1,
                          color: const Color(0xFFDCDCE0),
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          dashPattern: const [5, 5],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 24,
                                  color: Color(0xFFB9B8C1),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Addmore'.tr,
                                  style: TextStyle(
                                    color: const Color(0xFFB9B8C1),
                                    fontSize: 11,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (index == _ExperienceController.images.length) {
                      return GestureDetector(
                        onTap: () => _takePhoto(),
                        child: DottedBorder(
                          strokeWidth: 1,
                          color: const Color(0xFFDCDCE0),
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          dashPattern: const [5, 5],
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined,
                                    size: 32, color: Color(0xFFB9B8C1)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Container(); // Placeholder for the last item (will not be displayed)
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> images() {
    var items = widget.tripImageUrl
        .map(
          (url) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              url,
              fit: BoxFit.fill,
            ),
          ),
        )
        .toList();
    return items;
  }

  List<Widget> imagesFromNetWork() {
    var items = widget.tripImageUrl
        .map((url) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.network(
              url,
              fit: BoxFit.fill,
            )))
        .toList();
    return items;
  }
}
