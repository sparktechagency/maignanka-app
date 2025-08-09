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


  List<PostModelData> postData = [];





  void onChangeType(String newType) {
    selectedValueType = newType;
    if(newType == 'my'){
      postGet(isInitialLoad: true,userId: Get.find<ProfileController>().userId);
    }else{
      postGet(isInitialLoad: true);
    }
  }

  void onRefresh() async{
    if(selectedValueType == 'my'){
      postGet(isInitialLoad: true,userId: Get.find<ProfileController>().userId);
    }else{
      postGet(isInitialLoad: true);
    }
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






  final Map<String, bool> postLikeMap = {};

  bool isLiked(String postId) => postLikeMap[postId] ?? false;

  void setInitialLike(String postId, bool status) {
    postLikeMap[postId] = status;
    update();
  }

  Future<bool> likeButtonAction(bool currentLiked, String postId) async {
    postLikeMap[postId] = !currentLiked;
    update();

    final response = await ApiClient.postData(ApiUrls.like(postId), {});

    final responseBody = response.body;
    if (response.statusCode == 200) {
    } else {
      postLikeMap[postId] = currentLiked;
      update();

      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Failed");
    }

    return !currentLiked;
  }








  bool isLoadingSocial = false;
  int socialPage = 1;
  int socialTotalPage = 1;
  List<PostModelData> socialPostData = [];

  Future<void> postSocialGet({bool isInitialLoad = false}) async {

    if (isInitialLoad) {
      socialPostData.clear();
      socialPage = 1;
      socialTotalPage = -1;
    }

    isLoadingSocial = true;
    update();

    final response = await ApiClient.getData(
      headers: {'Content-Type': 'application/json'},
      ApiUrls.socialPost(page,limit),
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];

      final post = data.map((json) => PostModelData.fromJson(json)).toList();

      socialTotalPage = responseBody['pagination']?['totalPages'] ?? socialTotalPage;

      socialPostData.addAll(post);

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoadingSocial = false;
    update();
  }


  Future<void> loadMoreSocial() async {

    print('============> Page $socialPage');

    if (socialPage < socialTotalPage) {
      socialPage += 1;
      update();
      print('============> Page++ $socialPage \n=============> totalPage $socialTotalPage');

      await postSocialGet();
    }
  }


}
