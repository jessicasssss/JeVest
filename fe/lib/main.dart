import 'package:fe/view/addtransaction.dart';
import 'package:fe/view/changepassword.dart';
import 'package:fe/view/history.dart';
import 'package:fe/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/login.dart';
import 'view/home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool valid = prefs.getBool('valid') ?? false;

  runApp(MyApp(valid: valid));
}

class MyApp extends StatelessWidget {
  final bool valid;
  const MyApp({super.key, required this.valid});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JENCE',
      theme: ThemeData(
        fontFamily: 'SF',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: valid ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginPage(title: 'Login UI'),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/change-password': (context) => const ChangePasswordPage(),
        '/new-transaction': (context) => const AddTransactionPage(),
        '/history-transaction': (context) => const HistoryPage(),
      },
    );
  }
}
