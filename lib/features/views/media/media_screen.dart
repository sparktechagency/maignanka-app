import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/conversations/media_controller.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:photo_view/photo_view.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {


  final MediaController _mediaController = Get.find<MediaController>();

  late String conversationId;

  @override
  void initState() {
    conversationId = Get.arguments['conversationId'];
    _mediaController.conversationMedia(conversationId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Media'),
      body: GetBuilder<MediaController>(
        builder: (controller) {
          return GridView.builder(
            itemCount: controller.mediaData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => FullScreenImage(
                            imageUrl:'${ApiUrls.imageBaseUrl}${controller.mediaData[index].url ?? ''}'),
                    ),
                  );
                },
                child: CustomNetworkImage(
                  imageUrl: '${ApiUrls.imageBaseUrl}${controller.mediaData[index].url ?? ''}',
                  borderRadius: 7.r,
                ),
              );
            },
          );
        }
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 0,
      appBar: CustomAppBar(
        title: "Photo",
      ),
      body: Center(
        child: PhotoView(
          backgroundDecoration: const BoxDecoration(
          ),
          imageProvider: NetworkImage(imageUrl),
          loadingBuilder: (context, progress) => const Center(
            child: CustomLoader(),
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
        ),
      ),
    );
  }
}