import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utils/themes.dart';
import 'package:flutter_app/providers/theme_provider.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/providers/bookings_provider.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/motel_app.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // مهم للتهيئة

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase (ببيانات demo للاختبار في zapp)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ تم تهيئة Firebase بنجاح');
  } catch (e) {
    print('⚠️ Firebase غير متاح في هذه البيئة: $e');
    // في حالة فشل Firebase، سيعمل التطبيق باستخدام البيانات المحلية
  }

  // تهيئة API Service
  ApiService().initialize();

  // تهيئة بيانات التاريخ/الوقت لكل اللغات
  await initializeDateFormatting();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  runApp(_setAllProviders());
}

Widget _setAllProviders() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(
          state: AppTheme.getThemeData,
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => FavoritesProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => BookingsProvider(),
      ),
    ],
    child: MotelApp(),
  );
}
