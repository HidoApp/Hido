import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryPage extends StatefulWidget {
  const PhotoGalleryPage({
    Key? key,
  }) : super(key: key);

  // List<String> selectedImages;

  @override
  _PhotoGalleryPageState createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  final EventController _EventrController = Get.put(EventController());

  @override
  void initState() {
    super.initState();
    // _selectedImages = _EventrController.selectedImages.map((path) => XFile(path)).toList();
    //  _selectedImages = _EventrController.selectedImages;
  }

  Future<void> _showImagePickerOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return ImagePickerBottomSheet(
          onImagesSelected: (images) {
            setState(() {
              _EventrController.selectedImages.addAll(images);
            });
          },
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final List<XFile> pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        if (AppUtil.isImageValidate(pickedImages.length)) {
          setState(() {
            _EventrController.selectedImages.addAll(pickedImages);
          });
        } else {
          AppUtil.errorToast(context, 'imageValidSize'.tr);
        }
      }
    } catch (e) {}
  }

  // Future<void> _pickImage(ImageSource source) async {
  //   try {
  //     final List<XFile> pickedImages = await _picker.pickMultiImage();

  //     if (pickedImages.isNotEmpty) {
  //       List<XFile> validImages = [];

  //       for (final image in pickedImages) {
  //         final String fileExtension = image.path.split('.').last.toLowerCase();

  //         final bool imageSizeValidate =
  //             AppUtil.isImageValidate(await image.length());
  //         final bool imageFormatValidate =
  //             AppUtil.isImageFormatValidate(fileExtension);

  //         if (imageSizeValidate && imageFormatValidate) {
  //           validImages.add(image);
  //         } else {
  //           if (!imageSizeValidate) {
  //             if (context.mounted) {
  //               AppUtil.errorToast(context, 'imageValidSize'.tr);
  //             } else {
  //               AppUtil.errorToast(context, 'uploadError'.tr);
  //             }
  //           }
  //         }
  //       }

  //       if (validImages.isNotEmpty) {
  //         setState(() {
  //           _EventrController.selectedImages.addAll(validImages);
  //         });
  //         log("Valid images added: ${validImages.length}");
  //       }
  //     }
  //   } catch (e) {
  //     log("Image picking error: $e");
  //     if (context.mounted) {
  //       AppUtil.errorToast(context, e.toString());
  //     }
  //   }
  // }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);
      if (photo != null) {
        if (AppUtil.isImageValidate(await photo.length())) {
          setState(() {
            // _selectedImages =
            //     _selectedImages != null ? [..._selectedImages!, photo] : [photo];
            _EventrController.selectedImages.add(photo);
          });
        } else {
          AppUtil.errorToast(context, 'imageValidSize'.tr);
        }
      }
    } catch (e) {}
  }

  // Future<void> _takePhoto() async {
  //   try {
  //     final XFile? photo =
  //         await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);
  //     if (photo != null) {
  //       final String fileExtension = photo.path.split('.').last.toLowerCase();

  //       final bool imageSizeValidate =
  //           AppUtil.isImageValidate(await photo.length());
  //       final bool imageFormatValidate =
  //           AppUtil.isImageFormatValidate(fileExtension);
  //       if (imageSizeValidate && imageFormatValidate) {
  //         setState(() {
  //           _EventrController.selectedImages.add(photo);
  //         });
  //       } else {
  //         if (!imageSizeValidate) {
  //           if (context.mounted) {
  //             AppUtil.errorToast(context, 'imageValidSize'.tr);
  //           } else {
  //             AppUtil.errorToast(context, 'uploadError'.tr);
  //           }
  //         }
  //       }
  //     }
  //   } catch (e) {}
  // }

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

                        final selectedImagePath =
                            _EventrController.selectedImages.removeAt(index);
                        _EventrController.selectedImages
                            .insert(0, selectedImagePath);
                      });
                      Get.back();
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
                      child: CustomText(
                        text: 'makeCover'.tr,
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _EventrController.selectedImages.removeAt(index);
                      });
                      Get.back();
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
                      child: CustomText(
                        text: 'Delete'.tr,
                        textAlign: TextAlign.center,
                        color: const Color(0xFFDC362E),
                        fontSize: 17,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
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
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _EventrController.selectedImages.isEmpty
              ? Center(
                  child: DottedBorder(
                    strokeWidth: 1,
                    color: const Color(0xFFDCDCE0),
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [5, 5],
                    child: Container(
                        width: 390,
                        // height: 599,
                        height: 561,
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _showImagePickerOptions(context),
                              child: Container(
                                width: 42,
                                height: 42,
                                padding: const EdgeInsets.all(8),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFECF9F1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9.33),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                    'assets/icons/UploadIcon.svg'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            CustomText(
                              text: 'UploadPhotos'.tr,
                              color: const Color(0xFF070708),
                              fontSize: 15,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                            const SizedBox(height: 4),
                            CustomText(
                              text: 'uploadLimit'.tr,
                              textAlign: TextAlign.center,
                              color: const Color(0xFFB9B8C1),
                              fontSize: 11,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ],
                        )),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      child: Container(
                        width: double.infinity,
                        height: 186,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(
                                File(_EventrController.selectedImages[0].path)),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12,
                                    right: 12,
                                    left: 12), // Add padding here
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: Colors.white
                                        .withOpacity(0.20000000298023224),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: CustomText(
                                    text: 'Coverphoto'.tr,
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 360,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount:
                            (_EventrController.selectedImages.length - 1) + 3,
                        itemBuilder: (context, index) {
                          if (index <
                              _EventrController.selectedImages.length - 1) {
                            return GestureDetector(
                              onTap: () =>
                                  _showImageOptions(context, index + 1),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(_EventrController
                                        .selectedImages[index + 1].path)),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          } else if (index ==
                              _EventrController.selectedImages.length - 1) {
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
                                      CustomText(
                                        text: 'Addmore'.tr,
                                        color: const Color(0xFFB9B8C1),
                                        fontSize: 11,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (index ==
                              _EventrController.selectedImages.length) {
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
        ],
      ),
    );
  }
}

class ImagePickerBottomSheet extends StatefulWidget {
  final Function(List<XFile>) onImagesSelected;

  const ImagePickerBottomSheet({super.key, required this.onImagesSelected});

  @override
  _ImagePickerBottomSheetState createState() => _ImagePickerBottomSheetState();
}

class _ImagePickerBottomSheetState extends State<ImagePickerBottomSheet> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        if (AppUtil.isImageValidate(pickedImages.length)) {
          setState(() {
            _selectedImages = pickedImages;
          });
        } else {
          AppUtil.errorToast(context, 'imageValidSize'.tr);
        }
      }
    } catch (e) {}
  }

  // Future<void> _pickImages() async {
  //   try {
  //     final List<XFile> pickedImages = await _picker.pickMultiImage();

  //     if (pickedImages.isNotEmpty) {
  //       List<XFile> validImages = [];

  //       for (final image in pickedImages) {
  //         final String fileExtension = image.path.split('.').last.toLowerCase();

  //         final bool imageSizeValidate =
  //             AppUtil.isImageValidate(await image.length());
  //         final bool imageFormatValidate =
  //             AppUtil.isImageFormatValidate(fileExtension);

  //         if (imageSizeValidate && imageFormatValidate) {
  //           validImages.add(image);
  //         } else {
  //           if (!imageSizeValidate) {
  //             if (context.mounted) {
  //               AppUtil.errorToast(context, 'imageValidSize'.tr);
  //             } else {
  //               AppUtil.errorToast(context, 'uploadError'.tr);
  //             }
  //           }
  //         }
  //       }

  //       if (validImages.isNotEmpty) {
  //         setState(() {
  //           _selectedImages = [...validImages];
  //         });
  //         log("Valid images added: ${validImages.length}");
  //       }
  //     }
  //   } catch (e) {
  //     log("Image picking error: $e");
  //     if (context.mounted) {
  //       AppUtil.errorToast(context, e.toString());
  //     }
  //   }
  // }
  Future<void> _takePhoto() async {
    try {
      final XFile? photo =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);
      if (photo != null) {
        if (AppUtil.isImageValidate(await photo.length())) {
          setState(() {
            _selectedImages = _selectedImages != null
                ? [..._selectedImages!, photo]
                : [photo];
          });
        } else {
          AppUtil.errorToast(context, 'imageValidSize'.tr);
        }
      }
    } catch (e) {}
  }
  // Future<void> _takePhoto() async {
  //   try {
  //     final XFile? photo =
  //         await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);

  //     if (photo != null) {
  //       // for (final image in pickedImages) {
  //       final String fileExtension = photo.path.split('.').last.toLowerCase();

  //       final bool imageSizeValidate =
  //           AppUtil.isImageValidate(await photo.length());
  //       final bool imageFormatValidate =
  //           AppUtil.isImageFormatValidate(fileExtension);

  //       if (imageSizeValidate && imageFormatValidate) {
  //         setState(() {
  //           _selectedImages = _selectedImages != null
  //               ? [..._selectedImages!, photo]
  //               : [photo];
  //         });
  //       } else {
  //         if (!imageSizeValidate) {
  //           if (context.mounted) {
  //             AppUtil.errorToast(context, 'imageValidSize'.tr);
  //           } else {
  //             AppUtil.errorToast(context, 'uploadError'.tr);
  //           }
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     log("Image picking error: $e");
  //     if (context.mounted) {
  //       AppUtil.errorToast(context, e.toString());
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _pickImages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.8, // Set the height to 80% of the screen height

      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Choosephotos'.tr,
                  color: const Color(0xFF070708),
                  fontSize: 22,
                  fontFamily: 'HT Rakik',
                  fontWeight: FontWeight.w500,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: _takePhoto,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            // fit: FlexFit.loose,
            child: _selectedImages == null
                ? const Center(child: CircularProgressIndicator.adaptive())
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: _selectedImages!.length,
                    itemBuilder: (context, index) {
                      return Image.file(
                        File(_selectedImages![index].path),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomButton(
              onPressed: () {
                widget.onImagesSelected(_selectedImages ?? []);
                Get.back();
              },
              title: 'add'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
