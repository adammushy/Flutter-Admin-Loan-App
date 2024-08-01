class AppConstants {
  static const String appName = 'Loan App-Admin';
  static const double appVersion = 1.0;

  // Shared Preference Key
  static const String token = 'token';
  static const String user = 'user';
  static const String customer = 'customer';
  static const String isLogin = 'is_login';
  static const String isNotFirstLogin = 'is_not_firstLogin';
  static const String language = 'lang';
  static const String wallet = 'wallet';

  // API URLS
  // static const String apiBaseUrl = 'http://192.168.47.193:8000/';
  // static const String mediaBaseUrl = 'http://192.168.47.193:8000';

  // static const String apiBaseUrl = 'http://192.168.1.7:8000/';
  // static const String mediaBaseUrl = 'http://192.168.1.7:8000';
  // static const String apiBaseUrl = 'http://192.168.217.68:8000/';
  // static const String mediaBaseUrl = 'http://192.168.217.68:8000';

  static const String apiBaseUrl = 'http://157.245.109.105:7000/';
  static const String mediaBaseUrl = 'http://157.245.109.105:7000';
  static const String loginUrl = 'user-management/login-user';
  static const String deleteUSerUrl = 'user-management/delete-user';

  static const String registerMemberUrl = 'user-management/register-user';
  static const String allMemberUrl = 'user-management/user-information/all/';
  static const String getLoanUrl = 'loan-management/request-get-loan';
  static const String loanRemindUrl = 'loan-management/loan-remind';
  static const String getWalletDepositUrl = 'wallet-management/wallet-deposit';

  // wallet
  static const String getWalletUrl = 'wallet-management/create-get-wallet';

  static const String changeLoanStatusUrl =
      'loan-management/change-loan-status';
  static const String verifyPhoneUrl = 'cargo/api/request-otp';
  static const String verifyOtpUrl = 'cargo/api/verify-otp';
  static const String pendingCargoUrl =
      'cargo/api/mobile/v1/customer-cargo/?s=0&c=';
  static const String shippedCargoUrl =
      'cargo/api/mobile/v1/customer-cargo/?s=1&c=';
  static const String arrivedCargoUrl =
      'cargo/api/mobile/v1/customer-cargo/?s=2&c=';
}
