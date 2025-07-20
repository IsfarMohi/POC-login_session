import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginScreen.dart';

class HomeScreen extends StatelessWidget {
  Future<Map<String, dynamic>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString('username') ?? '',
      'name': prefs.getString('name') ?? '',
      'age': prefs.getInt('age') ?? 0,
      'dob': prefs.getString('dob') ?? '',
    };
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Username: 	${user['username']}'),
                Text('Name: 	${user['name']}'),
                Text('Age: 	${user['age']}'),
                Text('Date of Birth: ${user['dob']}'),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  child: Text('Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
