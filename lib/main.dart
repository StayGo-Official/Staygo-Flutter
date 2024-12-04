import 'package:flutter/material.dart';
import 'package:staygo/kost/detailkost.dart';
import 'package:staygo/ojek/detailojek.dart';
import 'package:staygo/splashscreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;

void main() async {
  await dot_env.dotenv.load(fileName: ".env");
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
                'Missing required arguments: accessToken, ojekId');
          }

          return Detailojek(
            accessToken: arguments['accessToken'] as String,
            nama: arguments['nama'] as String,
            customerId: arguments['customerId'] as int,
            ojekId: arguments['ojekId'] as int,
          );
        },
      },
    );
  }
}
