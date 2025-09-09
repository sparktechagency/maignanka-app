import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
      final file = await _saveAndCompressImage(cropped.bytes);
      widget.onCropped(file);
      Navigator.pop(context);
    }
  }

  Future<File> _saveAndCompressImage(Uint8List bytes) async {
    final directory = await Directory.systemTemp.createTemp();
    final path =
        '${directory.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';

    File file = File(path);
    await file.writeAsBytes(bytes);

    // Loop করে compress করব যতক্ষণ না সাইজ <= 200KB হয়
    int quality = 90;
    while (file.lengthSync() > 200 * 1024 && quality > 10) {
      final  result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        file.absolute.path,
        quality: quality,
        minWidth: (MediaQuery.sizeOf(context).width ?? 800).toInt(),
        minHeight: (widget.height ?? 300).toInt(),
      );
      if (result != null) {
        file = File(result.path);
      }
      quality -= 10; // ধাপে ধাপে কমানো
    }

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
          imageFit: CustomImageFit.fillVisibleHeight,
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
