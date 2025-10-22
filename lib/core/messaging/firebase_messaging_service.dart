import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:secure_vault_app/app/routes/app_routes.dart';

class FirebaseMessagingService {
  static Future<void> config() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(provisional: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {
      return;
    }
    if (Platform.isIOS) {
      await getToken(isAPNsToken: true);
    }
    await getToken();

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );
    FirebaseMessaging.onBackgroundMessage(onBackgroundMsg);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleDeepLink(message.data);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleDeepLink(message.data);
    });
  }

  static int attemptsAPNS = 0;
  static int attemptsToken = 0;
  static int maxAttempts = 3;
  static Future<void> getToken({bool isAPNsToken = false}) async {
    if (isAPNsToken) {
      if (attemptsAPNS >= maxAttempts) {
        return;
      }
      attemptsAPNS++;
    } else {
      if (attemptsToken >= maxAttempts) {
        return;
      }
      attemptsToken++;
    }
    try {
      final String? token = isAPNsToken
          ? await FirebaseMessaging.instance.getAPNSToken()
          : await FirebaseMessaging.instance.getToken();
      if (token == null) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        await getToken(isAPNsToken: isAPNsToken);
      }
    } catch (e) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await getToken(isAPNsToken: isAPNsToken);
    }
  }

  static void handleDeepLink(Map<String, dynamic> data) {
    final route = data['route'];
    final user = data['user'];

    if (route != null) {
      goRouter.go('/vault', extra: user);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMsg(RemoteMessage event) async {}
}
