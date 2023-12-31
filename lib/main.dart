import 'package:database/components/Widget.dart';
import 'package:database/firebase_options.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        // Set a fixed text scale factor to disable adaptive font size
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 0, 47, 2),
        fontFamily: 'Poppins',
      ),
      home: const Widgettree(),
    );
  }
}
