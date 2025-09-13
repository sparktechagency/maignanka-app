import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class SimmerHelper {

  static Widget postSimmer() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profile row
              Row(
                children: [
                  _shimmerBox(height: 40.r, width: 40.r, shape: BoxShape.circle),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(height: 12.h, width: 120.w),
                        SizedBox(height: 6.h),
                        _shimmerBox(height: 10.h, width: 80.w),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              /// Caption
              _shimmerBox(height: 12.h, width: double.infinity),
              SizedBox(height: 6.h),
              _shimmerBox(height: 12.h, width: 200.w),
              SizedBox(height: 12.h),

              /// Image
              _shimmerBox(height: 200.h, width: double.infinity, radius: 12.r),
              SizedBox(height: 12.h),

              /// Social Actions row
              Row(
                children: [
                  _shimmerBox(height: 20.r, width: 20.r, shape: BoxShape.circle),
                  SizedBox(width: 10.w),
                  _shimmerBox(height: 12.h, width: 40.w),
                  SizedBox(width: 20.w),
                  _shimmerBox(height: 20.r, width: 20.r, shape: BoxShape.circle),
                  SizedBox(width: 10.w),
                  _shimmerBox(height: 12.h, width: 40.w),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  /// Profile Details Shimmer
  static Widget profileDetailsSimmer() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      children: [
        // Image slider shimmer
        _shimmerBox(height: 400.h, width: double.infinity, radius: 13.r),
        SizedBox(height: 16.h),

        // Name + Age
        _shimmerBox(height: 24.h, width: 180.w),
        SizedBox(height: 12.h),

        // Bio section
        _shimmerBox(height: 12.h, width: double.infinity),
        SizedBox(height: 6.h),
        _shimmerBox(height: 12.h, width: 250.w),
        SizedBox(height: 16.h),

        // Basic Info rows
        ...List.generate(5, (_) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            children: [
              _shimmerBox(height: 14.h, width: 14.h, shape: BoxShape.circle),
              SizedBox(width: 8.w),
              _shimmerBox(height: 12.h, width: 100.w),
              Spacer(),
              _shimmerBox(height: 12.h, width: 60.w),
            ],
          ),
        )),

        SizedBox(height: 16.h),

        // Interest chips
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(4, (_) => _shimmerBox(height: 24.h, width: 80.w, radius: 12.r)),
        ),

        SizedBox(height: 24.h),

        // Match action buttons
        Row(
          children: [
            Expanded(child: _shimmerBox(height: 38.h, width: double.infinity, radius: 8.r)),
            SizedBox(width: 10.w),
            Expanded(child: _shimmerBox(height: 38.h, width: double.infinity, radius: 8.r)),
          ],
        ),
      ],
    );
  }


  /// Swipe Card Shimmer
  static Widget swipeCardSimmer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          // Image placeholder
          _shimmerBox(height: 400.h, width: double.infinity, radius: 16.r),

          // Bottom info placeholder
          Positioned(
            left: 10.w,
            right: 10.w,
            bottom: 10.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Age
                _shimmerBox(height: 24.h, width: 180.w, radius: 8.r),
                SizedBox(height: 6.h),
                // Location + distance
                Row(
                  children: [
                    _shimmerBox(height: 14.h, width: 14.h, shape: BoxShape.circle),
                    SizedBox(width: 6.w),
                    _shimmerBox(height: 14.h, width: 100.w, radius: 6.r),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  /// CustomListTile Shimmer
  static Widget customListTileSimmer({int itemCount = 5}) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
          child: Row(
            children: [
              // Avatar shimmer
              _shimmerBox(height: 36.r, width: 36.r, shape: BoxShape.circle),
              SizedBox(width: 10.w),

              // Title & subtitle shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(height: 12.h, width: 120.w, radius: 6.r),
                    SizedBox(height: 6.h),
                    _shimmerBox(height: 10.h, width: 80.w, radius: 6.r),
                  ],
                ),
              ),

              // Trailing shimmer
              _shimmerBox(height: 12.h, width: 40.w, radius: 6.r),
            ],
          ),
        );
      },
    );
  }


  /// Inbox/Chat List Shimmer
  /// Chat Screen Shimmer
  static Widget chatScreenSimmer({int itemCount = 8}) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final isMyChat = index % 2 == 0; // alternate left/right
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            mainAxisAlignment:
            isMyChat ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMyChat)
                _shimmerBox(height: 40.r, width: 40.r, shape: BoxShape.circle),
              if (!isMyChat) SizedBox(width: 8.w),

              // Message bubble
              Flexible(
                child: _shimmerBox(
                  height: 20.h + (index % 3) * 10.h, // varying heights
                  width: 150.w + (index % 3) * 20.w, // varying widths
                  radius: 12.r,
                ),
              ),

              if (isMyChat) SizedBox(width: 8.w),
              if (isMyChat)
                _shimmerBox(height: 40.r, width: 40.r, shape: BoxShape.circle),
            ],
          ),
        );
      },
    );
  }




  static Widget _shimmerBox({
    double? height,
    double? width,
    double radius = 6,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(radius) : null,
          shape: shape,
        ),
      ),
    );
  }
}
