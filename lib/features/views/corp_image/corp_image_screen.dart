import 'dart:io';
import 'package:flutter/material.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/widgets.dart';

class CropImageScreen extends StatefulWidget {
  final File initialImage;
  final void Function(File) onCropped;
  final double? height;

  const CropImageScreen({
    required this.initialImage,
    required this.onCropped,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final CustomImageCropController _cropController = CustomImageCropController();

  @override
  void dispose() {
    _cropController.dispose();
    super.dispose();
  }

  Future<void> _cropImage() async {
    final cropped = await _cropController.onCropImage();
    if (cropped != null) {
      final file = await _saveMemoryImageToFile(cropped);
      widget.onCropped(file);
      Navigator.pop(context);
    }
  }

  Future<File> _saveMemoryImageToFile(MemoryImage img) async {
    final directory = await Directory.systemTemp.createTemp();
    final path = '${directory.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(path);
    await file.writeAsBytes(img.bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    final targetWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        title: "Crop Image",
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: _cropImage,
          ),
        ],
      ),
      body: Center(
        child: CustomImageCrop(
          image: FileImage(widget.initialImage),
          cropController: _cropController,
          shape: CustomCropShape.Ratio,
          ratio: Ratio(width: targetWidth, height: widget.height ?? 300.h),
          overlayColor: Colors.black.withOpacity(0.4),
          cropPercentage: 1.0,
          canRotate: false,
          canScale: true,
          canMove: true,
        ),
      ),
    );
  }
}
