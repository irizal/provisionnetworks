import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/state_page.dart';
import 'pages/reg_vendor_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steam Iron Service',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Tetapkan route utama
      onGenerateRoute: (settings) {
        // Debug route
        print("Route: ${settings.name}");

        if (settings.name == '/register-vendor') {
          return MaterialPageRoute(builder: (context) => RegVendorPage());
        }
        return MaterialPageRoute(builder: (context) => StatePage());
      },
    );
  }
}
