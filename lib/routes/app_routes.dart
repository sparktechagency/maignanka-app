import 'package:flutter/material.dart';
import 'package:maignanka_app/features/views/auth/Interests/Interests_screen.dart';
import 'package:maignanka_app/features/views/auth/bio/bio_screen.dart';
import 'package:maignanka_app/features/views/auth/change%20password/change_password.dart';
import 'package:maignanka_app/features/views/auth/forget/forget_screen.dart';
import 'package:maignanka_app/features/views/auth/goals/goals_screen.dart';
import 'package:maignanka_app/features/views/auth/location/location_screen.dart';
import 'package:maignanka_app/features/views/auth/login/log_in_screen.dart';
import 'package:maignanka_app/features/views/auth/otp/otp_screen.dart';
import 'package:maignanka_app/features/views/auth/reset_pass/reset_password_screen.dart';
import 'package:maignanka_app/features/views/auth/sign_up/sign_up_screen.dart';
import 'package:maignanka_app/features/views/auth/upload_photos/upload_photo_screen.dart';
import 'package:maignanka_app/features/views/bank_info/bank_info_screen.dart';
import 'package:maignanka_app/features/views/bottom_nav_bar/customtom_bottom_nav.dart';
import 'package:maignanka_app/features/views/comment/comment_screen.dart';
import 'package:maignanka_app/features/views/conversation/chat_screen.dart';
import 'package:maignanka_app/features/views/gifts/gifts_member_screen.dart';
import 'package:maignanka_app/features/views/gifts/gifts_screen.dart';
import 'package:maignanka_app/features/views/join_guest/join_guest_screen.dart';
import 'package:maignanka_app/features/views/love/love_screen.dart';
import 'package:maignanka_app/features/views/media/media_screen.dart';
import 'package:maignanka_app/features/views/onboarding_screen/onboarding_screen.dart';
import 'package:maignanka_app/features/views/post_create/post_create_screen.dart';
import 'package:maignanka_app/features/views/profile/profile_edit.dart';
import 'package:maignanka_app/features/views/setting/support_screen.dart';
import 'package:maignanka_app/features/views/profile_details/profile_details_screen.dart';
import 'package:maignanka_app/features/views/report/report_details_screen.dart';
import 'package:maignanka_app/features/views/report/report_screen.dart';
import 'package:maignanka_app/features/views/setting/about_screen.dart';
import 'package:maignanka_app/features/views/setting/privacy_policy_screen.dart';
import 'package:maignanka_app/features/views/setting/setting_screen.dart';
import 'package:maignanka_app/features/views/setting/terms_screen.dart';
import 'package:maignanka_app/features/views/splash_screen/splash_screen.dart';
import 'package:maignanka_app/features/views/wallet/wallet_screen.dart';
import '../features/views/notification/notification_screen.dart';

abstract class AppRoutes {


  ///  ============= > initialRoute < ==============
  static const String initialRoute = splashScreen;



  ///  ============= > routes name < ==============
  static const String splashScreen = '/';
  static const String onboardingScreen = '/onboardingScreen';
  static const String loginScreen = '/loginScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String forgotScreen = '/forgotScreen';
  static const String otpScreen = '/otpScreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String uploadPhotoScreen = '/uploadPhotoScreen';
  static const String goalsScreen = '/goalsScreen';
  static const String bioScreen = '/bioScreen';
  static const String interestsScreen = '/interestsScreen';
  static const String enableLocationScreen = '/enableLocationScreen';
  static const String customBottomNavBar = '/customBottomNavBar';
  static const String notificationScreen = '/notificationScreen';
  static const String commentScreen = '/commentScreen';
  static const String settingScreen = '/settingScreen';
  static const String termsScreen = '/termsScreen';
  static const String policyScreen = '/policyScreen';
  static const String aboutScreen = '/aboutScreen';
  static const String changePassScreen = '/changePassScreen';
  static const String supportScreen = '/supportScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String walletScreen = '/walletScreen';
  static const String chatScreen = '/chatScreen';
  static const String loveScreen = '/loveScreen';
  static const String giftsScreen = '/giftsScreen';
  static const String postCreateScreen = '/postCreateScreen';
  static const String reportScreen = '/reportScreen';
  static const String reportDetailsScreen = '/reportDetailsScreen';
  static const String mediaScreen = '/mediaScreen';
  static const String profileDetailsScreen = '/profileDetailsScreen';
  static const String giftsMemberScreen = '/giftsMemberScreen';
  static const String bankInfoScreen = '/bankInfoScreen';
  static const String joinGuestScreen = '/joinGuestScreen';




  ///  ============= > routes < ==============
  static final routes = <String, WidgetBuilder>{
    splashScreen : (context) => SplashScreen(),
    onboardingScreen : (context) => OnboardingScreen(),
    loginScreen : (context) => LoginScreen(),
    forgotScreen : (context) => ForgetScreen(),
    otpScreen : (context) => OtpScreen(),
    resetPasswordScreen : (context) => ResetPasswordScreen(),
    signUpScreen : (context) => SignUpScreen(),
    uploadPhotoScreen : (context) => UploadPhotoScreen(),
    goalsScreen : (context) => GoalsScreen(),
    interestsScreen : (context) => InterestsScreen(),
    enableLocationScreen : (context) => EnableLocationScreen(),
    customBottomNavBar : (context) => CustomBottomNavBar(),
    notificationScreen : (context) => NotificationScreen(),
    commentScreen : (context) => CommentScreen(),
    settingScreen : (context) => SettingScreen(),
    aboutScreen : (context) => AboutScreen(),
    policyScreen : (context) => PrivacyPolicyScreen(),
    termsScreen : (context) => TermsScreen(),
    changePassScreen : (context) => ChangePasswordScreen(),
    supportScreen : (context) => SupportScreen(),
   editProfileScreen : (context) => EditProfileScreen(),
    walletScreen : (context) => WalletScreen(),
    chatScreen : (context) => ChatScreen(),
    loveScreen : (context) => LoveScreen(),
    giftsScreen : (context) => GiftsScreen(),
    postCreateScreen : (context) => PostCreateScreen(),
    reportScreen : (context) => ReportScreen(),
    reportDetailsScreen : (context) => ReportDetailsScreen(),
    mediaScreen : (context) => MediaScreen(),
    profileDetailsScreen : (context) => ProfileDetailsScreen(),
    bioScreen : (context) => BioScreen(),
    giftsMemberScreen : (context) => GiftsMemberScreen(),
    bankInfoScreen : (context) => BankInfoScreen(),
    joinGuestScreen : (context) => JoinGuestScreen(),
  };
}
