import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/onlodingscreen/onloding1.dart';
import 'package:meetvibe/presention/onlodingscreen/onloding2.dart';
import 'package:meetvibe/presention/onlodingscreen/onloding3.dart';
import 'package:meetvibe/presention/auth/auth_ui/logininsingin.dart';
import 'package:meetvibe/presention/auth/auth_ui/login.dart';
import 'package:meetvibe/presention/auth/auth_ui/createAccount.dart';
import 'package:meetvibe/presention/auth/auth_ui/forgetPasswoard.dart';
import 'package:meetvibe/presention/auth/auth_ui/createNewPasswoard.dart';
import 'package:meetvibe/presention/auth/auth_ui/verifyEmail.dart';
import 'package:meetvibe/presention/auth/auth_ui/verified.dart';
import 'package:meetvibe/presention/auth/auth_ui/identityVerification.dart';
import 'package:meetvibe/presention/auth/auth_ui/uploadGovernmentID.dart';
import 'package:meetvibe/presention/auth/auth_ui/selfieVerification.dart';
import 'package:meetvibe/presention/auth/auth_ui/verificationSuccessful.dart';

class AppPages {

  static const initial = AppRoutes.onloding1;
  static final routes = [
    GetPage(name: AppRoutes.onloding1, page: ()=>Onloding1()),
    GetPage(name: AppRoutes.onloding2, page: ()=>Onloding2()),
    GetPage(name: AppRoutes.onloding3, page: ()=>Onloding3()),

    //===================auth====================================
    GetPage(name: AppRoutes.loginOrSignUp, page: ()=>Logininsingin()),
    GetPage(name: AppRoutes.login, page: ()=>Login()),
    GetPage(name: AppRoutes.createAccount, page: ()=>Createaccount()),
    GetPage(name: AppRoutes.forgetPassword, page: ()=>Forgetpasswoard()),
    GetPage(name: AppRoutes.createNewPassword, page: ()=>Createnewpasswoard()),
    GetPage(name: AppRoutes.verifyEmail, page: ()=>Verifyemail()),
    GetPage(name: AppRoutes.verified, page: ()=>Verified()),
    GetPage(name: AppRoutes.identityVerification, page: ()=>Identityverification()),
    GetPage(name: AppRoutes.uploadGovernmentID, page: ()=>Uploadgovernmentid()),
    GetPage(name: AppRoutes.selfieVerification, page: ()=>Selfieverification()),
    GetPage(name: AppRoutes.verificationSuccessful, page: ()=>Verificationsuccessful()),
  ];
}

