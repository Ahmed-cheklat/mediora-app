import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediora/block_0/pages/signin_with_hellopage/start_page.dart';
import 'package:mediora/block_5/tools/notifications.dart';
import 'package:mediora/block_5/tools/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:mediora/block_0/pages/start_page.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => Consumer<ThemeProvider>(
        // 👈 moved here
        builder: (context, themeProvider, child) => MaterialApp(
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: 'LineSeedJP',
            scaffoldBackgroundColor: const Color(0xFFF2F2F7),
            appBarTheme: AppBarTheme(backgroundColor: const Color(0xFFF2F2F7)),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'LineSeedJP',
            scaffoldBackgroundColor: Color(0xFF121212),
          ),
          debugShowCheckedModeBanner: false,

          home: StartPage(),
        ),
      ),
    );
  }
}
