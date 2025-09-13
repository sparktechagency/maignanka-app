import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/models/swipe_data_model.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class DiscoverController extends GetxController {
  List<SwipeDataModel> swipeDataList = [];

  bool isLoading = false;
  bool isLoadingMore = false;
  String currentUserId = '';
  int forbidden = -1;

  int limit = 20;
  int page = 1;
  int totalPage = -1;

  String goal = '';
  // String interest = 'Male';
  double distance = 40;
  RangeValues ageRange = RangeValues(0, 24);

  void onChangeGoal(String value) {
    goal = value;
    update();
  }

  void onChangeDistance(double value) {
    distance = value;
    update();
  }

  void onChangeAgeRange(RangeValues values) {
    ageRange = values;
    update();
  }

  void clean() {
    goal = '';
    // interest = 'Male';
    distance = 40;
    ageRange = RangeValues(0, 28);
    update();
  }


  Future<void> swipeProfileGet() async {
    swipeDataList.clear();

    if (page == 1) {
      isLoading = true;
      update();
    } else {
      isLoadingMore = true;
      update();
    }

    final response = await ApiClient.getData(
      ApiUrls.swipeProfile(
        limit,
        page,
        goal,
        '${ageRange.start.toInt()}-${ageRange.end.toInt()}',
        distance.toInt(),
      ),
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];

      final swipeData = data.map((json) => SwipeDataModel.fromJson(json)).toList();

      totalPage = responseBody['pagination']?['totalPages'] ?? totalPage;
      forbidden = 200;
      update();
      swipeDataList.addAll(swipeData);
    }else if(response.statusCode == 403){
      forbidden = 403;
      update();
    }else {
      forbidden = response.statusCode ?? -1;
      update();
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    isLoadingMore = false;
    update();
  }

  Future<void> loadMore() async {
    if (!isLoadingMore && page < totalPage) {
      page += 1;
      await swipeProfileGet();
    }
  }
}
