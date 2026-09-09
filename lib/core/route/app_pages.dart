import 'package:flutter/cupertino.dart' hide Notification;
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:meetvibe/presention/home/home_ui/home_ui.dart';
import 'package:meetvibe/presention/onlodingscreen/onloding2.dart';
import 'package:meetvibe/presention/onlodingscreen/onloding3.dart';
import 'package:meetvibe/presention/onlodingscreen/onloding_screen.dart';
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
import 'package:meetvibe/presention/profile/profile_ui/changeyourpassword.dart';
import 'package:meetvibe/presention/profile/profile_ui/editprofile.dart';
import 'package:meetvibe/presention/profile/profile_ui/profile_ui.dart';
import 'package:meetvibe/presention/event/event_Ui/event_ui.dart';
import 'package:meetvibe/presention/createevent/create_event_Ui/create_eventUI.dart';
import 'package:meetvibe/presention/message/message_ui/meassage_ui.dart';
import 'package:meetvibe/presention/home/home_widget/event_details_ui.dart';
import 'package:meetvibe/presention/home/home_widget/trending_category_ui.dart';
import 'package:meetvibe/presention/home/home_ui/nearbyall.dart';
import 'package:meetvibe/presention/home/home_ui/upcaminall.dart';
import 'package:meetvibe/presention/profile/profile_ui/security.dart';
import 'package:meetvibe/presention/profile/profile_ui/support_Help.dart';
import 'package:meetvibe/presention/profile/profile_ui/faqs_ui.dart';
import 'package:meetvibe/presention/profile/profile_ui/info_doc_ui.dart';
import 'package:meetvibe/presention/profile/profile_ui/report_problem_ui.dart';
import 'package:meetvibe/presention/notification/notification.dart';
import 'package:meetvibe/presention/message/message_ui/msg_inbox.dart';
import 'package:meetvibe/presention/profile/profile_ui/subscription.dart';
import 'package:meetvibe/presention/profile/profile_ui/my_events_ui.dart';
import 'package:meetvibe/presention/event/event_Ui/manage_event_ui.dart';

class AppPages {
  static const initial = AppRoutes.onloding1;
  
  static final routes = [
    GetPage(name: AppRoutes.onloding1, page: () => const OnlodingScreen()),
    GetPage(name: AppRoutes.onloding2, page: () => Onloding2()),
    GetPage(name: AppRoutes.onloding3, page: () => Onloding3()),

    //===================auth====================================
    GetPage(name: AppRoutes.loginOrSignUp, page: () => Logininsingin()),
    GetPage(name: AppRoutes.login, page: () => Login()),
    GetPage(name: AppRoutes.createAccount, page: () => Createaccount()),
    GetPage(name: AppRoutes.forgetPassword, page: () => Forgetpasswoard()),
    GetPage(name: AppRoutes.createNewPassword, page: () => Createnewpasswoard()),
    GetPage(name: AppRoutes.verifyEmail, page: () => Verifyemail()),
    GetPage(name: AppRoutes.verified, page: () => Verified()),
    GetPage(name: AppRoutes.identityVerification, page: () => Identityverification()),
    GetPage(name: AppRoutes.uploadGovernmentID, page: () => Uploadgovernmentid()),
    GetPage(name: AppRoutes.selfieVerification, page: () => Selfieverification()),
    GetPage(name: AppRoutes.verificationSuccessful, page: () => Verificationsuccessful()),
    
    //=====================================User Interface=================================================
    GetPage(name: AppRoutes.homeui, page: () => HomeUi(), transition: Transition.noTransition),
    GetPage(name: AppRoutes.profile, page: () => ProfileUi(), transition: Transition.noTransition),
    GetPage(name: AppRoutes.eventui, page: () => EventUi(), transition: Transition.noTransition),
    GetPage(name: AppRoutes.createeventui, page: () => CreateEventui(), transition: Transition.noTransition),
    GetPage(name: AppRoutes.message, page: () => MeassageUi(), transition: Transition.noTransition),

    //=====================================Home Navigations===============================================
    GetPage(name: AppRoutes.eventdetels, page: () => const EventDetailsUi()),
    GetPage(name: AppRoutes.upcamingall, page: () => const Nearbyall()),
    GetPage(name: AppRoutes.tendingcatagory, page: () => const TrendingCategoryUi()),
    GetPage(name: AppRoutes.upcominevent, page: () => const Upcaminall()),
    GetPage(name: AppRoutes.notifcation, page: () =>  Notification()),


    //==============================profile===================================
    GetPage(name: AppRoutes.editprofile, page: ()=>Editprofile()),
    GetPage(name: AppRoutes.security, page: ()=>Security()),
    GetPage(name: AppRoutes.support_help, page: ()=>Support_help()),
    GetPage(name: AppRoutes.change_yourpassword, page: ()=>Changeyourpassword()),
    GetPage(name: AppRoutes.msgInbox, page: () => const MsgInbox()),
    GetPage(name: AppRoutes.subscription, page: () => const SubscriptionUi()),
    GetPage(name: AppRoutes.myEvents, page: () => const MyEventsUi()),
    GetPage(name: AppRoutes.faqs, page: () => const FaqsUi()),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const InfoDocUi(
        pageTitle: "Privacy Policy",
        apiUrl: Apiservices.settingsPrivacyPolicy,
        dataKey: "privacyPolicy",
      ),
    ),
    GetPage(
      name: AppRoutes.terms,
      page: () => const InfoDocUi(
        pageTitle: "Terms & Conditions",
        apiUrl: Apiservices.settingsTerms,
        dataKey: "terms",
      ),
    ),
    GetPage(name: AppRoutes.reportProblem, page: () => const ReportProblemUi()),
    GetPage(name: AppRoutes.manageEvent, page: () => const ManageEventUi()),
  ];
}
