import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventorapp/cart_provider.dart';
import 'package:ventorapp/home_page.dart';
import 'package:ventorapp/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('ventorBox');
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
  String? loggedInUsername = preferences.getString('loggedInUsername');

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(isLoggedIn: isLoggedIn, loggedInUsername: loggedInUsername),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? loggedInUsername;
  const MyApp({
    super.key,
    required this.isLoggedIn,
    this.loggedInUsername,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ventor App',
      debugShowCheckedModeBanner: false,
      home: isLoggedIn && loggedInUsername != null
          ? HomePage(loggedInUsername: loggedInUsername!)
          : LoginPage(),
    );
  }
}
