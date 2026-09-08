class Apiservices {
  Apiservices._();

  static const String baseUrl = "https://garmin-diagnosis-unexpected-bestsellers.trycloudflare.com/api/v1";

  //========================================================Chat=======================================
  static const String chatConversations = "$baseUrl/chat/conversations";
  static String chatGroup(String eventId) => "$baseUrl/chat/group/$eventId";
  static String chatPrivate(String targetUserId) => "$baseUrl/chat/private/$targetUserId";

  //========================================================Webhooks=======================================
  static const String webhookStripe = "$baseUrl/webhooks/stripe";
  static const String webhookRevenueCat = "$baseUrl/webhooks/revenuecat";

  //========================================================Participations=======================================
  static const String participationJoin = "$baseUrl/participation/join";
  static const String participationPayCheckout = "$baseUrl/participation/pay-checkout";
  static const String participationPay = "$baseUrl/participation/pay";
  static String participationPendingPayments(String eventId) => "$baseUrl/participation/pending-payments/$eventId";
  static const String participationReview = "$baseUrl/participation/review";
  static String participationFinalize(String eventId) => "$baseUrl/participation/finalize/$eventId";

  //========================================================Connections=======================================
  static const String connectionRequest = "$baseUrl/connection/request";
  static const String connectionRespond = "$baseUrl/connection/respond";
  static const String connection = "$baseUrl/connection";
  static const String connectionPending = "$baseUrl/connection/pending";
  static String connectionRemove(String id) => "$baseUrl/connection/$id";

  //========================================================Subscriptions=======================================
  static const String subscriptionSubscribe = "$baseUrl/subscription/subscribe";
  static const String subscriptionMockSubscribe = "$baseUrl/subscription/mock-subscribe";
  static const String subscriptionIapRecord = "$baseUrl/subscription/iap-record";
  static const String subscriptionRevenueCatSync = "$baseUrl/subscription/revenuecat/sync";
  static const String subscriptionStatus = "$baseUrl/subscription/status";

  //========================================================Events=======================================
  static const String eventStep1 = "$baseUrl/event/step1";
  static const String eventStep2 = "$baseUrl/event/step2";
  static const String eventStep3 = "$baseUrl/event/step3";
  static const String eventStep4 = "$baseUrl/event/step4";
  static String eventPublish(String id) => "$baseUrl/event/publish/$id";
  static const String eventCategories = "$baseUrl/event/categories";
  static const String eventList = "$baseUrl/event";
  static const String eventSuggestions = "$baseUrl/event/suggestions";
  static const String eventMine = "$baseUrl/event/mine";
  static String eventDetails(String id) => "$baseUrl/event/$id";
  static String eventDelete(String id) => "$baseUrl/event/$id";

  //========================================================Authentication=======================================
  static const String authRegister = "$baseUrl/auth/register";
  static const String authVerifyOtp = "$baseUrl/auth/verify-otp";
  static const String authResendOtp = "$baseUrl/auth/resend-otp";
  static const String authLogin = "$baseUrl/auth/login";
  static const String authRefresh = "$baseUrl/auth/refresh";
  static const String authLogout = "$baseUrl/auth/logout";
  static const String authForgotPassword = "$baseUrl/auth/forgot-password";
  static const String authResetPassword = "$baseUrl/auth/reset-password";
  static const String authMfaLogin = "$baseUrl/auth/mfa/login";
  static const String authMfaSetup = "$baseUrl/auth/mfa/setup";
  static const String authMfaVerify = "$baseUrl/auth/mfa/verify";
  static const String authMfaRequestRecoveryOtp = "$baseUrl/auth/mfa/request-recovery-otp";
  static const String authMfaVerifyRecoveryOtp = "$baseUrl/auth/mfa/verify-recovery-otp";
  static const String authMfaDisable = "$baseUrl/auth/mfa/disable";
  static const String authGoogle = "$baseUrl/auth/google";
  static const String authGoogleCallback = "$baseUrl/auth/google/callback";
  static const String authApple = "$baseUrl/auth/apple";
  static const String authAppleCallback = "$baseUrl/auth/apple/callback";

  //========================================================UserProfile=======================================
  static const String userProfile = "$baseUrl/user/profile";
  static const String userVerifyIdentity = "$baseUrl/user/verify-identity";
  static const String userMockVerifyIdentity = "$baseUrl/user/mock-verify-identity";
  static const String userStripeConnectOnboard = "$baseUrl/user/stripe-connect/onboard";
  static const String userStripeConnectStatus = "$baseUrl/user/stripe-connect/status";
  static const String userAccountDelete = "$baseUrl/user/account";
  static const String get_category="$baseUrl/event/categories";
  
  static String fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    try {
      if (url.contains('.trycloudflare.com')) {
        final uri = Uri.parse(url);
        final currentUri = Uri.parse(baseUrl);
        return url.replaceFirst(uri.host, currentUri.host).replaceFirst('http://', 'https://');
      }
    } catch (e) {
      return url;
    }
    return url;
  }
}