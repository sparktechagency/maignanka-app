class ApiUrls {
  static const String baseUrl = "http://vibely-ifti.sarv.live";


  static const String imageBaseUrl = "http://vibely-ifti.sarv.live";

  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String uploadPhoto = '/gallery/upload';
  static const String login = '/auth/login';
  static const String forgetPassword = '/auth/forget-password';
  static  const String  resendOtp = '/auth/resend-otp';
  static  const String  resetPassword = '/auth/reset-password';
  static  const String  myProfile = '/auth/my-profile';
  static  const String  updateProfile = '/auth/profile-update';
  static   String  accountDelete(String id) => '/auth/account-delete?id=$id';
  static  const String  getBanner = '/banner';
  static  const String  terms = '/terms';
  static  const String  about = '/about';
  static  const String  privacy = '/privacy';
  static  const String  changePassword = '/user/change-password';
  static  const String  paymentConfirm = '/payment/confirm';
  static  const String  sessionCreate = '/session/create';
  static  const String  communityCreate = '/community/create';
  static  const String  charge = '/charge';
  static  const String  booking = '/booking';
  static  const String  joinCommunity = '/community/join';
  static  const String  communityLeave = '/community/leave';
  static  const String  removeMember = '/community/remove-member';
  static   String  session (String? type,price,date,page)=> '/session?type=$type&price=$price&date=$date&page=$page';
  static   String  post (String? communityId,type,page,)=> '/post?communityId=$communityId&page=$page&type=$type';
  static   String  community (String? type,page,date,)=> '/community?page=$page&type=$type&date=$date';
  static   String  communityDetails (String? communityId)=> '/community/details?communityId=$communityId';
  static   String  user (String id)=> '/session/registered-users?sessionId=$id';
  static   String  bookmark (String id)=> '/booking/add?sessionId=$id';
  static   String  deleteBooking (String id)=> '/booking/delete?bookingId=$id';
  static   String  deleteSession (String id)=> '/session/delete?sessionId=$id';
  static   String  deleteGroup (String id)=> '/community/delete?communityId=$id';
  static   String  editSession (String id)=> '/session/edit?sessionId=$id';
  static   String  editGroup (String id)=> '/community/edit?communityId=$id';
  static   String  otherProfile (String id)=> '/auth/other-profile?userId=$id';
  static   String  postCreate (String id)=> '/post/create?communityId=$id';
  static   String  commentCreate (String id)=> '/comment/add?postId=$id';
  static   String  postDelete (String postId,communityId)=> '/post/delete?postId=$postId&communityId=$communityId';
  static   String  postEdit (String postId,communityId,[String? mediaId])=> '/post/edit?communityId=$communityId&postId=$postId&mediaId=${mediaId ?? ''}';
  static   String  getComment (String postId,type,page)=> '/comment?postId=$postId&type=$type&page=$page';
  static   String  editComment (String postId,commentId)=> '/comment/edit?postId=$postId&commentId=$commentId';
  static   String  deleteComment (String postId,commentId)=> '/comment/delete?postId=$postId&commentId=$commentId';



  static   String  createChat (String receiverId)=> '/chat/create?receiverId=$receiverId';
  static   String  getChatMessage (String receiverId,chatId,page)=> '/chat/message?receiverId=$receiverId&chatId=$chatId&page=$page';
  static   String  chatList(String page) => '/chat/list?page=$page';
  static   String  blockUser(String receiverId) => '/chat/block-user?receiverId=$receiverId';
  static   String  unblockUser(String receiverId) => '/chat/unblock-user?receiverId=$receiverId';


  static  const String  notification = '/notification';
  static  const String  notificationBadge = '/notification/badge-count';

}
