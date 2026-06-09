import 'package:flutter/foundation.dart';

class ApiConstants {
  // Jika di Web (Chrome), gunakan localhost. Jika di HP, gunakan IP Laptop.
  static const String host = "https://volunterapi.jiis.my.id";

  static String get baseUrl => "$host/api/";
  static String get storageUrl => "$host/storage";

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
  static const String conversations = "chats";
  static const String messages = "messages";

  // NOTIFICATION
  static const String notifications = "notifications";
}