class ApiConstants {
  // Jika di Web (Chrome), gunakan localhost. Jika di HP, gunakan IP Laptop.
  static const String host = "http://192.168.43.73:8000";

  static const String baseUrl = "$host/api/";
  static const String storageUrl = "$host/storage";

  // AUTH
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String googleLogin = "auth/google";

  // USER
  static const String profile = "user";


  // OPPORTUNITY
  static const String opportunities = "opportunities";

  // APPLICATION
  static const String applications = "applications";

  // CHAT
  static const String conversations = "conversations";
  static const String messages = "messages";

  // NOTIFICATION
  static const String notifications = "notifications";
}