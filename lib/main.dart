import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'screens/signup_screen.dart';
import 'screens/role_selection_screen.dart';
import 'services/auth_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCiDfHVTszJWMQBk21vk2rM8RxJT6fUTIk",
          authDomain: "elderease-fbba4.firebaseapp.com",
          projectId: "elderease-fbba4",
          storageBucket: "elderease-fbba4.firebasestorage.app",
          messagingSenderId: "60801732554",
          appId: "1:60801732554:web:e89258af1889a43b8e0933",
          measurementId: "G-G0H5XX0CX5",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase init failed: \$e");
  }

  await notificationService.init();

  runApp(const ProviderScope(child: ElderEaseApp()));
}

class ElderEaseApp extends ConsumerWidget {
  const ElderEaseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'ElderEase',
      locale: locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', 'TW'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.premiumTheme,
      home: StreamBuilder(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          // If connection is waiting, show loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          // If we have a user, go to RoleSelectionScreen
          if (snapshot.hasData && snapshot.data != null) {
            return const RoleSelectionScreen();
          }
          
          // Otherwise, show SignUpScreen
          return const SignUpScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
