import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import '../../../widgets/widgets.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import '../../controllers/gallery/gallery_controller.dart';
import '../media/media_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final GalleryController _controller = Get.find<GalleryController>();

  @override
  void initState() {
    super.initState();
    _controller.galleryGet();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GalleryController>(
      builder: (controller) {
        return CustomScaffold(
          appBar: CustomAppBar(title:"Gallery",
          actions: [
            IconButton(onPressed: () => controller.imagesAdded(context), icon: Assets.icons.imageAdd.svg())
          ],),
          body: controller.isLoading
              ? const CustomLoader()
              : controller.galleryData.isEmpty
              ? const Center(child: CustomText(text: 'Gallery not yet'))
              : Column(
                children: [
                  Expanded(
                    child: StaggeredGrid.count(
                                crossAxisCount: 4,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: List.generate(controller.galleryData.length, (index) {
                                  debugPrint(' ==================== > > ${controller.galleryData[index].imageURL}');
                                  final media = controller.galleryData[index];
                    final imageUrl = '${ApiUrls.imageBaseUrl}${media.imageURL}';
                    final isSelected = controller.selectedIndexes.contains(index);

                    return StaggeredGridTile.count(
                      crossAxisCellCount: _getCross(index),
                      mainAxisCellCount: _getMain(index),
                      child: GestureDetector(
                        onTap: () {
                          isSelected
                              ? controller.toggleSelection(index)
                              : Get.to(() => FullScreenImage(imageUrl: imageUrl));
                        },
                        onLongPress: () => controller.toggleSelection(index),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CustomNetworkImage(imageUrl: imageUrl),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Icon(Icons.check_circle,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                                }),
                              ),
                  ),
                  if(controller.selectedIndexes.isNotEmpty)
                     CustomContainer(
                    onTap: controller.galleryPhotoDeleted,
                    color: AppColors.primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    paddingAll: 12.r,
                      child: controller.isLoadingDelete ? CustomLoader() : Assets.icons.delete.svg()),
                  SizedBox(height: 24.h),
                ],
              ),
        );
      },
    );
  }

  int _getCross(int i) => (i % 7 == 0 || i % 5 == 0) ? 2 : 1;
  int _getMain(int i) => i % 4 == 0 ? 2 : 1;


}
