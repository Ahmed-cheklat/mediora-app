import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediora/block_0/pages/signin_with_hellopage/start_page.dart';
import 'package:mediora/block_1/pages%20/homePage.dart';
import 'package:mediora/block_4/tools/notifications.dart';
import 'package:mediora/block_4/tools/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotiService().initNotifications();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(prefs),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) async {
    if (uri.scheme == 'mediora' && uri.host == 'auth') {
      final accessToken = uri.queryParameters['access_token'];
      final refreshToken = uri.queryParameters['refresh_token'];

      if (accessToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        if (refreshToken != null) {
          await prefs.setString('refresh_token', refreshToken);
        }

        _navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Homepage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          navigatorKey: _navigatorKey, // 👈 added
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: 'LineSeedJP',
            scaffoldBackgroundColor: const Color(0xFFF2F2F7),
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFFF2F2F7),
              foregroundColor: Colors.black,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            iconTheme: const IconThemeData(color: Color(0xFF2463EB)),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2463EB),
              surface: Color(0xFFF2F2F7),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'LineSeedJP',
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              foregroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E1E1E),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            iconTheme: const IconThemeData(color: Color(0xFF2463EB)),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2463EB),
              surface: const Color(0xFF1E1E1E),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: StartPage(),
        ),
      ),
    );
  }
}