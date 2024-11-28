import 'package:flutter/material.dart';
import 'package:staygo/kost/detailkost.dart';
import 'package:staygo/ojek/detailojek.dart';
import 'package:staygo/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        "/detail-kost": (context) {
          final Map<String, dynamic>? arguments = ModalRoute.of(context)
              ?.settings
              .arguments as Map<String, dynamic>?;

          // Ensure arguments are not null
          if (arguments == null ||
              arguments['accessToken'] == null ||
              arguments['kostId'] == null) {
            throw Exception(
                'Missing required arguments: accessToken or kostId');
          }

          return DetailKost(
            accessToken: arguments['accessToken'] as String,
            customerId: arguments['customerId'] as int,
            kostId: arguments['kostId'] as int,
          );
        },
        
        "/detail-ojek": (context) {
          final Map<String, dynamic>? arguments = ModalRoute.of(context)
              ?.settings
              .arguments as Map<String, dynamic>?;

          // Ensure arguments are not null
          if (arguments == null ||
              arguments['accessToken'] == null ||
              arguments['ojekId'] == null) {
            throw Exception(
                'Missing required arguments: accessToken or ojekId');
          }

          return Detailojek(
            accessToken: arguments['accessToken'] as String,
            ojekId: arguments['ojekId'] as int,
          );
        },
      },
    );
  }
}
