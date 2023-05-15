import 'package:flutter/material.dart';
import 'package:kelimeezberle/pages/temprory.dart';

import 'notification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initalizeNotification();
  NotificationService().showNotification(1, 'Haydi!', ' Kelime Avla!');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kelime Ezberle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TemproryPage(),
    );
  }
}
