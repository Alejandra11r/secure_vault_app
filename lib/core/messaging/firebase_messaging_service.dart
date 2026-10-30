import 'dart:io';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:secure_vault_app/firebase_options.dart';

class FirebaseMessagingService {
  static void Function(String route)? onNavigate;
  static void Function(String token)? onToken;
  static String? currentToken;
  static bool _configured = false;

  static Future<void> config() async {
    if (_configured) return;
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      FirebaseMessaging.onBackgroundMessage(onBackgroundMsg);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        handleDeepLink(message.data);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        handleDeepLink(message.data);
      });
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        currentToken = token;
        onToken?.call(token);
      });
      final initial = await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null) handleDeepLink(initial.data);
      final NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(provisional: true);
      final allowed =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;
      if (allowed) {
        if (Platform.isIOS) await getToken(isAPNsToken: true);
        await getToken();
        await FirebaseMessaging.instance.setAutoInitEnabled(true);
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          sound: true,
          badge: true,
        );
      }
      _configured = true;
    } catch (_) {
      // The app's local vault remains usable if FCM, permission UI, or the
      // platform service is unavailable.
    }
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
      if (token != null && !isAPNsToken) {
        currentToken = token;
        onToken?.call(token);
      }
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
    final raw = data['route'] ?? data['deep_link'];
    if (raw is! String) return;
    final uri = Uri.tryParse(raw);
    final route = uri?.path.isNotEmpty == true ? uri!.path : raw;
    // Only known in-app destinations are accepted from external messages.
    if (route == '/info' || route == 'info') onNavigate?.call('/info');
    if (route == '/vault' || route == 'vault') onNavigate?.call('/vault');
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMsg(RemoteMessage event) async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (_) {
      // Messaging is optional; no background work is required by the vault.
    }
  }
}
