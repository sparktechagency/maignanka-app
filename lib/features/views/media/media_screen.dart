import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:photo_view/photo_view.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Media'),
      body: GridView.builder(
        itemCount: 9,
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
                        imageUrl:
                            'https://randomuser.me/api/portraits/women/$index.jpg',
                      ),
                ),
              );
            },
            child: CustomNetworkImage(
              imageUrl: 'https://randomuser.me/api/portraits/women/$index.jpg',
              borderRadius: 7.r,
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Preview",
        actions: [
          IconButton(
            icon: Icon(Icons.download,color: Colors.black),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Center(child: PhotoView(
        backgroundDecoration: BoxDecoration(
          color: Colors.white
        ),
          imageProvider: NetworkImage(imageUrl))),
    );
  }
}
