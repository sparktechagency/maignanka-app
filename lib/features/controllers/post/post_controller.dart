import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/controllers/profile_details/profile_controller.dart';
import 'package:maignanka_app/features/models/post_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class PostController extends GetxController {

  bool isLoading = false;
  int limit = 10;
  int page = 1;
  int totalPage = -1;

  String selectedValueType = 'all';
  bool isLike = false;
  final PageController pageController = PageController();
  int currentPage = 0;


  List<PostModelData> postData = [];



  Future<bool> likeButtonAction(bool isLiked) async {
    isLike = !isLiked;
    update();
    return !isLiked;
  }


  void onChangeType(String newType) {
    selectedValueType = newType;
    if(newType == 'my'){
      postGet(isInitialLoad: true,userId: Get.find<ProfileController>().userId);
    }else{
      postGet(isInitialLoad: true);
    }
  }


  void onChangePage (int index) {
      currentPage = index;
      update();
  }




  Future<void> postGet({String? userId = '',bool isInitialLoad = false}) async {

    if (isInitialLoad) {
      postData.clear();
      page = 1;
      totalPage = -1;
    }

    isLoading = true;
    update();

    final response = await ApiClient.getData(
        ApiUrls.allPost(page,limit,userId),
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];

      final post = data.map((json) => PostModelData.fromJson(json)).toList();

      totalPage = responseBody['pagination']?['totalPages'] ?? totalPage;

      postData.addAll(post);

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }


  Future<void> loadMore() async {

    print('============> Page $page');

    if (page < totalPage) {
      page += 1;
      update();
      print('============> Page++ $page \n=============> totalPage $totalPage');

      await postGet();
    }
  }


  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
