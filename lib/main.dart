import 'package:daily_news/screen/detail_screen.dart';
import 'package:daily_news/screen/main_screen.dart';
import 'package:daily_news/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  ////애드몹 초기화 과정
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  ////////////////////
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily News',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainScreen(),
      },

      // 메인에서 클릭했을때 디테일스크린으로 넘겨지는 처리 만듦
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          dynamic newsItem = settings.arguments as dynamic;
          return MaterialPageRoute(
            builder: (context) {
              return DetailScreen(newsItem: newsItem);
            },
          );
        }
      },
    );
  }
}
