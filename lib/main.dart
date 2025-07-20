import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginScreen.dart';
import 'HomeScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fmdopknfnctoktfxspbe.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZtZG9wa25mbmN0b2t0ZnhzcGJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk5NjgyNzksImV4cCI6MjA1NTU0NDI3OX0.XdAqWSi7y5HTaW30K4nf4306LINOLvFd-kifARzQ6As',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> _checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Session Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<bool>(
        future: _checkLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.data == true) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
    );
  }
}
