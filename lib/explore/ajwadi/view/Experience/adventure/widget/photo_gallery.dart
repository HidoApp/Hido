import 'dart:io';

import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryPage extends StatefulWidget {
  PhotoGalleryPage({
    Key? key,
    required this.selectedImages,
  }) : super(key: key);

  List<String> selectedImages;

  @override
  _PhotoGalleryPageState createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
  List<XFile> _selectedImages = [];
  final AdventureController _adventureController =
      Get.put(AdventureController());
      
  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages.map((path) => XFile(path)).toList();
  }

  Future<void> _showImagePickerOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return ImagePickerBottomSheet(
          onImagesSelected: (images) {
            setState(() {
              _selectedImages = images;
              widget.selectedImages.addAll(images.map((file) => file.path));
            });
          },
        );
      },
    );
  }

  
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final List<XFile>? pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        setState(() {
          _selectedImages.addAll(pickedImages);
          widget.selectedImages.addAll(pickedImages.map((file) => file.path));
        });
        // Upload each picked image
        //   for (var pickedFile in pickedImages) {
        //     if (AppUtil.isImageValidate(await pickedFile.length())) {
        //       final image = await _hospitalityController.uploadProfileImages(
        //         file: File(pickedFile.path),
        //         uploadOrUpdate: "upload",
        //         context: context,
        //       );

        //       if (image != null) {
        //         setState(() {
        //           widget.selectedImages.add(image.filePath);
        //           print('yhis kjhgfghjkjhgfghnm') ;// Add to newProfileImages list
        //           print(image.filePath);
        //         });
        //       }
        //     }
        //   }
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> _showImageOptions(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          width: 390,
          height: 184,
          padding: const EdgeInsets.only(
            top: 16,
            left: 24,
            right: 24,
            bottom: 44,
          ),
          decoration: ShapeDecoration(
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
                        final selectedImage = _selectedImages.removeAt(index);
                        _selectedImages.insert(0, selectedImage);

                        final selectedImagePath =
                            widget.selectedImages.removeAt(index);
                        widget.selectedImages.insert(0, selectedImagePath);
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        color: Color(0xFF37B268),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'makeCover'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                        _selectedImages.removeAt(index);
                        widget.selectedImages.removeAt(index);
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
                          side:
                              BorderSide(width: 1.5, color: Color(0xFFDC362E)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Delete'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _selectedImages.isEmpty
            ? Center(
                child: DottedBorder(
                  strokeWidth: 1,
                  color: Color(0xFFDCDCE0),
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  dashPattern: [5, 5],
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
                                color: Color(0xFFECF9F1),
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
                            color: Color(0xFF070708),
                            fontSize: 15,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: 'uploadLimit'.tr,
                            textAlign: TextAlign.center,
                            color: Color(0xFFB9B8C1),
                            fontSize: 11,
                            fontFamily: 'SF Pro',
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
                          image: FileImage(File(_selectedImages![0].path)),
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
                                child: Text(
                                  'Coverphoto'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: 'SF Pro',
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
                  SizedBox(height: 16),
                  Container(
                    height: 360,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: (_selectedImages!.length - 1) + 3,
                      itemBuilder: (context, index) {
                        if (index < _selectedImages!.length - 1) {
                          return GestureDetector(
                            onTap: () => _showImageOptions(context, index + 1),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(
                                      File(_selectedImages![index + 1].path)),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        } else if (index == _selectedImages!.length - 1) {
                          return GestureDetector(
                            onTap: () => _pickImage(ImageSource.gallery),
                            child: DottedBorder(
                              strokeWidth: 1,
                              color: Color(0xFFDCDCE0),
                              borderType: BorderType.RRect,
                              radius: Radius.circular(12),
                              dashPattern: [5, 5],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 24,
                                      color: Color(0xFFB9B8C1),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Addmore'.tr,
                                      style: TextStyle(
                                        color: Color(0xFFB9B8C1),
                                        fontSize: 11,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (index == _selectedImages!.length) {
                          return GestureDetector(
                            onTap: () => _pickImage(ImageSource.camera),
                            child: DottedBorder(
                              strokeWidth: 1,
                              color: Color(0xFFDCDCE0),
                              borderType: BorderType.RRect,
                              radius: Radius.circular(12),
                              dashPattern: [5, 5],
                              child: Center(
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
    );
  }
}

class ImagePickerBottomSheet extends StatefulWidget {
  final Function(List<XFile>) onImagesSelected;

  ImagePickerBottomSheet({required this.onImagesSelected});

  @override
  _ImagePickerBottomSheetState createState() => _ImagePickerBottomSheetState();
}

class _ImagePickerBottomSheetState extends State<ImagePickerBottomSheet> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        setState(() {
          _selectedImages = pickedImages;
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _selectedImages =
              _selectedImages != null ? [..._selectedImages!, photo] : [photo];
        });
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

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
      decoration: BoxDecoration(
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
                Text('Choosephotos'.tr,
                    style: TextStyle(
                      color: Color(0xFF070708),
                      fontSize: 22,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w500,
                    )),
                IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: _takePhoto,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            // fit: FlexFit.loose,
            child: _selectedImages == null
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                Navigator.of(context).pop();
              },
              title: 'add'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
