String url = "192.168.1.107:3000";

String apiUrl = "http://$url";

String wsUrl = "ws://$url";

String cdnUrl = "$apiUrl/cdn/";

const requestCacheDurations = {'getHomePosts': Duration(minutes: 2)};

abstract class ApiErrorConstants {
  static const notAllowed = "NOT_ALLOWED";
  static const authRequired = "AUTH_REQUIRED";
  static const accessTokenExpired = "ACCT_EXPIRED";
  static const refreshTokenExpired = "REFT_EXPIRED";
  static const inSecurePassword = "INSECURE_PWD";
  static const aborted = "ABORTED";
}

abstract class ApiConstants {
  static const dismissInterceptor = "DismissInterceptor";
  static const authorizationHeader = "Authorization";
  static final apiH = {
    'key': 'ojo-mobile',
    'value': 'by OJO dev.',
  };
}
