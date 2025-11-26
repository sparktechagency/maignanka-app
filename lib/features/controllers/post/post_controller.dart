import 'package:flutter/cupertino.dart';
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


  List<PostModelData> allPostData = [];
  List<PostModelData> myPostData = [];





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



  bool isLoadMore = false;


  Future<void> postGet({String? userId = '', bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      if (userId != '') {
        myPostData.clear();
      } else {
        allPostData.clear();
      }
      page = 1;
      totalPage = -1;

      isLoading = true;
      isLoadMore = false;
      update();
    }

    final response = await ApiClient.getData(
      ApiUrls.allPost(page, limit, userId),
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];
      final post = data.map((json) => PostModelData.fromJson(json)).toList();

      totalPage = responseBody['pagination']?['totalPages'] ?? totalPage;

      if (userId != '') {
        myPostData.addAll(post);
      } else {
        allPostData.addAll(post);
      }
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    isLoadMore = false;
    update();
  }


  Future<void> loadMore() async {
    print('============> Page $page');

    if (page < totalPage && !isLoadMore) {
      page += 1;
      isLoadMore = true; // ✅ mark pagination loading
      update();

      print('============> Page++ $page \n=============> totalPage $totalPage');

      if (selectedValueType == 'my') {
        await postGet(userId: Get.find<ProfileController>().userId, isInitialLoad: false);
      } else {
        await postGet(isInitialLoad: false);
      }
    }
  }






  final Map<String, bool> postLikeMap = {};
  final Map<String, bool> postLikeLoading = {};

  bool isLiked(String postId) => postLikeMap[postId] ?? false;

  bool isLikeLoading(String postId) => postLikeLoading[postId] ?? false;

  void setInitialLike(String postId, bool status) {
    postLikeMap[postId] = status;
    update();
  }

  Future<bool> likeButtonAction(bool currentLiked, String postId) async {
    postLikeLoading[postId] = true;
    update();

    postLikeMap[postId] = !currentLiked;
    _updatePostLikeCount(postId, !currentLiked);
    update();

    final response = await ApiClient.postData(ApiUrls.like(postId), {});

    postLikeLoading[postId] = false;

    if (response.statusCode == 200) {
      update();
    } else {
      postLikeMap[postId] = currentLiked;
      _updatePostLikeCount(postId, currentLiked);
      update();
    }

    return !currentLiked;
  }

  void _updatePostLikeCount(String postId, bool isLiked) {
    final allPostIndex = allPostData.indexWhere((post) => post.sId == postId);
    if (allPostIndex != -1) {
      allPostData[allPostIndex].isLiked = isLiked;
      allPostData[allPostIndex].likesCount =
          (allPostData[allPostIndex].likesCount ?? 0) + (isLiked ? 1 : -1);
    }

    final myPostIndex = myPostData.indexWhere((post) => post.sId == postId);
    if (myPostIndex != -1) {
      myPostData[myPostIndex].isLiked = isLiked;
      myPostData[myPostIndex].likesCount =
          (myPostData[myPostIndex].likesCount ?? 0) + (isLiked ? 1 : -1);
    }
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




  bool isLoadingSearch = false;
  int searchPage = 1;
  int searchTotalPage = 1;
  String lastSearch = ""; // Store the last search keyword
  List<SearchModelData> searchPostData = [];

  /// Fetch search results
  Future<void> postSearchGet(String search, {bool isInitialLoad = false}) async {
    searchPostData.clear();

    isLoadingSearch = true;
    update();

    try {
      final response = await ApiClient.getData(
        ApiUrls.postSearch(search, searchPage, searchTotalPage),
      );

      final responseBody = response.body;

      if (response.statusCode == 200) {
        final List data = responseBody['data'] ?? [];
        final post = data.map((json) => SearchModelData.fromJson(json)).toList();

        searchTotalPage =
            responseBody['pagination']?['totalPages'] ?? searchTotalPage;

        searchPostData.addAll(post);
      } else {
        ToastMessageHelper.showToastMessage(
          responseBody['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    }

    isLoadingSearch = false;
    update();
  }

  /// Load more search results
  Future<void> loadMoreSearch() async {
    if (isLoadingSearch) return;
    print('============> Page $searchPage');

    if (searchPage < searchTotalPage) {
      searchPage += 1;
      update();
      print(
        '============> Page++ $searchPage \n=============> totalPage $searchTotalPage',
      );

      await postSearchGet(lastSearch);
    }
  }





  /// deleted post =======================>


  bool isLoadingDelete = false;



  Future<void> postDeleted(String postId) async {


    isLoadingDelete = true;
    update();

    final response = await ApiClient.deleteData(
      ApiUrls.postDeleted(postId),
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      postGet(userId: Get.find<ProfileController>().userId);
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoadingDelete = false;
    update();
  }









}
